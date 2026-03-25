/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.tourismapp.entity;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;
import java.util.Collection;

/**
 * Shopping Cart model
 * @author Admin
 */
public class Cart {
    private Map<Integer, CartItem> items;
    private BigDecimal totalAmount;
    private int totalItems;
    
    public Cart() {
        this.items = new HashMap<>();
        this.totalAmount = BigDecimal.ZERO;
        this.totalItems = 0;
    }
    
    // Add item to cart (không tăng số lượng nếu đã có)
    public void addItem(Product product, int quantity) {
        Integer productId = product.getProductId();
        
        if (!items.containsKey(productId)) {
            // Add new item only if not exists
            CartItem newItem = new CartItem(product, quantity);
            items.put(productId, newItem);
            updateTotals();
        }
        // If item already exists, do nothing (không tăng số lượng)
    }
    
    // Add item to cart with quantity increase option
    public void addItemWithIncrease(Product product, int quantity) {
        Integer productId = product.getProductId();
        
        if (items.containsKey(productId)) {
            // Update existing item
            CartItem existingItem = items.get(productId);
            existingItem.setQuantity(existingItem.getQuantity() + quantity);
        } else {
            // Add new item
            CartItem newItem = new CartItem(product, quantity);
            items.put(productId, newItem);
        }
        
        updateTotals();
    }
    
    // Update item quantity
    public void updateItem(int productId, int quantity) {
        if (quantity <= 0) {
            removeItem(productId);
        } else {
            CartItem item = items.get(productId);
            if (item != null) {
                item.setQuantity(quantity);
                updateTotals();
            }
        }
    }
    
    // Remove item from cart
    public void removeItem(int productId) {
        items.remove(productId);
        updateTotals();
    }
    
    // Clear entire cart
    public void clear() {
        items.clear();
        updateTotals();
    }
    
    // Get all cart items
    public Collection<CartItem> getItems() {
        return items.values();
    }
    
    // Get specific item
    public CartItem getItem(int productId) {
        return items.get(productId);
    }
    
    // Check if cart is empty
    public boolean isEmpty() {
        return items.isEmpty();
    }
    
    // Get number of different products
    public int getItemCount() {
        return items.size();
    }
    
    // Update totals
    private void updateTotals() {
        totalAmount = BigDecimal.ZERO;
        totalItems = 0;
        
        for (CartItem item : items.values()) {
            totalAmount = totalAmount.add(item.getSubtotal());
            totalItems += item.getQuantity();
        }
    }
    
    // Getters
    public BigDecimal getTotalAmount() {
        return totalAmount;
    }
    
    public int getTotalItems() {
        return totalItems;
    }
    
    public Map<Integer, CartItem> getItemsMap() {
        return items;
    }
    
    @Override
    public String toString() {
        return "Cart{" +
                "items=" + items.size() +
                ", totalAmount=" + totalAmount +
                ", totalItems=" + totalItems +
                '}';
    }
}
