/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.tourismapp.service.product;

import com.tourismapp.model.Product;
import com.tourismapp.model.ProductImage;
import java.util.List;
import java.util.Map;
import java.util.Optional;

/**
 *
 * @author Admin
 */
public interface IProductService {

    //user view
    List<Product> getActiveProducts();

    //dashborad
    Optional<Product> findProductById(int id);

    int getNextProductId();
    
    List<Product> searchActiveProductsByName(String q);

    List<Product> searchProductsByName(String q);

    List<Product> getAllProducts();

    boolean createProduct(Product product);

    boolean editProduct(Product product);

    boolean deleteProduct(int id);
    
    Optional<List<ProductImage>> getProductImagesById(int productId);
    
    Map<String, String> getInforProductById(int productId);
}
