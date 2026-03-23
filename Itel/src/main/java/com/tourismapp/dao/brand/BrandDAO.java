/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.tourismapp.dao.brand;

import com.tourismapp.common.Status;
import com.tourismapp.dao.DBConnection;
import com.tourismapp.dao.category.CategoryDAO;
import com.tourismapp.model.Brand;
import com.tourismapp.model.Category;
import com.tourismapp.model.Product;
import com.tourismapp.utils.ErrDialog;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.logging.Logger;

/**
 *
 * @author Admin
 */
public class BrandDAO implements IBrandDAO {
    
    private static final String GET_ALL_BRANDS = "SELECT * FROM Brand;";
    private static final String FIND_BRAND_BY_ID = "SELECT * FROM Brand WHERE brand_id = ?";

    private static final String GET_ACTIVE_BRANDS = "SELECT * FROM Brand WHERE status = 'active';";
    
    // NAM
    private static final Logger LOGGER = Logger.getLogger(BrandDAO.class.getName());
    private static final String INSERT_BRAND = "INSERT INTO Brand (name, Country, description, image_url, status) VALUES (?, ?, ?, ?, ?)";
    private static final String SELECT_BRAND_BY_ID = "SELECT * FROM Brand WHERE brand_id = ?";
    private static final String SELECT_BRANDS_BY_NAME = "SELECT * FROM Brand WHERE name LIKE ?";
    private static final String UPDATE_BRAND = "UPDATE Brand SET name = ?, Country = ?, description = ?, image_url = ?, status = ? WHERE brand_id = ?";
    private static final String DELETE_BRAND = "DELETE FROM Brand WHERE brand_id = ?";
    private static final String SELECT_BRANDS_BY_COUNTRY = "SELECT * FROM Brand WHERE Country LIKE ?";
    private static final String SELECT_PRODUCTS_BY_BRAND_ID = "SELECT * FROM Product WHERE brand_id = ?";
    private static final String UPDATE_PRODUCT_STATUS = "UPDATE Product SET status = ? WHERE brand_id = ?";

    @Override
    public Brand mapBrand(ResultSet rs) throws SQLException {
        return new Brand(
                rs.getInt("brand_id"),
                rs.getString("name"),
                rs.getString("country"),
                rs.getString("description"),
                rs.getString("image_url"),
                Status.valueOf(rs.getString("status").toUpperCase())
        );
    }

    @Override
    public List<Brand> getAllBrands() {
        List<Brand> brands = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(GET_ALL_BRANDS); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Brand brand = mapBrand(rs);
                brands.add(brand);
            }
        } catch (SQLException e) {
            ErrDialog.showError("Lỗi khi truy vấn sản phẩm: " + e.getMessage());
        }
        return brands;
    }

    @Override
    public Optional<Brand> findBrandById(int brandId) {
        Brand brand = null;
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(FIND_BRAND_BY_ID)) {

            ps.setInt(1, brandId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return Optional.of(mapBrand(rs));
            }
        } catch (SQLException e) {
            ErrDialog.showError("PBrandDAO findBrandById getId fail");
        }
        return Optional.empty();
    }
    
    @Override
    public List<Brand> getActiveBrands() {
        List<Brand> activeBrands = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(GET_ACTIVE_BRANDS); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Brand brand = mapBrand(rs);
                activeBrands.add(brand);
            }
        } catch (SQLException e) {
            ErrDialog.showError("Lỗi khi truy vấn sản phẩm: " + e.getMessage());
        }
        return activeBrands;
    }
    
// =========================================== NAM =============================================
    @Override
    public void createBrand(Brand brand) {
        // Validate input
        if (brand == null) {
            throw new IllegalArgumentException("Brand cannot be null");
        }
        
        if (brand.getName() == null || brand.getName().trim().isEmpty()) {
            throw new IllegalArgumentException("Brand name cannot be null or empty");
        }
        
        if (brand.getName().trim().length() > 100) {
            throw new IllegalArgumentException("Brand name cannot exceed 100 characters");
        }
        
        if (brand.getCountry() == null || brand.getCountry().trim().isEmpty()) {
            throw new IllegalArgumentException("Country cannot be null or empty");
        }
        
        if (brand.getCountry().trim().length() > 50) {
            throw new IllegalArgumentException("Country name cannot exceed 50 characters");
        }
        
        if (brand.getDescription() == null || brand.getDescription().trim().isEmpty()) {
            throw new IllegalArgumentException("Description cannot be null or empty");
        }
        
        if (brand.getDescription().trim().length() > 500) {
            throw new IllegalArgumentException("Description cannot exceed 500 characters");
        }
        
        if (brand.getImageUrl() == null || brand.getImageUrl().trim().isEmpty()) {
            throw new IllegalArgumentException("Image URL cannot be null or empty");
        }
        
        if (brand.getStatus() == null) {
            throw new IllegalArgumentException("Status cannot be null");
        }
        
        validateBrandStatus(brand.getStatus());
        
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(INSERT_BRAND)) {
            stmt.setString(1, brand.getName().trim());
            stmt.setString(2, brand.getCountry().trim());
            stmt.setString(3, brand.getDescription().trim());
            stmt.setString(4, brand.getImageUrl().trim());
            stmt.setString(5, brand.getStatus().getValue());
            stmt.executeUpdate();
            LOGGER.info("Created brand: " + brand.getName());
        } catch (SQLException e) {
            LOGGER.severe("Error creating brand: " + e.getMessage());
            throw new RuntimeException("Error creating brand", e);
        }
    }

    @Override
    public Brand getBrandById(int brandId) {
        // Validate input
        if (brandId <= 0) {
            throw new IllegalArgumentException("Invalid brand ID");
        }
        
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(SELECT_BRAND_BY_ID)) {
            stmt.setInt(1, brandId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return new Brand(
                            rs.getInt("brand_id"),
                            rs.getString("name"),
                            rs.getString("Country"),
                            rs.getString("description"),
                            rs.getString("image_url"),
                            mapStatus(rs.getString("status"))
                    );
                }
            }
        } catch (SQLException e) {
            LOGGER.severe("Error retrieving brand with ID " + brandId + ": " + e.getMessage());
            throw new RuntimeException("Error retrieving brand", e);
        }
        return null;
    }

    @Override
    public List<Brand> findBrandsByName(String name) {
        // Validate input
        if (name == null) {
            throw new IllegalArgumentException("Search name cannot be null");
        }
        
        if (name.trim().isEmpty()) {
            throw new IllegalArgumentException("Search name cannot be empty");
        }
        
        if (name.trim().length() < 2) {
            throw new IllegalArgumentException("Search name must be at least 2 characters");
        }
        
        if (name.trim().length() > 50) {
            throw new IllegalArgumentException("Search name cannot exceed 50 characters");
        }
        
        List<Brand> brands = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(SELECT_BRANDS_BY_NAME)) {
            stmt.setString(1, "%" + name.trim() + "%");
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    brands.add(new Brand(
                            rs.getInt("brand_id"),
                            rs.getString("name"),
                            rs.getString("Country"),
                            rs.getString("description"),
                            rs.getString("image_url"),
                            mapStatus(rs.getString("status"))
                    ));
                }
            }
        } catch (SQLException e) {
            LOGGER.severe("Error searching brands by name '" + name + "': " + e.getMessage());
            throw new RuntimeException("Error searching brands", e);
        }
        return brands;
    }

    @Override
    public void updateBrand(Brand brand) {
        // Validate input
        if (brand == null) {
            throw new IllegalArgumentException("Brand cannot be null");
        }
        
        if (brand.getBrandId() <= 0) {
            throw new IllegalArgumentException("Invalid brand ID");
        }
        
        if (brand.getName() == null || brand.getName().trim().isEmpty()) {
            throw new IllegalArgumentException("Brand name cannot be null or empty");
        }
        
        if (brand.getName().trim().length() > 100) {
            throw new IllegalArgumentException("Brand name cannot exceed 100 characters");
        }
        
        if (brand.getStatus() == null) {
            throw new IllegalArgumentException("Status cannot be null");
        }
        
        if (brand.getCountry() != null && brand.getCountry().trim().length() > 50) {
            throw new IllegalArgumentException("Country name cannot exceed 50 characters");
        }
        
        if (brand.getDescription() != null && brand.getDescription().trim().length() > 500) {
            throw new IllegalArgumentException("Description cannot exceed 500 characters");
        }
        
        validateBrandStatus(brand.getStatus());
        
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Bắt đầu transaction

            // Check if brand exists
            Brand existingBrand = getBrandById(brand.getBrandId());
            if (existingBrand == null) {
                throw new IllegalArgumentException("Brand not found with ID: " + brand.getBrandId());
            }

            // Lấy trạng thái hiện tại của brand
            Status currentStatus = existingBrand.getStatus();

            // Cập nhật brand
            try (PreparedStatement stmt = conn.prepareStatement(UPDATE_BRAND)) {
                stmt.setString(1, brand.getName().trim());
                stmt.setString(2, brand.getCountry() != null ? brand.getCountry().trim() : "");
                stmt.setString(3, brand.getDescription() != null ? brand.getDescription().trim() : "");
                stmt.setString(4, brand.getImageUrl() != null ? brand.getImageUrl().trim() : "");
                stmt.setString(5, brand.getStatus().getValue());
                stmt.setInt(6, brand.getBrandId());
                stmt.executeUpdate();
            }

            // Xử lý trạng thái sản phẩm dựa trên trạng thái mới của brand
            if (brand.getStatus() == Status.INACTIVE &&
                currentStatus == Status.ACTIVE) {
                // Nếu brand chuyển từ ACTIVE sang INACTIVE, cập nhật tất cả sản phẩm của brand này thành INACTIVE
                try (PreparedStatement stmt = conn.prepareStatement(UPDATE_PRODUCT_STATUS)) {
                    stmt.setString(1, Status.INACTIVE.getValue());
                    stmt.setInt(2, brand.getBrandId());
                    stmt.executeUpdate();
                }
            }

            conn.commit(); // Hoàn tất transaction
            LOGGER.info("Updated brand: " + brand.getName());
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback(); // Hoàn tác nếu có lỗi
                } catch (SQLException ex) {
                    LOGGER.severe("Error rolling back transaction: " + ex.getMessage());
                }
            }
            LOGGER.severe("Error updating brand: " + e.getMessage());
            throw new RuntimeException("Error updating brand", e);
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true); // Khôi phục auto-commit
                    conn.close();
                } catch (SQLException e) {
                    LOGGER.severe("Error closing connection: " + e.getMessage());
                }
            }
        }
    }

    @Override
    public void deleteBrand(int brandId) {
        // Validate input
        if (brandId <= 0) {
            throw new IllegalArgumentException("Invalid brand ID");
        }
        
        // Check if brand exists
        Brand existingBrand = getBrandById(brandId);
        if (existingBrand == null) {
            throw new IllegalArgumentException("Brand not found with ID: " + brandId);
        }
        
        // Check if brand has associated products
        List<Product> products = getProductsByBrandId(brandId);
        if (!products.isEmpty()) {
            throw new IllegalArgumentException("Cannot delete brand. It has " + products.size() + " associated product(s)");
        }
        
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(DELETE_BRAND)) {
            stmt.setInt(1, brandId);
            int rowsAffected = stmt.executeUpdate();
            
            if (rowsAffected == 0) {
                throw new IllegalArgumentException("No brand was deleted. Brand ID: " + brandId);
            }
            
            LOGGER.info("Deleted brand with ID: " + brandId);
        } catch (SQLException e) {
            LOGGER.severe("Error deleting brand with ID " + brandId + ": " + e.getMessage());
            throw new RuntimeException("Error deleting brand", e);
        }
    }

    private void validateBrandStatus(Status status) {
        if (status != Status.ACTIVE && status != Status.INACTIVE) {
            throw new IllegalArgumentException("Invalid status for brand: " + status + ". Only ACTIVE or INACTIVE are allowed.");
        }
    }

    private Status mapStatus(String status) {
        for (Status s : Status.values()) {
            if (s.getValue().equalsIgnoreCase(status)) {
                return s;
            }
        }
        throw new IllegalArgumentException("Invalid status value in database: " + status);
    }

    @Override
    public List<Brand> findBrandsByCountry(String country) {
        // Validate input
        if (country == null) {
            throw new IllegalArgumentException("Country name cannot be null");
        }
        
        if (country.trim().isEmpty()) {
            throw new IllegalArgumentException("Country name cannot be empty");
        }
        
        if (country.trim().length() > 50) {
            throw new IllegalArgumentException("Country name cannot exceed 50 characters");
        }
        
        List<Brand> brands = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(SELECT_BRANDS_BY_COUNTRY)) {
            stmt.setString(1, "%" + country.trim() + "%");
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    brands.add(mapBrand(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.severe("Error searching brands by country '" + country + "': " + e.getMessage());
            throw new RuntimeException("Error searching brands by country", e);
        }
        return brands;
    }

    @Override
    public List<Product> getProductsByBrandId(int brandId) {
        // Validate input
        if (brandId <= 0) {
            throw new IllegalArgumentException("Invalid brand ID");
        }
        
        List<Product> products = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(SELECT_PRODUCTS_BY_BRAND_ID)) {
            stmt.setInt(1, brandId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Product product = new Product(
                            rs.getInt("product_id"),
                            rs.getString("name"),
                            rs.getString("description"),
                            rs.getBigDecimal("price"),
                            rs.getInt("stock_quantity"),
                            new Category(rs.getInt("category_id")),
                            new Brand(rs.getInt("brand_id")),
                            rs.getString("image_url"),
                            Status.valueOf(rs.getString("status").toUpperCase()),
                            rs.getTimestamp("created_at") != null ? rs.getTimestamp("created_at").toLocalDateTime() : null,
                            rs.getTimestamp("updated_at") != null ? rs.getTimestamp("updated_at").toLocalDateTime() : null
                    );
                    products.add(product);
                }
            }
        } catch (SQLException e) {
            LOGGER.severe("Error retrieving products for brand ID " + brandId + ": " + e.getMessage());
            ErrDialog.showError("Lỗi khi truy vấn sản phẩm: " + e.getMessage());
        }
        return products;
    }

    public static void main(String[] args) {
        BrandDAO bDAO = new BrandDAO();
        Optional<Brand> brand = bDAO.findBrandById(1);
        ErrDialog.showError("Bradn : " + brand.get());
    }

}
