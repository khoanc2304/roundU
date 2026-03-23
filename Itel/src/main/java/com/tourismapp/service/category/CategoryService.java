/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.tourismapp.service.category;

import com.tourismapp.dao.category.CategoryDAO;
import com.tourismapp.dao.category.ICategoryDAO;
import com.tourismapp.model.Category;
import java.util.List;
import java.util.Optional;

/**
 *
 * @author Admin
 */
public class CategoryService implements ICategoryService {

    private final ICategoryDAO categoryDAO = new CategoryDAO();
    
    // KHOA
    @Override
    public List<Category> getAllCategories() {
        return categoryDAO.getAllCategories();
    }

    @Override
    public Optional<Category> findCategoryById(int id) {
        return categoryDAO.findCategoryById(id);
    }
    
    
    // VINH
    @Override
    public List<Category> searchCategoriesByName(String q) {
        return categoryDAO.searchCategoriesByName(q);
    }

    @Override
    public void createCategory(Category category) {
        categoryDAO.createCategory(category);
    }

    @Override
    public boolean editCategory(Category category) {
        return categoryDAO.editCategory(category);
    }

    @Override
    public boolean deleteCategory(int categoryId) {
        return categoryDAO.deleteCategory(categoryId);
    }
}
