package com.tourismapp.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 *
 * @author Admin
 */
public class Orders {

    private int orderId;
    private Users user;
    private LocalDateTime orderDate;
    private String status;
    private BigDecimal totalAmount;
    private String shippingAddress;

    public Orders(int orderId, Users user, LocalDateTime orderDate, String status,
            BigDecimal totalAmount, String shippingAddress) {
        this.orderId = orderId;
        this.user = user;
        this.orderDate = orderDate;
        this.status = status;
        this.totalAmount = totalAmount;
        this.shippingAddress = shippingAddress;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public Users getUser() {
        return user;
    }

    public void setUser(Users user) {
        this.user = user;
    }

    public LocalDateTime getOrderDate() {
        return orderDate;
    }

    public void setOrderDate(LocalDateTime orderDate) {
        this.orderDate = orderDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getShippingAddress() {
        return shippingAddress;
    }

    public void setShippingAddress(String shippingAddress) {
        this.shippingAddress = shippingAddress;
    }

    @Override
    public String toString() {
        return "Order{"
                + "orderId=" + orderId
                + ", user=" + (user != null ? user.getUserId() : "null")
                + ", orderDate=" + orderDate
                + ", status='" + status + '\''
                + ", totalAmount=" + totalAmount
                + ", shippingAddress='" + shippingAddress + '\''
                + '}';
    }
}
