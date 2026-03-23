/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.tourismapp.service.relation;

import com.tourismapp.dto.BrandCategoryDTO;
import java.util.List;

/**
 *
 * @author Admin
 */
public interface IBrandCategoryService {
    
    List<BrandCategoryDTO> getAllBrandCategoryRelations();
    
    List<BrandCategoryDTO> getBrandsByCategoryId(int categoryId);
    
}
