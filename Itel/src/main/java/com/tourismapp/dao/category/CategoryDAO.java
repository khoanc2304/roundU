/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.tourismapp.dao.category;

import com.tourismapp.common.Status;
import com.tourismapp.dao.DBConnection;
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

/**
 *
 * @author Admin
 */
public class CategoryDAO implements ICategoryDAO {

    private static final String GET_ALL_CATEGORIES = "SELECT * FROM Category;";
    private static final String FIND_CATEGORY_BY_ID = "SELECT * FROM Category WHERE category_id = ?";

    @Override
    public Category mapCategory(ResultSet rs) throws SQLException {
        return new Category(
                rs.getInt("category_id"),
                rs.getString("name"),
                rs.getString("description"),
                Status.valueOf(rs.getString("status").toUpperCase())
        );
    }

    @Override
    public List<Category> getAllCategories() {
        List<Category> categories = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(GET_ALL_CATEGORIES); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Category category = mapCategory(rs);
                categories.add(category);
            }
//            ErrDialog.showError("size active products: " + activeProducts.size());
        } catch (SQLException e) {
            ErrDialog.showError("Lỗi khi truy vấn sản phẩm: " + e.getMessage());
//            e.printStackTrace(); 
        }
        return categories;
    }

    @Override
    public Optional<Category> findCategoryById(int categoryId) {
        Category category = null;
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(FIND_CATEGORY_BY_ID)) {

            ps.setInt(1, categoryId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return Optional.of(mapCategory(rs));
            }
        } catch (SQLException e) {
            ErrDialog.showError("ProductDAO findCategoryById getId fail");
        }
        return Optional.empty();
    }

    public static void main(String[] args) {
        CategoryDAO cDAO = new CategoryDAO();
//        List<Category> cs = cDAO.getAllCategories();
//        System.out.println("=== ALL Category ===");
//        for (Category c : cs) {
//            System.out.println(c);
//        }
          Optional<Category> category = cDAO.findCategoryById(1);
          ErrDialog.showError("Category : " + category.get() );
          
    }

}
