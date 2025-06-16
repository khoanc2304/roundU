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
    
    
    // VINH
    private static final String CREATE_CATEGORY = "INSERT INTO Category (name, description, image_url) VALUES (?, ?, ?);";
    private static final String UPDATE_CATEGORY = "UPDATE Category SET name = ?, description = ?, image_url = ?, status = ? WHERE category_id = ?;";
    private static final String DELETE_CATEGORY = "UPDATE Category SET status = 'inactive' WHERE category_id = ?;";
    private static final String updateStatusProductSql = "UPDATE Product SET status = ? WHERE category_id = ?";
    private static final String updateStatusInactiveProductSql = "UPDATE Product SET status = 'inactive' WHERE category_id = ?";
    private static final String updateStatusCategorySql = "UPDATE Category SET status = 'inactive' WHERE category_id = ?";

    @Override
    public Category mapCategory(ResultSet rs) throws SQLException {
        return new Category(
                rs.getInt("category_id"),
                rs.getString("name"),
                rs.getString("description"),
                rs.getString("image_url"),
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

    
    // ========================================== VINH ================================================
    @Override
    public boolean createCategory(Category category) {
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(CREATE_CATEGORY)) {

            ps.setString(1, category.getName());
            ps.setString(2, category.getDescription());
            ps.setString(3, category.getImageUrl());

            int rowsInserted = ps.executeUpdate();
            return rowsInserted > 0;
        } catch (SQLException e) {
            ErrDialog.showError("Lỗi khi tạo danh mục: " + e.getMessage());
            return false;
        }
    }

    @Override
    public boolean editCategory(Category category) {
        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);  
            try (
                    PreparedStatement psCategory = conn.prepareStatement(UPDATE_CATEGORY); PreparedStatement psProduct = conn.prepareStatement(updateStatusProductSql)) {
                psCategory.setString(1, category.getName());
                psCategory.setString(2, category.getDescription());
                psCategory.setString(3, category.getImageUrl());
                psCategory.setString(4, category.getStatus().name().toLowerCase());
                psCategory.setInt(5, category.getCategoryId());
                int rowsUpdated = psCategory.executeUpdate();  // update category

                // Cập nhật tất cả sản phẩm của Category với status mới (sử dụng trạng thái của category)
                psProduct.setString(1, category.getStatus().name().toLowerCase());  // Đồng bộ status
                psProduct.setInt(2, category.getCategoryId());
                psProduct.executeUpdate(); 

                conn.commit(); 
                return rowsUpdated > 0;  
            } catch (SQLException e) {
                conn.rollback(); 
                ErrDialog.showError("Lỗi khi chỉnh sửa danh mục: " + e.getMessage());
                return false;
            }
        } catch (SQLException e) {
            ErrDialog.showError("Lỗi kết nối khi chỉnh sửa danh mục: " + e.getMessage());
            return false;
        }
    }

    @Override
    public boolean deleteCategory(int categoryId) {
        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);

            try (
                    PreparedStatement psCategory = conn.prepareStatement(updateStatusCategorySql); PreparedStatement psProduct = conn.prepareStatement(updateStatusInactiveProductSql)) {

                psCategory.setInt(1, categoryId);
                int rows1 = psCategory.executeUpdate();

                psProduct.setInt(1, categoryId);
                psProduct.executeUpdate();

                conn.commit();
                return rows1 > 0;
            } catch (SQLException e) {
                conn.rollback();
                ErrDialog.showError("Lỗi khi cập nhật trạng thái INACTIVE: " + e.getMessage());
                return false;
            }
        } catch (SQLException ex) {
            ErrDialog.showError("Lỗi kết nối khi xóa danh mục: " + ex.getMessage());
            return false;
        }
    }

    @Override
    public List<Category> searchCategoriesByName(String name) {
        List<Category> categories = new ArrayList<>();
        String searchQuery = "SELECT * FROM Category WHERE name LIKE ?";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(searchQuery)) {

            ps.setString(1, "%" + name + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                categories.add(mapCategory(rs));
            }
        } catch (SQLException e) {
            ErrDialog.showError("Lỗi khi tìm kiếm danh mục theo tên: " + e.getMessage());
        }
        return categories;
    }

    public static void main(String[] args) {
        CategoryDAO cDAO = new CategoryDAO();
//        List<Category> cs = cDAO.getAllCategories();
//        System.out.println("=== ALL Category ===");
//        for (Category c : cs) {
//            System.out.println(c);
//        }
        Optional<Category> category = cDAO.findCategoryById(1);
        ErrDialog.showError("Category : " + category.get());

    }

}
