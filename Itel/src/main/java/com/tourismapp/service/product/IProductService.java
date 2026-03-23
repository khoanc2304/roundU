/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.tourismapp.service.product;

import com.tourismapp.model.Product;
import com.tourismapp.model.ProductImage;
import java.math.BigDecimal;
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

    List<Product> getProductsByCategory(int categoryId);

    Integer mapCategoryId(String name);
    
    Integer mapBrandId(String name);

    List<String> getProductDetailByIdTop5(int productId);
    
    List<Product> filterProductsByCriteria(int categoryId, String brands, String cpus, int minPrice, int maxPrice);
    
    List<Product> getProductsByCategoryPaginated(int categoryId, int offset, int size);
    
    
    
    // HIEU
    /**
     * Update product stock quantity
     * @param productId Product ID
     * @param newStock New stock quantity
     * @return true if successful
     */
    boolean updateProductStock(int productId, int newStock);
    
    
    
    //HUY
    List<Product> getSimilarProductsByCategory(int categoryId, int excludeProductId, int limit);

    List<Product> getSimilarProductsByPrice(BigDecimal productPrice, int excludeProductId, int limit);

    List<Product> getSimilarProductsByBrand(int brandId, BigDecimal productPrice, int excludeProductId, int limit);
    
    Product getProductById(int id);

}
