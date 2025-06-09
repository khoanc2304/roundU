/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.tourismapp.service.brand;

import com.tourismapp.model.Brand;
import java.util.List;
import java.util.Optional;

/**
 *
 * @author Admin
 */
public interface IBrandService {
    
    List<Brand> getAllBrands();
    
    Optional<Brand> findBrandById(int id);
}
