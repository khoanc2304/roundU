package com.tourismapp.repository.cart;

import com.tourismapp.entity.Cart;
import com.tourismapp.entity.CartItem;
import com.tourismapp.entity.Product;

import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.Optional;
import java.util.List;
import java.util.ArrayList;

import org.springframework.stereotype.Repository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowCallbackHandler;
import org.springframework.jdbc.core.BatchPreparedStatementSetter;
import org.springframework.dao.EmptyResultDataAccessException;
import com.tourismapp.service.product.IProductService;

/**
 * Cart DAO Implementation
 * 
 * @author Admin
 */
@Repository
public class CartRepository {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Autowired
    private IProductService productService;

    public boolean saveCart(int userId, Cart cart) {
        // First clear existing cart items for this user
        clearCart(userId);

        if (cart.getItems() == null || cart.getItems().isEmpty()) {
            return true;
        }

        // Insert new cart items
        String sql = "INSERT INTO Cart (user_id, product_id, quantity) VALUES (?, ?, ?)";
        List<CartItem> itemList = new ArrayList<>(cart.getItems());
        
        int[] updateCounts = jdbcTemplate.batchUpdate(sql, new BatchPreparedStatementSetter() {
            @Override
            public void setValues(PreparedStatement ps, int i) throws SQLException {
                CartItem item = itemList.get(i);
                ps.setInt(1, userId);
                ps.setInt(2, item.getProduct().getProductId());
                ps.setInt(3, item.getQuantity());
            }

            @Override
            public int getBatchSize() {
                return itemList.size();
            }
        });
        
        return updateCounts.length == itemList.size();
    }

    public Cart loadCart(int userId) {
        Cart cart = new Cart();
        String sql = "SELECT product_id, quantity FROM Cart WHERE user_id = ?";

        jdbcTemplate.query(sql, new RowCallbackHandler() {
            @Override
            public void processRow(java.sql.ResultSet rs) throws SQLException {
                int productId = rs.getInt("product_id");
                int quantity = rs.getInt("quantity");

                // Get product details
                Optional<Product> productOpt = productService.findProductById(productId);
                if (productOpt.isPresent()) {
                    cart.addItem(productOpt.get(), quantity);
                }
            }
        }, userId);

        return cart;
    }

    public boolean clearCart(int userId) {
        String sql = "DELETE FROM Cart WHERE user_id = ?";
        jdbcTemplate.update(sql, userId);
        return true;
    }

    public boolean addItemToCart(int userId, int productId, int quantity) {
        String checkSql = "SELECT quantity FROM Cart WHERE user_id = ? AND product_id = ?";
        String insertSql = "INSERT INTO Cart (user_id, product_id, quantity) VALUES (?, ?, ?)";
        String updateSql = "UPDATE Cart SET quantity = quantity + ? WHERE user_id = ? AND product_id = ?";

        try {
            Integer currentQuantity = jdbcTemplate.queryForObject(checkSql, Integer.class, userId, productId);
            if (currentQuantity != null) {
                // Item exists, update quantity
                jdbcTemplate.update(updateSql, quantity, userId, productId);
            }
        } catch (EmptyResultDataAccessException e) {
            // Item doesn't exist, insert new
            jdbcTemplate.update(insertSql, userId, productId, quantity);
        }
        
        return true;
    }

    public boolean updateCartItem(int userId, int productId, int quantity) {
        if (quantity <= 0) {
            return removeCartItem(userId, productId);
        }
        String sql = "UPDATE Cart SET quantity = ? WHERE user_id = ? AND product_id = ?";
        return jdbcTemplate.update(sql, quantity, userId, productId) > 0;
    }

    public boolean removeCartItem(int userId, int productId) {
        String sql = "DELETE FROM Cart WHERE user_id = ? AND product_id = ?";
        return jdbcTemplate.update(sql, userId, productId) > 0;
    }
}
