/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.tourismapp.common;

import static com.tourismapp.common.MembershipLevel.values;

/**
 *
 * @author Admin
 */
public enum MembershipLevel {
    BRONZE(1, "đồng"),
    SILVER(2, "bạc"),
    GOLD(3, "vàng"),
    DIAMOND(4, "kim cương");

    private final int id;
    private final String value;

    MembershipLevel(int id, String value) {
        this.id = id;
        this.value = value;
    }

    public int getId() {
        return id;
    }

    public String getValue() {
        return value;
    }
    
    public int getLevelId(){
        return id;
    }

    public static MembershipLevel fromId(int id) {
        for (MembershipLevel level : values()) {
            if (level.id == id) {
                return level;
            }
        }
        return null;
    }
}
