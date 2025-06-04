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

/**
 *
 * @author Admin
 */
public class ProductService implements IProductService {
    
    private final IProductDAO productDAO = new ProductDAO();
    
    @Override
    public List<Product> findActiveProducts() {
        List<Product> activeProducts = productDAO.findActiveProducts();
//        ErrDialog.showError("ProductService - Số sản phẩm gửi đến Servlet: " + activeProducts.size());
        return activeProducts;
    }
    
}
