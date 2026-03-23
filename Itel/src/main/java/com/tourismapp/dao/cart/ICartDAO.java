package com.tourismapp.dao.cart;

import com.tourismapp.model.Cart;

/**
 * Cart DAO Interface
 * @author Admin
 */
public interface ICartDAO {
    
    /**
     * Save cart to database (for persistent cart)
     * @param userId User ID
     * @param cart Cart object
     * @return true if successful
     */
    boolean saveCart(int userId, Cart cart);
    
    /**
     * Load cart from database
     * @param userId User ID
     * @return Cart object or null if not found
     */
    Cart loadCart(int userId);
    
    /**
     * Clear cart from database
     * @param userId User ID
     * @return true if successful
     */
    boolean clearCart(int userId);
    
    /**
     * Add item to persistent cart
     * @param userId User ID
     * @param productId Product ID
     * @param quantity Quantity
     * @return true if successful
     */
    boolean addItemToCart(int userId, int productId, int quantity);
    
    /**
     * Update item quantity in persistent cart
     * @param userId User ID
     * @param productId Product ID
     * @param quantity New quantity
     * @return true if successful
     */
    boolean updateCartItem(int userId, int productId, int quantity);
    
    /**
     * Remove item from persistent cart
     * @param userId User ID
     * @param productId Product ID
     * @return true if successful
     */
    boolean removeCartItem(int userId, int productId);
}
