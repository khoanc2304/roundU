/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.tourismapp.dao.product;

import com.tourismapp.common.Status;
import com.tourismapp.dao.DBConnection;
import com.tourismapp.model.Attribute;
import com.tourismapp.model.Brand;
import com.tourismapp.model.Category;
import com.tourismapp.model.Product;
import com.tourismapp.model.ProductImage;
import com.tourismapp.utils.ErrDialog;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
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

    // ProductImages
    private static final String GET_PRODUCT_IMAGES_BY_ID = "SELECT * FROM ProductImages WHERE product_id = ?";
    // Product Detail -> Attribute
    private static final String GET_INFO_PRODUCT_BY_ID = """
                                                         SELECT a.name, pd.attribute_value
                                                         FROM ProductDetail pd
                                                         JOIN Attribute a ON pd.attribute_id = a.attribute_id
                                                         WHERE pd.product_id = ?;""";

    //HUY 
    private static final String GET_SIMILAR_PRODUCTS_BY_PRICE = """
    SELECT TOP %d * FROM Product
    WHERE price BETWEEN ? AND ?
    AND product_id != ?
    AND status = 'active'
    ORDER BY ABS(price - ?) ASC;
""";

    private static final String GET_SIMILAR_PRODUCTS_BY_CATEGORY = """
    SELECT TOP %d * FROM Product
    WHERE category_id = ?
    AND product_id != ?
    AND status = 'active';
""";

    private static final String GET_SIMILAR_PRODUCTS_BY_BRAND = """
    SELECT TOP %d * FROM Product
    WHERE brand_id = ?
    AND product_id != ?
    AND status = 'active'
    ORDER BY ABS(price - ?) ASC;
""";

    @Override
    public List<Product> getSimilarProductsByCategory(int categoryId, int excludeProductId, int limit) {
        List<Product> products = new ArrayList<>();
        String sql = GET_SIMILAR_PRODUCTS_BY_CATEGORY.formatted(limit);
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            ps.setInt(2, excludeProductId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                products.add(mapProduct(rs));
            }
        } catch (SQLException e) {
            ErrDialog.showError("ProductDAO getSimilarProductsByCategory fail: " + e.getMessage());
        }
        return products;
    }

    @Override
    public List<Product> getSimilarProductsByPrice(BigDecimal productPrice, int excludeProductId, int limit) {
        List<Product> products = new ArrayList<>();
        BigDecimal minPrice = productPrice.multiply(BigDecimal.valueOf(0.9));
        BigDecimal maxPrice = productPrice.multiply(BigDecimal.valueOf(1.1));
        String sql = GET_SIMILAR_PRODUCTS_BY_PRICE.formatted(limit);
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBigDecimal(1, minPrice);
            ps.setBigDecimal(2, maxPrice);
            ps.setInt(3, excludeProductId);
            ps.setBigDecimal(4, productPrice);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                products.add(mapProduct(rs));
            }
        } catch (SQLException e) {
            ErrDialog.showError("ProductDAO getSimilarProductsByPrice fail: " + e.getMessage());
        }
        return products;
    }

    @Override
    public List<Product> getSimilarProductsByBrand(int brandId, BigDecimal productPrice, int excludeProductId, int limit) {
        List<Product> products = new ArrayList<>();
        String sql = GET_SIMILAR_PRODUCTS_BY_BRAND.formatted(limit);
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, brandId);
            ps.setInt(2, excludeProductId);
            ps.setBigDecimal(3, productPrice);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                products.add(mapProduct(rs));
            }
        } catch (SQLException e) {
            ErrDialog.showError("ProductDAO getSimilarProductsByBrand fail: " + e.getMessage());
        }
        return products;
    }

    //--------------------------------------------------------------------------------------------
    @Override
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
//        Product product = null;
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

    @Override
    public Optional<List<ProductImage>> getProductImagesById(int productId) {
        List<ProductImage> productImages = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(GET_PRODUCT_IMAGES_BY_ID)) {
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ProductImage productImage = new ProductImage(
                        rs.getInt("image_id"),
                        new Product(productId),
                        rs.getString("image_url"));
                productImages.add(productImage);
            }
            return Optional.ofNullable(productImages);
        } catch (SQLException e) {
//            e.printStackTrace();
            ErrDialog.showError("ProductDAO findProductImageById getId fail");
        }
        return Optional.empty();
    }

    @Override
    public Map<String, String> getInforProductById(int productId) {
        Map<String, String> infoMap = new LinkedHashMap<>();
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(GET_INFO_PRODUCT_BY_ID)) {
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                String attributeName = rs.getString("name");
                String attributeValue = rs.getString("attribute_value");

                infoMap.put(attributeName, attributeValue != null ? attributeValue : "No value available");
            }
        } catch (SQLException e) {
//            e.printStackTrace();
            ErrDialog.showError("ProductDAO findInfoProductId getId fail");
        }
        return infoMap;
    }

//    public static void main(String[] args) {
//        ProductDAO pD = new ProductDAO();
//        Map<String, String> map = pD.getInforProductById(1);
//        for (Map.Entry<String, String> entry : map.entrySet()) {
//            Object key = entry.getKey();
//            Object val = entry.getValue();
//            System.out.println(key + " " + val);
//        }
//    }
}
