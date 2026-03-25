package com.tourismapp.entity;

import java.math.BigDecimal;
import java.time.LocalDateTime;

import jakarta.persistence.*;

@Entity
@Table(name = "Order_Detail")
public class OrderDetail {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "order_detail_id")
    private int orderDetailId;
    
    @ManyToOne
    @JoinColumn(name = "order_id")
    private Orders order;
    
    @ManyToOne
    @JoinColumn(name = "product_id")
    private Product product;
    private int quantity;
    private BigDecimal unitPrice;
    private String status;
    private LocalDateTime statusUpdateDate;

    public OrderDetail() {
    }

    public OrderDetail(int orderDetailId, Orders order, Product product, int quantity, BigDecimal unitPrice) {
        this.orderDetailId = orderDetailId;
        this.order = order;
        this.product = product;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
        this.status = "PENDING"; // Default status
        this.statusUpdateDate = LocalDateTime.now();
    }
    
    public OrderDetail(Orders order, Product product, int quantity, BigDecimal unitPrice) {
        this.order = order;
        this.product = product;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
        this.status = "PENDING"; // Default status
        this.statusUpdateDate = LocalDateTime.now();
    }

    public int getOrderDetailId() {
        return orderDetailId;
    }

    public void setOrderDetailId(int orderDetailId) {
        this.orderDetailId = orderDetailId;
    }

    public Orders getOrder() {
        return order;
    }

    public void setOrder(Orders order) {
        this.order = order;
    }

    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
    
    public BigDecimal getPrice() {
        return unitPrice;
    }
    
    public BigDecimal getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(BigDecimal unitPrice) {
        this.unitPrice = unitPrice;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
        this.statusUpdateDate = LocalDateTime.now();
    }

    public LocalDateTime getStatusUpdateDate() {
        return statusUpdateDate;
    }

    public void setStatusUpdateDate(LocalDateTime statusUpdateDate) {
        this.statusUpdateDate = statusUpdateDate;
    }

    @Override
    public String toString() {
        return "OrderDetail{"
                + "orderDetailId=" + orderDetailId
                + ", order=" + (order != null ? order.getOrderId() : "null")
                + ", product=" + (product != null ? product.getProductId() : "null")
                + ", quantity=" + quantity
                + ", unitPrice=" + unitPrice
                + ", status='" + status + '\''
                + ", statusUpdateDate=" + statusUpdateDate
                + '}';
    }
}
