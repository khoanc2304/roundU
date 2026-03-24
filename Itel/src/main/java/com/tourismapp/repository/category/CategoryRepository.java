package com.tourismapp.repository.category;

import com.tourismapp.common.Status;
import com.tourismapp.model.Category;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

@Repository
public class CategoryRepository {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    private static final String GET_ALL_CATEGORIES = "SELECT * FROM Category;";
    private static final String FIND_CATEGORY_BY_ID = "SELECT * FROM Category WHERE category_id = ?";
    private static final String CREATE_CATEGORY = "INSERT INTO Category (name, description, image_url) VALUES (?, ?, ?);";
    private static final String UPDATE_CATEGORY = "UPDATE Category SET name = ?, description = ?, image_url = ?, status = ? WHERE category_id = ?;";
    private static final String UPDATE_STATUS_PRODUCT = "UPDATE Product SET status = ? WHERE category_id = ?";
    private static final String UPDATE_STATUS_CATEGORY_INACTIVE = "UPDATE Category SET status = 'inactive' WHERE category_id = ?";
    private static final String UPDATE_STATUS_PRODUCT_INACTIVE = "UPDATE Product SET status = 'inactive' WHERE category_id = ?";
    private static final String SEARCH_CATEGORIES_BY_NAME = "SELECT * FROM Category WHERE name LIKE ?";

    private final RowMapper<Category> categoryRowMapper = (rs, rowNum) -> mapCategory(rs);

    public Category mapCategory(ResultSet rs) throws SQLException {
        return new Category(
                rs.getInt("category_id"),
                rs.getString("name"),
                rs.getString("description"),
                rs.getString("image_url"),
                Status.valueOf(rs.getString("status").toUpperCase())
        );
    }

    public List<Category> getAllCategories() {
        return jdbcTemplate.query(GET_ALL_CATEGORIES, categoryRowMapper);
    }

    public Optional<Category> findCategoryById(int categoryId) {
        List<Category> categories = jdbcTemplate.query(FIND_CATEGORY_BY_ID, categoryRowMapper, categoryId);
        return categories.isEmpty() ? Optional.empty() : Optional.of(categories.get(0));
    }

    public boolean createCategory(Category category) {
        int rows = jdbcTemplate.update(CREATE_CATEGORY, 
                category.getName(), 
                category.getDescription(), 
                category.getImageUrl());
        return rows > 0;
    }

    public boolean editCategory(Category category) {
        int rowsCategory = jdbcTemplate.update(UPDATE_CATEGORY, 
                category.getName(), 
                category.getDescription(), 
                category.getImageUrl(), 
                category.getStatus().name().toLowerCase(), 
                category.getCategoryId());
        
        jdbcTemplate.update(UPDATE_STATUS_PRODUCT, 
                category.getStatus().name().toLowerCase(), 
                category.getCategoryId());
        
        return rowsCategory > 0;
    }

    public boolean deleteCategory(int categoryId) {
        int rowsCategory = jdbcTemplate.update(UPDATE_STATUS_CATEGORY_INACTIVE, categoryId);
        jdbcTemplate.update(UPDATE_STATUS_PRODUCT_INACTIVE, categoryId);
        return rowsCategory > 0;
    }

    public List<Category> searchCategoriesByName(String name) {
        return jdbcTemplate.query(SEARCH_CATEGORIES_BY_NAME, categoryRowMapper, "%" + name + "%");
    }
}
