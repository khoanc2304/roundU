/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.tourismapp.dao.brand;

import com.tourismapp.model.Brand;
import com.tourismapp.model.Product;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

/**
 *
 * @author Admin
 */
public interface IBrandDAO {
    
    Brand mapBrand(ResultSet rs) throws SQLException;

    List<Brand> getAllBrands();

    Optional<Brand> findBrandById(int brandId);
    
    
    // NAM
    void createBrand(Brand brand);

    Brand getBrandById(int brandId);

    List<Brand> findBrandsByName(String name);

    void updateBrand(Brand brand);

    void deleteBrand(int brandId);

    List<Brand> findBrandsByCountry(String country);

    List<Product> getProductsByBrandId(int brandId);

}
