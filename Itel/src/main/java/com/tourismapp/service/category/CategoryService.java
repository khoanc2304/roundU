package com.tourismapp.service.category;

import com.tourismapp.repository.category.CategoryRepository;
import com.tourismapp.model.Category;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
public class CategoryService implements ICategoryService {

    @Autowired
    private CategoryRepository CategoryRepository;
    
    @Override
    public List<Category> getAllCategories() {
        return CategoryRepository.getAllCategories();
    }

    @Override
    public Optional<Category> findCategoryById(int id) {
        return CategoryRepository.findCategoryById(id);
    }
    
    @Override
    public List<Category> searchCategoriesByName(String q) {
        return CategoryRepository.searchCategoriesByName(q);
    }

    @Override
    @Transactional
    public void createCategory(Category category) {
        CategoryRepository.createCategory(category);
    }

    @Override
    @Transactional
    public boolean editCategory(Category category) {
        return CategoryRepository.editCategory(category);
    }

    @Override
    @Transactional
    public boolean deleteCategory(int categoryId) {
        return CategoryRepository.deleteCategory(categoryId);
    }
}
