/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.tourismapp.service.category;

import com.tourismapp.model.Category;
import java.util.List;
import java.util.Optional;

/**
 *
 * @author Admin
 */
public interface ICategoryService {
    
    // KHOA
    List<Category> getAllCategories();

    Optional<Category> findCategoryById(int id);
    
    
    // VINH
    List<Category> searchCategoriesByName(String q);

    public void createCategory(Category category);

    public boolean editCategory(Category get);

    public boolean deleteCategory(int categoryId);
}
