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
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Admin
 */
public class ProductDAO implements IProductDAO {

    private static final String SELECT_ACTIVE_PRODUCTS = "SELECT * FROM Product WHERE status = 'active';";

    public List<Product> findActiveProducts() {
        List<Product> activeProducts = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(SELECT_ACTIVE_PRODUCTS); ResultSet rs = ps.executeQuery()) {

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
                        rs.getTimestamp("created_at").toLocalDateTime(),
                        rs.getTimestamp("updated_at").toLocalDateTime()
                );
                activeProducts.add(product);
            }
//            ErrDialog.showError("size active products: " + activeProducts.size());

        } catch (SQLException e) {
            ErrDialog.showError("Lỗi khi truy vấn sản phẩm: " + e.getMessage());
//            e.printStackTrace(); 
        }

        return activeProducts;
    }

    public static void main(String[] args) {
        ProductDAO productDAO = new ProductDAO();
        List<Product> products = productDAO.findActiveProducts();
        System.out.println("=== ACTIVE PRODUCTS ===");
        for (Product p : products) {
            System.out.println(p);
        }
    }

}
