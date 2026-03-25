/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.tourismapp.repository.relation;

import com.tourismapp.repository.DBConnection;
import com.tourismapp.dto.BrandCategoryDTO;
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
import org.springframework.stereotype.Repository;

@Repository
public class BrandCategoryRepository {

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

    public BrandCategoryDTO mapBrandCategoryDTO(ResultSet rs) throws SQLException {
        return new BrandCategoryDTO(
                rs.getInt("brand_id"),
                rs.getString("brand_name"),
                rs.getString("brand_image_url"),
                rs.getString("brand_country"),
                rs.getInt("category_id"),
                rs.getString("category_name"),
                rs.getString("category_image_url")
        );
    }

    public List<BrandCategoryDTO> getAllBrandCategoryRelations() {
        List<BrandCategoryDTO> brandCategoryDTOs = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(GET_ALL_BRAND_CATEGORY_RELATIONS); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                BrandCategoryDTO brandCategoryDTO = mapBrandCategoryDTO(rs);
                brandCategoryDTOs.add(brandCategoryDTO);
            }
        } catch (SQLException e) {
            ErrDialog.showError("Lỗi khi truy vấn sản phẩm: " + e.getMessage());
        }
        return brandCategoryDTOs;
    }

    public List<BrandCategoryDTO> getBrandsByCategoryId(int categoryId) {
        List<BrandCategoryDTO> brandCategoryDTOs = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(GET_BRAND_BY_CATEGORY_ID)) {

            ps.setInt(1, categoryId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    BrandCategoryDTO brandCategoryDTO = mapBrandCategoryDTO(rs);
                    brandCategoryDTOs.add(brandCategoryDTO);
                }
            }
        } catch (SQLException e) {
            ErrDialog.showError("Lỗi khi lấy brand theo category_id: " + e.getMessage());
        }
        return brandCategoryDTOs;
    }

}
