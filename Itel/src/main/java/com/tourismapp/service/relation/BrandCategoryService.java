/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.tourismapp.service.relation;

import com.tourismapp.dao.relation.BrandCategoryDAO;
import com.tourismapp.dao.relation.IBrandCategoryDAO;
import com.tourismapp.dto.BrandCategoryDTO;
import java.util.List;

/**
 *
 * @author Admin
 */
public class BrandCategoryService implements IBrandCategoryService{
    
    private final IBrandCategoryDAO brandCategoryDAO = new BrandCategoryDAO();
    
    @Override
    public List<BrandCategoryDTO> getAllBrandCategoryRelations() {
        return brandCategoryDAO.getAllBrandCategoryRelations();
    }

    @Override
    public List<BrandCategoryDTO> getBrandsByCategoryId(int categoryId) {
        return brandCategoryDAO.getBrandsByCategoryId(categoryId);
    }
    
}

