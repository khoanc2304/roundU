package com.tourismapp.service.category;

import com.tourismapp.dao.category.ICategoryDAO;
import com.tourismapp.model.Category;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
public class CategoryService implements ICategoryService {

    @Autowired
    private ICategoryDAO categoryDAO;
    
    @Override
    public List<Category> getAllCategories() {
        return categoryDAO.getAllCategories();
    }

    @Override
    public Optional<Category> findCategoryById(int id) {
        return categoryDAO.findCategoryById(id);
    }
    
    @Override
    public List<Category> searchCategoriesByName(String q) {
        return categoryDAO.searchCategoriesByName(q);
    }

    @Override
    @Transactional
    public void createCategory(Category category) {
        categoryDAO.createCategory(category);
    }

    @Override
    @Transactional
    public boolean editCategory(Category category) {
        return categoryDAO.editCategory(category);
    }

    @Override
    @Transactional
    public boolean deleteCategory(int categoryId) {
        return categoryDAO.deleteCategory(categoryId);
    }
}
