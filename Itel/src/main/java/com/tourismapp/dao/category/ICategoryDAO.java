/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.tourismapp.dao.category;

import com.tourismapp.model.Category;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

/**
 *
 * @author Admin
 */
public interface ICategoryDAO {

    Category mapCategory(ResultSet rs) throws SQLException;

    List<Category> getAllCategories();

    Optional<Category> findCategoryById(int categoryId);
    
    
    // VINH
    boolean createCategory(Category category);

    boolean editCategory(Category category);

    boolean deleteCategory(int categoryId);

    List<Category> searchCategoriesByName(String name);
}
