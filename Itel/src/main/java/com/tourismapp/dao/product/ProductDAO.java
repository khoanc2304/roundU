/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.tourismapp.dao.product;

import com.tourismapp.common.Status;
import com.tourismapp.dao.DBConnection;
import com.tourismapp.model.Brand;
import com.tourismapp.model.Category;
import com.tourismapp.model.Product;
import com.tourismapp.utils.ErrDialog;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Admin
 */
public class ProductDAO implements IProductDAO {

    private static final String GET_ACTIVE_PRODUCTS = "SELECT * FROM Product WHERE status = 'active';";
    private static final String GET_ALL_PRODUCTS = "SELECT * FROM Product;";
    private static final String FIND_PRODUCT_BY_ID = "SELECT * FROM Product WHERE product_id = ?";
    private static final String CREATE_PRODUCT = "INSERT INTO Product (name, description, price, stock_quantity, category_id, brand_id, image_url) VALUES (?, ?, ?, ?, ?, ?, ?);";
    private static final String EDIT_PRODUCT = "UPDATE Product SET "
            + "name = ?, description = ?, price = ?, stock_quantity = ?, category_id = ?, "
            + "brand_id = ?, image_url = ?, status = ?, updated_at = GETDATE() "
            + "WHERE product_id = ?";
    private static final String DELETE_PRODUCT = "UPDATE Product SET status = 'inactive' WHERE product_id = ?;";
    private static final String GET_PRODUCT_NEXT_ID = "SELECT MAX(product_id) FROM Product";
    private static final String SEARCH_PRODUCTS_BY_NAME = "SELECT * FROM Product WHERE name LIKE ?";
    private static final String SEARCH_ACTIVE_PRODUCTS_BY_NAME = "SELECT * FROM Product WHERE name LIKE ? AND status = 'active';";

    public Product mapProduct(ResultSet rs) throws SQLException {
        return new Product(
                rs.getInt("product_id"),
                rs.getString("name"),
                rs.getString("description"),
                rs.getBigDecimal("price"),
                rs.getInt("stock_quantity"),
                new Category(rs.getInt("category_id")),
                new Brand(rs.getInt("brand_id")),
                rs.getString("image_url"),
                Status.valueOf(rs.getString("status").toUpperCase()),
                rs.getTimestamp("created_at").toLocalDateTime(),
                rs.getTimestamp("updated_at").toLocalDateTime()
        );
    }

    @Override
    public List<Product> getActiveProducts() {
        List<Product> activeProducts = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(GET_ACTIVE_PRODUCTS); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Product product = mapProduct(rs);
                activeProducts.add(product);
            }
//            ErrDialog.showError("size active products: " + activeProducts.size());
        } catch (SQLException e) {
            ErrDialog.showError("Lỗi khi truy vấn sản phẩm: " + e.getMessage());
//            e.printStackTrace(); 
        }
        return activeProducts;
    }

    @Override
    public List<Product> getAllProducts() {
        List<Product> activeProducts = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(GET_ALL_PRODUCTS); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Product product = mapProduct(rs);
                activeProducts.add(product);
            }
//            ErrDialog.showError("size active products: " + activeProducts.size());
        } catch (SQLException e) {
            ErrDialog.showError("Lỗi khi truy vấn sản phẩm: " + e.getMessage());
//            e.printStackTrace(); 
        }

        return activeProducts;
    }

    @Override
    public Optional<Product> findProductById(int productId) {
        Product product = null;
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(FIND_PRODUCT_BY_ID)) {

            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return Optional.of(mapProduct(rs));
            }
        } catch (SQLException e) {
//            e.printStackTrace();
            ErrDialog.showError("ProductDAO findProductById getId fail");
        }
        return Optional.empty();
    }

    @Override
    public boolean createProduct(Product product) {
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(CREATE_PRODUCT, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, product.getName());
            ps.setString(2, product.getDescription());
            ps.setBigDecimal(3, product.getPrice());
            ps.setInt(4, product.getStockQuantity());
            ps.setInt(5, product.getCategory().getCategoryId());
            ps.setInt(6, product.getBrand().getBrandId());
            ps.setString(7, product.getImageUrl());

            int affectedRows = ps.executeUpdate();

            if (affectedRows == 0) {
                throw new SQLException("Creating product failed, no rows affected.");
            }

            try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    product.setProductId(generatedKeys.getInt(1));
                }
            }
            return true;
        } catch (SQLException e) {
//            e.printStackTrace();
            ErrDialog.showError("ProductDAO createProduct fail");
            return false;
        }
    }

    @Override
    public boolean editProduct(Product product) {
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(EDIT_PRODUCT)) {
            ps.setString(1, product.getName());
            ps.setString(2, product.getDescription());
            ps.setBigDecimal(3, product.getPrice());
            ps.setInt(4, product.getStockQuantity());
            ps.setInt(5, product.getCategory().getCategoryId());
            ps.setInt(6, product.getBrand().getBrandId());
            ps.setString(7, product.getImageUrl());
            ps.setString(8, product.getStatus().name().toLowerCase());
            ps.setInt(9, product.getProductId());

            int rowsUpdated = ps.executeUpdate();
            return rowsUpdated > 0;
        } catch (SQLException e) {
//             e.printStackTrace();
            ErrDialog.showError("ProductDAO editProduct fail");
            return false;
        }
    }

    @Override
    public boolean deleteProduct(int id) {
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(DELETE_PRODUCT)) {
            ps.setInt(1, id);
            int rowsStatusUpdated = ps.executeUpdate();

            return rowsStatusUpdated > 0;
        } catch (SQLException e) {
//             e.printStackTrace();
            ErrDialog.showError("ProductDAO deactivateProduct: inactive -> insuccess");
            return false;
        }
    }

    @Override
    public int getNextProductId() {
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(GET_PRODUCT_NEXT_ID); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1) + 1;
            }
        } catch (SQLException e) {
//            e.printStackTrace();
            ErrDialog.showError("ProductDAO getNextProductId: fail");
        }
        return 1;  //  không có sản phẩm || null, start 1
    }

    @Override
    public List<Product> searchProductsByName(String q) {
        List<Product> qProducts = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(SEARCH_PRODUCTS_BY_NAME)) {
            stmt.setString(1, "%" + q + "%");

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Product product = mapProduct(rs);
                    qProducts.add(product);
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(ProductDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return qProducts;
    }
    
    @Override
    public List<Product> searchActiveProductsByName(String q) {
        List<Product> qProducts = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(SEARCH_ACTIVE_PRODUCTS_BY_NAME)) {
            stmt.setString(1, "%" + q + "%");

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Product product = mapProduct(rs);
                    qProducts.add(product);
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(ProductDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return qProducts;
    }

    public static void main(String[] args) {
        ProductDAO pD = new ProductDAO();
        List<Product> p = pD.searchProductsByName("mac");
        for (Product s : p) {
            System.out.println(s);
        }
    }

}
