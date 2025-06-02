package com.tourismapp.model;

import java.math.BigDecimal;

public class OrderDetail {

    private int orderDetailId;
    private Orders order;
    private Product product;
    private int quantity;
    private BigDecimal unitPrice;

    public OrderDetail(int orderDetailId, Orders order, Product product, int quantity, BigDecimal unitPrice) {
        this.orderDetailId = orderDetailId;
        this.order = order;
        this.product = product;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
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

    public BigDecimal getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(BigDecimal unitPrice) {
        this.unitPrice = unitPrice;
    }

    @Override
    public String toString() {
        return "OrderDetail{"
                + "orderDetailId=" + orderDetailId
                + ", order=" + (order != null ? order.getOrderId() : "null")
                + ", product=" + (product != null ? product.getProductId() : "null")
                + ", quantity=" + quantity
                + ", unitPrice=" + unitPrice
                + '}';
    }
}
