package com.tourismapp.service.cart;

import com.tourismapp.model.Cart;
import com.tourismapp.model.Product;

/**
 * Cart Service Interface
 * @author Admin
 */
public interface ICartService {
    
    /**
     * Save cart to database for logged-in user
     * @param userId User ID
     * @param cart Cart object
     * @return true if successful
     */
    boolean saveUserCart(int userId, Cart cart);
    
    /**
     * Load cart from database for logged-in user
     * @param userId User ID
     * @return Cart object
     */
    Cart loadUserCart(int userId);
    
    /**
     * Clear user's cart from database
     * @param userId User ID
     * @return true if successful
     */
    boolean clearUserCart(int userId);
    
    /**
     * Add item to user's persistent cart
     * @param userId User ID
     * @param product Product to add
     * @param quantity Quantity to add
     * @return true if successful
     */
    boolean addItemToUserCart(int userId, Product product, int quantity);
    
    /**
     * Update item quantity in user's cart
     * @param userId User ID
     * @param productId Product ID
     * @param quantity New quantity
     * @return true if successful
     */
    boolean updateUserCartItem(int userId, int productId, int quantity);
    
    /**
     * Remove item from user's cart
     * @param userId User ID
     * @param productId Product ID
     * @return true if successful
     */
    boolean removeItemFromUserCart(int userId, int productId);
    
    /**
     * Merge session cart with user's persistent cart when user logs in
     * @param userId User ID
     * @param sessionCart Session cart
     * @return Merged cart
     */
    Cart mergeSessionCartWithUserCart(int userId, Cart sessionCart);
}
