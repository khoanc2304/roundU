/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.tourismapp.model;

import com.tourismapp.common.Status;

/**
 *
 * @author Admin
 */
public class Category {

    private int categoryId;
    private String name;
    private String description;
    private String imageUrl;
    private Status status;
    
    public Category() {
    }

    public Category(int categoryId, String name, String description, String imageUrl, Status status) {
        this.categoryId = categoryId;
        this.name = name;
        this.description = description;
        this.imageUrl = imageUrl;
        this.status = status;
    }
    
    public Category(String name, String description, String imageUrl, Status status) {
        this.name = name;
        this.description = description;
        this.imageUrl = imageUrl;
        this.status = status;
    }
    
    public Category(int categoryId, String name, String description, Status status) {
        this.categoryId = categoryId;
        this.name = name;
        this.description = description;
        this.status = status;
    }

    public Category(String name, String description, Status status) {
        this.name = name;
        this.description = description;
        this.status = status;
    }

    public Category(String name, String description) {
        this.name = name;
        this.description = description;
    }

    public Category(int categoryId) {
        this.categoryId = categoryId;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Status getStatus() {
        return status;
    }

    public void setStatus(Status status) {
        this.status = status;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    @Override
    public String toString() {
        return "Category{" + "categoryId=" + categoryId + ", name=" + name + ", description=" + description + ", status=" + status + ", imageUrl=" + imageUrl + '}';
    }

}
