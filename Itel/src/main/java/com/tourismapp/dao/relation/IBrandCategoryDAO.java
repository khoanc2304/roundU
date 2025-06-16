/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.tourismapp.dao.relation;

import com.tourismapp.dto.BrandCategoryDTO;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

/**
 *
 * @author Admin
 */
public interface IBrandCategoryDAO {

    BrandCategoryDTO mapBrandCategoryDTO(ResultSet rs) throws SQLException;

    List<BrandCategoryDTO> getAllBrandCategoryRelations();
    
    List<BrandCategoryDTO> getBrandsByCategoryId(int categoryId);

}
