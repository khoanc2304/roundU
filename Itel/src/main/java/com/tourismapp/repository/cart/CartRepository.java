package com.tourismapp.repository.cart;

import com.tourismapp.repository.DBConnection;
import com.tourismapp.model.Cart;
import com.tourismapp.model.CartItem;
import com.tourismapp.model.Product;
import com.tourismapp.utils.ErrDialog;

import java.sql.*;
import java.util.Optional;

import org.springframework.stereotype.Repository;
import org.springframework.beans.factory.annotation.Autowired;
import com.tourismapp.service.product.IProductService;

/**
 * Cart DAO Implementation
 * 
 * @author Admin
 */
@Repository
public class CartRepository {

    private final DBConnection dbConnection = new DBConnection();

    @Autowired
    private IProductService productService;

    public boolean saveCart(int userId, Cart cart) {
        try (Connection connection = dbConnection.getConnection()) {
            // First clear existing cart items for this user
            clearCart(userId);

            // Insert new cart items
            String sql = "INSERT INTO Cart (user_id, product_id, quantity) VALUES (?, ?, ?)";
            try (PreparedStatement statement = connection.prepareStatement(sql)) {
                for (CartItem item : cart.getItems()) {
                    statement.setInt(1, userId);
                    statement.setInt(2, item.getProduct().getProductId());
                    statement.setInt(3, item.getQuantity());
                    statement.addBatch();
                }
                statement.executeBatch();
                return true;
            }
        } catch (SQLException e) {
            // ErrDialog.showError("Error saving cart: " + e.getMessage());
            return false;
        }
    }

    public Cart loadCart(int userId) {
        Cart cart = new Cart();
        String sql = "SELECT product_id, quantity FROM Cart WHERE user_id = ?";

        try (Connection connection = dbConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, userId);
            ResultSet resultSet = statement.executeQuery();

            while (resultSet.next()) {
                int productId = resultSet.getInt("product_id");
                int quantity = resultSet.getInt("quantity");

                // Get product details
                Optional<Product> productOpt = productService.findProductById(productId);
                if (productOpt.isPresent()) {
                    cart.addItem(productOpt.get(), quantity);
                }
            }

            return cart;
        } catch (SQLException e) {
            // ErrDialog.showError("Error loading cart: " + e.getMessage());
            return new Cart();
        }
    }

    public boolean clearCart(int userId) {
        String sql = "DELETE FROM Cart WHERE user_id = ?";

        try (Connection connection = dbConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, userId);
            statement.executeUpdate();
            return true;
        } catch (SQLException e) {
            // ErrDialog.showError("Error clearing cart: " + e.getMessage());
            return false;
        }
    }

    // lưu vào database nếu đã đăng nhập, chưa thì bắt buộc đăng nhập
    // kiểm tra sp có trong giỏ hàng hay chưa, nếu chưa thì thêm mới, có rồi thì
    // cộng dồn
    public boolean addItemToCart(int userId, int productId, int quantity) {
        String checkSql = "SELECT quantity FROM Cart WHERE user_id = ? AND product_id = ?";
        String insertSql = "INSERT INTO Cart (user_id, product_id, quantity) VALUES (?, ?, ?)";
        String updateSql = "UPDATE Cart SET quantity = quantity + ? WHERE user_id = ? AND product_id = ?";

        try (Connection connection = dbConnection.getConnection()) {
            // Check if item exists
            try (PreparedStatement checkStatement = connection.prepareStatement(checkSql)) {
                checkStatement.setInt(1, userId);
                checkStatement.setInt(2, productId);
                ResultSet resultSet = checkStatement.executeQuery();

                if (resultSet.next()) {
                    // Item exists, update quantity
                    try (PreparedStatement updateStatement = connection.prepareStatement(updateSql)) {
                        updateStatement.setInt(1, quantity);
                        updateStatement.setInt(2, userId);
                        updateStatement.setInt(3, productId);
                        updateStatement.executeUpdate();
                    }
                } else {
                    // Item doesn't exist, insert new
                    try (PreparedStatement insertStatement = connection.prepareStatement(insertSql)) {
                        insertStatement.setInt(1, userId);
                        insertStatement.setInt(2, productId);
                        insertStatement.setInt(3, quantity);
                        insertStatement.executeUpdate();
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            // ErrDialog.showError("Error adding item to cart: " + e.getMessage());
            return false;
        }
    }

    // cập nhật số lượng sản phẩm trong giỏ hàng của người dùng
    public boolean updateCartItem(int userId, int productId, int quantity) {
        if (quantity <= 0) {
            return removeCartItem(userId, productId);
        }

        String sql = "UPDATE Cart SET quantity = ? WHERE user_id = ? AND product_id = ?";

        try (Connection connection = dbConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, quantity);
            statement.setInt(2, userId);
            statement.setInt(3, productId);

            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            ErrDialog.showError("Error updating cart item: " + e.getMessage());
            return false;
        }
    }

    public boolean removeCartItem(int userId, int productId) {
        String sql = "DELETE FROM Cart WHERE user_id = ? AND product_id = ?";

        try (Connection connection = dbConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, userId);
            statement.setInt(2, productId);

            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            // ErrDialog.showError("Error removing cart item: " + e.getMessage());
            return false;
        }
    }
}
