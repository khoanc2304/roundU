package com.tourismapp.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.ArrayList;

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
    private List<OrderDetail> orderDetails;
    private Orders order;

    public Orders(int orderId, Users user, LocalDateTime orderDate, String status,
            BigDecimal totalAmount, String shippingAddress) {
        this.orderId = orderId;
        this.user = user;
        this.orderDate = orderDate;
        this.status = status;
        this.totalAmount = totalAmount;
        this.shippingAddress = shippingAddress;
        this.orderDetails = new ArrayList<>();
    }
    
    public Orders(Users user, LocalDateTime orderDate, String status,
            BigDecimal totalAmount, String shippingAddress) {
        this.user = user;
        this.orderDate = orderDate;
        this.status = status;
        this.totalAmount = totalAmount;
        this.shippingAddress = shippingAddress;
        this.orderDetails = new ArrayList<>();
    }

    public Orders(int orderId, Users user, LocalDateTime orderDate, String status, BigDecimal totalAmount, String shippingAddress, List<OrderDetail> orderDetails, Orders order) {
        this.orderId = orderId;
        this.user = user;
        this.orderDate = orderDate;
        this.status = status;
        this.totalAmount = totalAmount;
        this.shippingAddress = shippingAddress;
        this.orderDetails = orderDetails;
        this.order = order;
    }

    public Orders getOrder() {
        return order;
    }

    public void setOrder(Orders order) {
        this.order = order;
    }
    

    public Orders(int orderId) {
        this.orderId = orderId;
        this.orderDetails = new ArrayList<>();
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

    public List<OrderDetail> getOrderDetails() {
        return orderDetails;
    }

    public void setOrderDetails(List<OrderDetail> orderDetails) {
        this.orderDetails = orderDetails;
    }

    public String getOrderDateFormatted() {
        if (orderDate == null) return "";
        return orderDate.format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));
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
