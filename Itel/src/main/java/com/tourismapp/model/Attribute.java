/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.tourismapp.model;

/**
 *
 * @author Admin
 */
public class Attribute {

    private int attributeId;
    private Category category;
    private String name;
    private String dataType;
    private String unit;

    public Attribute() {
    }
    
    public Attribute(int attributeId, Category category, String name, String dataType, String unit) {
        this.attributeId = attributeId;
        this.category = category;
        this.name = name;
        this.dataType = dataType;
        this.unit = unit;
    }
    
    public Attribute(Category category, String name, String dataType, String unit) {
        this.category = category;
        this.name = name;
        this.dataType = dataType;
        this.unit = unit;
    }

    public Attribute(int attributeId) {
        this.attributeId = attributeId;
    }

    public int getAttributeId() {
        return attributeId;
    }

    public void setAttributeId(int attributeId) {
        this.attributeId = attributeId;
    }

    public Category getCategory() {
        return category;
    }

    public void setCategory(Category category) {
        this.category = category;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDataType() {
        return dataType;
    }

    public void setDataType(String dataType) {
        this.dataType = dataType;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

    @Override
    public String toString() {
        return "Attribute{"
                + "attributeId=" + attributeId
                + ", category=" + category
                + ", name='" + name + '\''
                + ", dataType='" + dataType + '\''
                + ", unit='" + unit + '\''
                + '}';
    }
}
