/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.tourismapp.entity;

import jakarta.persistence.*;

/**
 *
 * @author Admin
 */
@Entity
@Table(name = "Product_Image")
public class ProductImage {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "image_id")
    private int imageId;  
    
    @ManyToOne
    @JoinColumn(name = "product_id")
    private Product product;  
    private String imageUrl;  

    public ProductImage() {
    }

    public ProductImage(int imageId, Product product, String imageUrl) {
        this.imageId = imageId;
        this.product = product;
        this.imageUrl = imageUrl;
    }

    public ProductImage(Product product, String imageUrl) {
        this.product = product;
        this.imageUrl = imageUrl;
    }

    public int getImageId() {
        return imageId;
    }

    public void setImageId(int imageId) {
        this.imageId = imageId;
    }

    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    @Override
    public String toString() {
        return "ProductImage{"
                + "imageId=" + imageId
                + ", product=" + (product != null ? product.getProductId() : "null")
                + ", imageUrl='" + imageUrl + '\''
                + '}';
    }
}
