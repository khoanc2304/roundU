/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.tourismapp.common;

/**
 *
 * @author Admin
 */
public enum UserRole {
    CUSTOMER("customer"),
    ADMIN("admin"),
    STAFF("staff");

    private final String value;

    UserRole(String value) {
        this.value = value;
    }

    public String getValue() {
        return value;
    }
}

