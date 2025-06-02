/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.tourismapp.common;

/**
 *
 * @author Admin
 */
public enum Status {
    ACTIVE("active"),
    INACTIVE("inactive"),
    PENDING("pending"),
    SHIPPED("shipped"),
    COMPLETED("completed"),
    CANCELED("canceled"),
    FAILED("failed");

    private final String value;

    Status(String value) {
        this.value = value;
    }

    public String getValue() {
        return value;
    }
}
