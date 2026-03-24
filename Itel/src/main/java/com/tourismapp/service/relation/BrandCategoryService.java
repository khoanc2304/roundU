/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.tourismapp.service.relation;

import com.tourismapp.repository.relation.BrandCategoryRepository;
import com.tourismapp.repository.relation.BrandCategoryRepository;
import com.tourismapp.dto.BrandCategoryDTO;
import java.util.List;

/**
 *
 * @author Admin
 */
public class BrandCategoryService implements IBrandCategoryService{
    
    private final BrandCategoryRepository BrandCategoryRepository = new BrandCategoryRepository();
    
    @Override
    public List<BrandCategoryDTO> getAllBrandCategoryRelations() {
        return BrandCategoryRepository.getAllBrandCategoryRelations();
    }

    @Override
    public List<BrandCategoryDTO> getBrandsByCategoryId(int categoryId) {
        return BrandCategoryRepository.getBrandsByCategoryId(categoryId);
    }
    
}

