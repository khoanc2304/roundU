/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.tourismapp.service.brand;

import com.tourismapp.dao.brand.BrandDAO;
import com.tourismapp.dao.brand.IBrandDAO;
import com.tourismapp.model.Brand;
import java.util.List;
import java.util.Optional;

/**
 *
 * @author Admin
 */
public class BrandService implements IBrandService{
    private final IBrandDAO brandDAO = new BrandDAO();

    @Override
    public List<Brand> getAllBrands() {
        return brandDAO.getAllBrands();
    }
    
    @Override
    public Optional<Brand> findBrandById(int id) {
        return brandDAO.findBrandById(id);
    }
    
}
