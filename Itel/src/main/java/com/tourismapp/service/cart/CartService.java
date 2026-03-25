package com.tourismapp.service.cart;

import com.tourismapp.repository.cart.CartRepository;
import com.tourismapp.entity.Cart;
import com.tourismapp.entity.CartItem;
import com.tourismapp.entity.Product;
import com.tourismapp.utils.ErrDialog;
import java.util.Optional;

import org.springframework.stereotype.Service;
import org.springframework.beans.factory.annotation.Autowired;
import com.tourismapp.service.product.IProductService;

/**
 * Cart Service Implementation
 * 
 * @author Admin
 */
@Service
public class CartService implements ICartService {

    @Autowired
    private CartRepository CartRepository;

    @Autowired
    private IProductService productService;

    @Override
    public boolean saveUserCart(int userId, Cart cart) {
        try {
            return CartRepository.saveCart(userId, cart);
        } catch (Exception e) {
            ErrDialog.showError("Error in CartService.saveUserCart: " + e.getMessage());
            return false;
        }
    }

    @Override
    public Cart loadUserCart(int userId) {
        try {
            return CartRepository.loadCart(userId);
        } catch (Exception e) {
            ErrDialog.showError("Error in CartService.loadUserCart: " + e.getMessage());
            return new Cart();
        }
    }

    @Override
    public boolean clearUserCart(int userId) {
        try {
            return CartRepository.clearCart(userId);
        } catch (Exception e) {
            ErrDialog.showError("Error in CartService.clearUserCart: " + e.getMessage());
            return false;
        }
    }

    @Override
    // xử lý Id người dùng thuộc về ai, sản phẩm nào được thêm và số lượng là bao
    // nhiêu
    public boolean addItemToUserCart(int userId, Product product, int quantity) {
        try {
            // Validate input
            if (product == null || quantity <= 0) {
                return false;
            }

            // Check stock availability
            if (product.getStockQuantity() < quantity) {
                return false;
            }

            return CartRepository.addItemToCart(userId, product.getProductId(), quantity);
        } catch (Exception e) {
            ErrDialog.showError("Error in CartService.addItemToUserCart: " + e.getMessage());
            return false;
        }
    }

    @Override
    public boolean updateUserCartItem(int userId, int productId, int quantity) {
        try {
            // Lấy sản phẩm để kiểm tra stock
            Optional<Product> productOpt = productService.findProductById(productId);
            if (productOpt.isPresent()) {
                Product product = productOpt.get();
                if (quantity > product.getStockQuantity()) {
                    return false; // Không update nếu vượt stock
                }
            } else {
                return false;
            }

            return CartRepository.updateCartItem(userId, productId, quantity);
        } catch (Exception e) {
            ErrDialog.showError("Error in CartService.updateUserCartItem: " + e.getMessage());
            return false;
        }
    }

    @Override
    public boolean removeItemFromUserCart(int userId, int productId) {
        try {
            return CartRepository.removeCartItem(userId, productId);
        } catch (Exception e) {
            ErrDialog.showError("Error in CartService.removeItemFromUserCart: " + e.getMessage());
            return false;
        }
    }

    @Override
    public Cart mergeSessionCartWithUserCart(int userId, Cart sessionCart) {
        try {
            // Load user's persistent cart
            Cart userCart = loadUserCart(userId);

            // If session cart is empty, just return user cart
            if (sessionCart == null || sessionCart.isEmpty()) {
                return userCart;
            }

            // If user cart is empty, save session cart and return it
            if (userCart.isEmpty()) {
                saveUserCart(userId, sessionCart);
                return sessionCart;
            }

            // Merge carts - add session cart items to user cart
            for (CartItem sessionItem : sessionCart.getItems()) {
                Product product = sessionItem.getProduct();
                int sessionQuantity = sessionItem.getQuantity();

                // Check if item already exists in user cart
                CartItem userItem = userCart.getItem(product.getProductId());
                if (userItem != null) {
                    // Item exists, add quantities
                    int newQuantity = userItem.getQuantity() + sessionQuantity;
                    // Check stock limit
                    if (newQuantity <= product.getStockQuantity()) {
                        userCart.updateItem(product.getProductId(), newQuantity);
                    }
                } else {
                    // Item doesn't exist, add it
                    if (sessionQuantity <= product.getStockQuantity()) {
                        userCart.addItem(product, sessionQuantity);
                    }
                }
            }

            // Save merged cart to database
            saveUserCart(userId, userCart);

            return userCart;
        } catch (Exception e) {
            ErrDialog.showError("Error in CartService.mergeSessionCartWithUserCart: " + e.getMessage());
            return sessionCart != null ? sessionCart : new Cart();
        }
    }
}
