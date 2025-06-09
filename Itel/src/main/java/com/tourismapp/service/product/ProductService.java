/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.tourismapp.service.product;

import com.tourismapp.dao.product.IProductDAO;
import com.tourismapp.dao.product.ProductDAO;
import com.tourismapp.model.Product;
import com.tourismapp.utils.ErrDialog;
import java.sql.SQLException;
import java.util.List;
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
        List<Product> activeProducts = productDAO.getActiveProducts();
        return activeProducts;
    }

    //dashboard
    @Override
    public List<Product> getAllProducts() {
        List<Product> products = productDAO.getAllProducts();
        return products;
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

}
