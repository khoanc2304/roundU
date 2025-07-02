/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.tourismapp.common;

/**
 *
 * @author Admin
 */

public enum PaymentMethod {
    CASH("tiền mặt"), 
    BANKING("chuyển khoản"), 
    CASH_ON_DELIVERY("thanh toán khi nhận hàng"),
    MOMO("MoMo"),
    VNPAY("VNPay");

    private final String value;

    PaymentMethod(String value) {
        this.value = value;
    }

    public String getValue() {
        return value;
    }
}




