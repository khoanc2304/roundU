package com.tourismapp.dao.brand;

import com.tourismapp.common.Status;
import com.tourismapp.model.Brand;
import com.tourismapp.model.Category;
import com.tourismapp.model.Product;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Optional;
import java.util.logging.Logger;

@Repository
public class BrandDAO implements IBrandDAO {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    private static final Logger LOGGER = Logger.getLogger(BrandDAO.class.getName());

    private static final String GET_ALL_BRANDS = "SELECT * FROM Brand;";
    private static final String FIND_BRAND_BY_ID = "SELECT * FROM Brand WHERE brand_id = ?";
    private static final String GET_ACTIVE_BRANDS = "SELECT * FROM Brand WHERE status = 'active';";
    private static final String INSERT_BRAND = "INSERT INTO Brand (name, Country, description, image_url, status) VALUES (?, ?, ?, ?, ?)";
    private static final String SELECT_BRANDS_BY_NAME = "SELECT * FROM Brand WHERE name LIKE ?";
    private static final String UPDATE_BRAND = "UPDATE Brand SET name = ?, Country = ?, description = ?, image_url = ?, status = ? WHERE brand_id = ?";
    private static final String DELETE_BRAND = "DELETE FROM Brand WHERE brand_id = ?";
    private static final String SELECT_BRANDS_BY_COUNTRY = "SELECT * FROM Brand WHERE Country LIKE ?";
    private static final String SELECT_PRODUCTS_BY_BRAND_ID = "SELECT * FROM Product WHERE brand_id = ?";
    private static final String UPDATE_PRODUCT_STATUS = "UPDATE Product SET status = ? WHERE brand_id = ?";

    private final RowMapper<Brand> brandRowMapper = (rs, rowNum) -> mapBrand(rs);

    @Override
    public Brand mapBrand(ResultSet rs) throws SQLException {
        return new Brand(
                rs.getInt("brand_id"),
                rs.getString("name"),
                rs.getString("country"),
                rs.getString("description"),
                rs.getString("image_url"),
                mapStatus(rs.getString("status"))
        );
    }

    private Status mapStatus(String status) {
        if (status == null) return null;
        for (Status s : Status.values()) {
            if (s.getValue().equalsIgnoreCase(status)) {
                return s;
            }
        }
        throw new IllegalArgumentException("Invalid status value in database: " + status);
    }

    @Override
    public List<Brand> getAllBrands() {
        return jdbcTemplate.query(GET_ALL_BRANDS, brandRowMapper);
    }

    @Override
    public Optional<Brand> findBrandById(int brandId) {
        List<Brand> brands = jdbcTemplate.query(FIND_BRAND_BY_ID, brandRowMapper, brandId);
        return brands.isEmpty() ? Optional.empty() : Optional.of(brands.get(0));
    }

    @Override
    public List<Brand> getActiveBrands() {
        return jdbcTemplate.query(GET_ACTIVE_BRANDS, brandRowMapper);
    }

    @Override
    public void createBrand(Brand brand) {
        validateBrand(brand);
        jdbcTemplate.update(INSERT_BRAND, 
                brand.getName().trim(), 
                brand.getCountry().trim(), 
                brand.getDescription().trim(), 
                brand.getImageUrl().trim(), 
                brand.getStatus().getValue());
        LOGGER.info("Created brand: " + brand.getName());
    }

    @Override
    public Brand getBrandById(int brandId) {
        return findBrandById(brandId).orElse(null);
    }

    @Override
    public List<Brand> findBrandsByName(String name) {
        if (name == null || name.trim().isEmpty() || name.trim().length() < 2 || name.trim().length() > 50) {
            throw new IllegalArgumentException("Invalid search name");
        }
        return jdbcTemplate.query(SELECT_BRANDS_BY_NAME, brandRowMapper, "%" + name.trim() + "%");
    }

    @Override
    public void updateBrand(Brand brand) {
        validateBrand(brand);
        
        Optional<Brand> existingOpt = findBrandById(brand.getBrandId());
        if (existingOpt.isEmpty()) {
            throw new IllegalArgumentException("Brand not found with ID: " + brand.getBrandId());
        }
        
        Status currentStatus = existingOpt.get().getStatus();

        jdbcTemplate.update(UPDATE_BRAND, 
                brand.getName().trim(), 
                brand.getCountry() != null ? brand.getCountry().trim() : "", 
                brand.getDescription() != null ? brand.getDescription().trim() : "", 
                brand.getImageUrl() != null ? brand.getImageUrl().trim() : "", 
                brand.getStatus().getValue(), 
                brand.getBrandId());
                
        if (brand.getStatus() == Status.INACTIVE && currentStatus == Status.ACTIVE) {
            jdbcTemplate.update(UPDATE_PRODUCT_STATUS, Status.INACTIVE.getValue(), brand.getBrandId());
        }
        LOGGER.info("Updated brand: " + brand.getName());
    }

    @Override
    public void deleteBrand(int brandId) {
        if (brandId <= 0) throw new IllegalArgumentException("Invalid brand ID");
        List<Product> products = getProductsByBrandId(brandId);
        if (!products.isEmpty()) {
            throw new IllegalArgumentException("Cannot delete brand. It has " + products.size() + " associated product(s)");
        }
        int rowsAffected = jdbcTemplate.update(DELETE_BRAND, brandId);
        if (rowsAffected == 0) {
            throw new IllegalArgumentException("No brand was deleted. Brand ID: " + brandId);
        }
        LOGGER.info("Deleted brand with ID: " + brandId);
    }

    @Override
    public List<Brand> findBrandsByCountry(String country) {
        if (country == null || country.trim().isEmpty() || country.trim().length() > 50) {
            throw new IllegalArgumentException("Invalid country search");
        }
        return jdbcTemplate.query(SELECT_BRANDS_BY_COUNTRY, brandRowMapper, "%" + country.trim() + "%");
    }

    @Override
    public List<Product> getProductsByBrandId(int brandId) {
        if (brandId <= 0) throw new IllegalArgumentException("Invalid brand ID");
        return jdbcTemplate.query(SELECT_PRODUCTS_BY_BRAND_ID, (rs, rowNum) -> new Product(
                rs.getInt("product_id"),
                rs.getString("name"),
                rs.getString("description"),
                rs.getBigDecimal("price"),
                rs.getInt("stock_quantity"),
                new Category(rs.getInt("category_id")),
                new Brand(rs.getInt("brand_id")),
                rs.getString("image_url"),
                mapStatus(rs.getString("status")),
                rs.getTimestamp("created_at") != null ? rs.getTimestamp("created_at").toLocalDateTime() : null,
                rs.getTimestamp("updated_at") != null ? rs.getTimestamp("updated_at").toLocalDateTime() : null
        ), brandId);
    }

    private void validateBrand(Brand brand) {
        if (brand == null || brand.getName() == null || brand.getName().trim().isEmpty() || brand.getName().trim().length() > 100) {
            throw new IllegalArgumentException("Invalid brand details");
        }
        if (brand.getStatus() != Status.ACTIVE && brand.getStatus() != Status.INACTIVE) {
            throw new IllegalArgumentException("Invalid status for brand: " + brand.getStatus() + ". Only ACTIVE or INACTIVE are allowed.");
        }
    }
}
