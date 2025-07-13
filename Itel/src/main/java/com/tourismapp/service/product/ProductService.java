/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.tourismapp.service.product;

import com.tourismapp.dao.product.IProductDAO;
import com.tourismapp.dao.product.ProductDAO;
import com.tourismapp.model.Product;
import com.tourismapp.model.ProductImage;
import com.tourismapp.utils.ErrDialog;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import java.util.Optional;

/**
 *
 * @author Admin
 */
public class ProductService implements IProductService {

    private final IProductDAO productDAO = new ProductDAO();

    //user view
    @Override
    public List<Product> getActiveProducts() {
        return productDAO.getActiveProducts();
    }

    //dashboard
    @Override
    public List<Product> getAllProducts() {
        return productDAO.getAllProducts();
    }

    @Override
    public Optional<Product> findProductById(int id) {
        return productDAO.findProductById(id);
    }

    @Override
    public List<Product> searchProductsByName(String q) {
        return productDAO.searchProductsByName(q);
    }

    @Override
    public List<Product> searchActiveProductsByName(String q) {
        return productDAO.searchActiveProductsByName(q);
    }

    @Override
    public int getNextProductId() {
        return productDAO.getNextProductId();
    }

    @Override
    public boolean createProduct(Product product) {
        return productDAO.createProduct(product);
    }

    @Override
    public boolean editProduct(Product product) {
        return productDAO.editProduct(product);
    }

    @Override
    public boolean deleteProduct(int id) {
        return productDAO.deleteProduct(id);
    }

    @Override
    public Optional<List<ProductImage>> getProductImagesById(int productId) {
        return productDAO.getProductImagesById(productId);
    }

    @Override
    public Map<String, String> getInforProductById(int productId) {
        return productDAO.getInforProductById(productId);
    }

    @Override
    public List<Product> getProductsByCategory(int categoryId) {
        return productDAO.getProductsByCategory(categoryId);
    }

    @Override
    public Integer mapCategoryId(String name) {
        return productDAO.mapCategoryId(name);
    }

    @Override
    public Integer mapBrandId(String name) {
        return productDAO.mapBrandId(name);
    }

    @Override
    public List<String> getProductDetailByIdTop5(int productId) {
        return productDAO.getProductDetailByIdTop5(productId);
    }

    @Override
    public List<Product> filterProductsByCriteria(int categoryId, String brands, String cpus, int minPrice, int maxPrice) {
        return productDAO.filterProductsByCriteria(categoryId, brands, cpus, minPrice, maxPrice);
    }

    @Override
    public List<Product> getProductsByCategoryPaginated(int categoryId, int offset, int size) {
        return productDAO.getProductsByCategoryPaginated(categoryId, offset, size);
    }
    
     @Override
    public boolean updateProductStock(int productId, int newStock) {
        return productDAO.updateProductStock(productId, newStock);
    }

    //HUY
    @Override
    public List<Product> getSimilarProductsByCategory(int categoryId, int excludeProductId, int limit) {
        return productDAO.getSimilarProductsByCategory(categoryId, excludeProductId, limit);
    }

    @Override
    public List<Product> getSimilarProductsByPrice(BigDecimal productPrice, int excludeProductId, int limit) {
        return productDAO.getSimilarProductsByPrice(productPrice, excludeProductId, limit);
    }

    @Override
    public List<Product> getSimilarProductsByBrand(int brandId, BigDecimal productPrice, int excludeProductId, int limit) {
        return productDAO.getSimilarProductsByBrand(brandId, productPrice, excludeProductId, limit);
    }

}
