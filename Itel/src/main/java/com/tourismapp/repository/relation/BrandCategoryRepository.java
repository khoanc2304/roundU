package com.tourismapp.repository.relation;

import com.tourismapp.dto.BrandCategoryDTO;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

@Repository
public class BrandCategoryRepository {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    private static final String GET_ALL_BRAND_CATEGORY_RELATIONS = """
            SELECT 
                b.brand_id, b.name AS brand_name, b.image_url AS brand_image_url, b.Country AS brand_country,
                c.category_id, c.name AS category_name, c.image_url AS category_image_url
            FROM Brand_Category bc
            JOIN Brand b ON bc.brand_id = b.brand_id
            JOIN Category c ON bc.category_id = c.category_id
            WHERE b.status = 'active' AND c.status = 'active'
        """;

    private static final String GET_BRAND_BY_CATEGORY_ID = """
            SELECT 
                b.brand_id, b.name AS brand_name, b.image_url AS brand_image_url, b.Country AS brand_country,
                c.category_id, c.name AS category_name, c.image_url AS category_image_url
            FROM Brand_Category bc
            JOIN Brand b ON bc.brand_id = b.brand_id
            JOIN Category c ON bc.category_id = c.category_id
            WHERE b.status = 'active' AND c.status = 'active' AND c.category_id = ?
        """;

    private final RowMapper<BrandCategoryDTO> brandCategoryRowMapper = (rs, rowNum) -> new BrandCategoryDTO(
            rs.getInt("brand_id"),
            rs.getString("brand_name"),
            rs.getString("brand_image_url"),
            rs.getString("brand_country"),
            rs.getInt("category_id"),
            rs.getString("category_name"),
            rs.getString("category_image_url")
    );

    public List<BrandCategoryDTO> getAllBrandCategoryRelations() {
        return jdbcTemplate.query(GET_ALL_BRAND_CATEGORY_RELATIONS, brandCategoryRowMapper);
    }

    public List<BrandCategoryDTO> getBrandsByCategoryId(int categoryId) {
        return jdbcTemplate.query(GET_BRAND_BY_CATEGORY_ID, brandCategoryRowMapper, categoryId);
    }
}
