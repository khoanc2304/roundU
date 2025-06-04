/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.tourismapp.dao.product;

import com.tourismapp.model.Product;
import java.util.List;

/**
 *
 * @author Admin
 */
public interface IProductDAO {
    //user view
    List<Product> findActiveProducts();
    
    
    //dashborad
    
    
}
