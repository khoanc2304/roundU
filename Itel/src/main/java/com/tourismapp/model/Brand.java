/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.tourismapp.model;

import com.tourismapp.common.Status;
import java.util.List;

/**
 *
 * @author Admin
 */
public class Brand {

    private int brandId;
    private String name;
    private String country;
    private String description;
    private String imageUrl;
    private Status status;
    private List<Product> productList;

    public Brand() {
    }

    public Brand(int brandId, String name, String country, String description, String imageUrl, Status status) {
        this.brandId = brandId;
        this.name = name;
        this.country = country;
        this.description = description;
        this.imageUrl = imageUrl;
        this.status = status;
    }

    public Brand(String name, String country, String description, String imageUrl, Status status) {
        this.name = name;
        this.country = country;
        this.description = description;
        this.imageUrl = imageUrl;
        this.status = status;
    }

    public Brand(int brandId) {
        this.brandId = brandId;
    }

    public int getBrandId() {
        return brandId;
    }

    public void setBrandId(int brandId) {
        this.brandId = brandId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getCountry() {
        return country;
    }

    public void setCountry(String country) {
        this.country = country;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public Status getStatus() {
        return status;
    }

    public void setStatus(Status status) {
        this.status = status;
    }

    public List<Product> getProductList() {
        return productList;
    }

    public void setProductList(List<Product> productList) {
        this.productList = productList;
    }

    @Override
    public String toString() {
        return "Brand{"
                + "brandId=" + brandId
                + ", name='" + name + '\''
                + ", country='" + country + '\''
                + ", description='" + description + '\''
                + ", imageUrl='" + imageUrl + '\''
                + ", status=" + status
                + '}';
    }
}
