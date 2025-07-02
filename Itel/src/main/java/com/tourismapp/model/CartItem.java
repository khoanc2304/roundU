package com.tourismapp.model;

import java.math.BigDecimal;

/**
 * Cart Item model for shopping cart
 * @author Admin
 */
public class CartItem {
    private Product product;
    private int quantity;
    private BigDecimal subtotal;
    
    public CartItem() {}
    
    public CartItem(Product product, int quantity) {
        this.product = product;
        this.quantity = quantity;
        this.subtotal = product.getPrice().multiply(new BigDecimal(quantity));
    }
    
    // Getters and Setters
    public Product getProduct() {
        return product;
    }
    
    public void setProduct(Product product) {
        this.product = product;
        calculateSubtotal();
    }
    
    public int getQuantity() {
        return quantity;
    }
    
    public void setQuantity(int quantity) {
        this.quantity = quantity;
        calculateSubtotal();
    }
    
    public BigDecimal getSubtotal() {
        return subtotal;
    }
    
    public void setSubtotal(BigDecimal subtotal) {
        this.subtotal = subtotal;
    }
    
    // Calculate subtotal when product or quantity changes
    private void calculateSubtotal() {
        if (product != null && product.getPrice() != null) {
            this.subtotal = product.getPrice().multiply(new BigDecimal(quantity));
        }
    }
    
    // Recalculate subtotal manually
    public void updateSubtotal() {
        calculateSubtotal();
    }
    
    @Override
    public String toString() {
        return "CartItem{" +
                "product=" + (product != null ? product.getName() : "null") +
                ", quantity=" + quantity +
                ", subtotal=" + subtotal +
                '}';
    }
}
