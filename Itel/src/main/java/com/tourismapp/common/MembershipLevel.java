/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.tourismapp.common;

/**
 *
 * @author Admin
 */
public enum MembershipLevel {
    BRONZE("đồng"),
    SILVER("bạc"),
    GOLD("vàng"),
    DIAMOND("kim cương");

    private final String value;

    MembershipLevel(String value) {
        this.value = value;
    }

    public String getValue() {
        return value;
    }
}