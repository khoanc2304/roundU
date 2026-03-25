package com.tourismapp.service.product;

import com.tourismapp.repository.product.ProductRepository;
import com.tourismapp.entity.Product;
import com.tourismapp.entity.ProductImage;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Service
public class ProductService implements IProductService {

    @Autowired
    private ProductRepository ProductRepository;

    //user view
    @Override
    public List<Product> getActiveProducts() {
        return ProductRepository.getActiveProducts();
    }

    //dashboard
    @Override
    public List<Product> getAllProducts() {
        return ProductRepository.getAllProducts();
    }

    @Override
    public Optional<Product> findProductById(int id) {
        return ProductRepository.findProductById(id);
    }

    @Override
    public List<Product> searchProductsByName(String q) {
        return ProductRepository.searchProductsByName(q);
    }

    @Override
    public List<Product> searchActiveProductsByName(String q) {
        return ProductRepository.searchActiveProductsByName(q);
    }

    @Override
    public int getNextProductId() {
        return ProductRepository.getNextProductId();
    }

    @Override
    @Transactional
    public boolean createProduct(Product product) {
        return ProductRepository.createProduct(product);
    }

    @Override
    @Transactional
    public boolean editProduct(Product product) {
        return ProductRepository.editProduct(product);
    }

    @Override
    @Transactional
    public boolean deleteProduct(int id) {
        return ProductRepository.deleteProduct(id);
    }

    @Override
    public Optional<List<ProductImage>> getProductImagesById(int productId) {
        return ProductRepository.getProductImagesById(productId);
    }

    @Override
    public Map<String, String> getInforProductById(int productId) {
        return ProductRepository.getInforProductById(productId);
    }

    @Override
    public List<Product> getProductsByCategory(int categoryId) {
        return ProductRepository.getProductsByCategory(categoryId);
    }

    @Override
    public Integer mapCategoryId(String name) {
        return ProductRepository.mapCategoryId(name);
    }

    @Override
    public Integer mapBrandId(String name) {
        return ProductRepository.mapBrandId(name);
    }

    @Override
    public List<String> getProductDetailByIdTop5(int productId) {
        return ProductRepository.getProductDetailByIdTop5(productId);
    }

    @Override
    public List<Product> filterProductsByCriteria(int categoryId, String brands, String cpus, int minPrice, int maxPrice) {
        return ProductRepository.filterProductsByCriteria(categoryId, brands, cpus, minPrice, maxPrice);
    }

    @Override
    public List<Product> getProductsByCategoryPaginated(int categoryId, int offset, int size) {
        return ProductRepository.getProductsByCategoryPaginated(categoryId, offset, size);
    }
    
     @Override
     @Transactional
    public boolean updateProductStock(int productId, int newStock) {
        return ProductRepository.updateProductStock(productId, newStock);
    }

    //HUY
    @Override
    public List<Product> getSimilarProductsByCategory(int categoryId, int excludeProductId, int limit) {
        return ProductRepository.getSimilarProductsByCategory(categoryId, excludeProductId, limit);
    }

    @Override
    public List<Product> getSimilarProductsByPrice(BigDecimal productPrice, int excludeProductId, int limit) {
        return ProductRepository.getSimilarProductsByPrice(productPrice, excludeProductId, limit);
    }

    @Override
    public List<Product> getSimilarProductsByBrand(int brandId, BigDecimal productPrice, int excludeProductId, int limit) {
        return ProductRepository.getSimilarProductsByBrand(brandId, productPrice, excludeProductId, limit);
    }
    
    @Override
    public Product getProductById(int id) {
        return findProductById(id).orElse(null);
    }

}
