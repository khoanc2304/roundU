package com.tourismapp.dao.order;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import com.tourismapp.dao.DBConnection;
import com.tourismapp.model.OrderDetail;
import com.tourismapp.model.Orders;
import com.tourismapp.model.Product;
import com.tourismapp.model.Users;
import com.tourismapp.utils.ErrDialog;

/**
 * Order DAO Implementation
 * @author Admin
 */
public class OrderDAO implements IOrderDAO {
    
    private final DBConnection dbConnection = new DBConnection();
    
    @Override
    public Orders createOrder(Orders order) {
        String sql = "INSERT INTO Orders (user_id, order_date, status, total_amount, shipping_address) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection connection = dbConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            statement.setInt(1, order.getUser().getUserId());
            statement.setTimestamp(2, Timestamp.valueOf(order.getOrderDate()));
            statement.setString(3, order.getStatus());
            statement.setBigDecimal(4, order.getTotalAmount());
            statement.setString(5, order.getShippingAddress());
            
            int rowsAffected = statement.executeUpdate();
            
            if (rowsAffected > 0) {
                try (ResultSet generatedKeys = statement.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        order.setOrderId(generatedKeys.getInt(1));
                        return order;
                    }
                }
            }
            
            return null;
        } catch (SQLException e) {
            ErrDialog.showError("Error creating order: " + e.getMessage());
            return null;
        }
    }
    
    @Override
    public Optional<Orders> findOrderById(int orderId) {
        String sql = "SELECT o.order_id, o.user_id, o.order_date, o.status, o.total_amount, o.shipping_address, " +
                     "u.username, u.fullName, u.email " +
                     "FROM Orders o JOIN Users u ON o.user_id = u.user_id WHERE o.order_id = ?";
        
        try (Connection connection = dbConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, orderId);
            ResultSet resultSet = statement.executeQuery();
            
            if (resultSet.next()) {
                Users user = new Users();
                user.setUserId(resultSet.getInt("user_id"));
                user.setUsername(resultSet.getString("username"));
                user.setFullName(resultSet.getString("fullName"));
                user.setEmail(resultSet.getString("email"));
                
                Orders order = new Orders(
                    resultSet.getInt("order_id"),
                    user,
                    resultSet.getTimestamp("order_date").toLocalDateTime(),
                    resultSet.getString("status"),
                    resultSet.getBigDecimal("total_amount"),
                    resultSet.getString("shipping_address")
                );
                
                return Optional.of(order);
            }
            
            return Optional.empty();
        } catch (SQLException e) {
            ErrDialog.showError("Error finding order by ID: " + e.getMessage());
            return Optional.empty();
        }
    }
    
    @Override
    public List<Orders> findOrdersByUserId(int userId) {
        List<Orders> orders = new ArrayList<>();
        String sql = "SELECT o.order_id, o.user_id, o.order_date, o.status, o.total_amount, o.shipping_address, " +
                     "u.username, u.fullName, u.email " +
                     "FROM Orders o JOIN Users u ON o.user_id = u.user_id WHERE o.user_id = ? ORDER BY o.order_date DESC";
        
        System.out.println("OrderDAO.findOrdersByUserId called with userId: " + userId);
        System.out.println("SQL Query: " + sql);
        
        try (Connection connection = dbConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, userId);
            ResultSet resultSet = statement.executeQuery();
            
            while (resultSet.next()) {
                Users user = new Users();
                user.setUserId(resultSet.getInt("user_id"));
                user.setUsername(resultSet.getString("username"));
                user.setFullName(resultSet.getString("fullName"));
                user.setEmail(resultSet.getString("email"));
                
                Orders order = new Orders(
                    resultSet.getInt("order_id"),
                    user,
                    resultSet.getTimestamp("order_date").toLocalDateTime(),
                    resultSet.getString("status"),
                    resultSet.getBigDecimal("total_amount"),
                    resultSet.getString("shipping_address")
                );
                
                orders.add(order);
                System.out.println("Found order: ID=" + order.getOrderId() + ", Status=" + order.getStatus() + ", Amount=" + order.getTotalAmount());
            }
            
            System.out.println("OrderDAO.findOrdersByUserId returning " + orders.size() + " orders");
            
        } catch (SQLException e) {
            System.err.println("SQL Error in findOrdersByUserId: " + e.getMessage());
            e.printStackTrace();
            ErrDialog.showError("Error finding orders by user ID: " + e.getMessage());
        }
        
        return orders;
    }
    
    @Override
    public List<Orders> findAllOrders() {
        List<Orders> orders = new ArrayList<>();
        String sql = "SELECT o.order_id, o.user_id, o.order_date, o.status, o.total_amount, o.shipping_address, " +
                     "u.username, u.fullName, u.email " +
                     "FROM Orders o JOIN Users u ON o.user_id = u.user_id ORDER BY o.order_date DESC";
        
        try (Connection connection = dbConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            ResultSet resultSet = statement.executeQuery();
            
            while (resultSet.next()) {
                Users user = new Users();
                user.setUserId(resultSet.getInt("user_id"));
                user.setUsername(resultSet.getString("username"));
                user.setFullName(resultSet.getString("fullName"));
                user.setEmail(resultSet.getString("email"));
                
                Orders order = new Orders(
                    resultSet.getInt("order_id"),
                    user,
                    resultSet.getTimestamp("order_date").toLocalDateTime(),
                    resultSet.getString("status"),
                    resultSet.getBigDecimal("total_amount"),
                    resultSet.getString("shipping_address")
                );
                
                orders.add(order);
            }
            
        } catch (SQLException e) {
            ErrDialog.showError("Error finding all orders: " + e.getMessage());
        }
        
        return orders;
    }
    
    @Override
    public boolean updateOrderStatus(int orderId, String status) {
        String sql = "UPDATE Orders SET status = ? WHERE order_id = ?";
        
        try (Connection connection = dbConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setString(1, status);
            statement.setInt(2, orderId);
            
            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            ErrDialog.showError("Error updating order status: " + e.getMessage());
            return false;
        }
    }
    
    @Override
    public boolean deleteOrder(int orderId) {
        String sql = "DELETE FROM Orders WHERE order_id = ?";
        
        try (Connection connection = dbConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, orderId);
            
            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            ErrDialog.showError("Error deleting order: " + e.getMessage());
            return false;
        }
    }
    
    @Override
    public boolean addOrderDetail(OrderDetail orderDetail) {
        String sql = "INSERT INTO Order_Detail (order_id, product_id, quantity, unit_price) VALUES (?, ?, ?, ?)";
        
        try (Connection connection = dbConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, orderDetail.getOrder().getOrderId());
            statement.setInt(2, orderDetail.getProduct().getProductId());
            statement.setInt(3, orderDetail.getQuantity());
            statement.setBigDecimal(4, orderDetail.getUnitPrice());
            
            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            ErrDialog.showError("Error adding order detail: " + e.getMessage());
            return false;
        }
    }
    
    @Override
    public List<OrderDetail> getOrderDetailsByOrderId(int orderId) {
        List<OrderDetail> orderDetails = new ArrayList<>();
        String sql = "SELECT od.order_detail_id, od.order_id, od.product_id, od.quantity, od.unit_price, " +
                     "p.name, p.price, p.image_url " +
                     "FROM Order_Detail od JOIN Product p ON od.product_id = p.product_id WHERE od.order_id = ?";
        
        try (Connection connection = dbConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, orderId);
            ResultSet resultSet = statement.executeQuery();
            
            while (resultSet.next()) {
                Product product = new Product();
                product.setProductId(resultSet.getInt("product_id"));
                product.setName(resultSet.getString("name"));
                product.setPrice(resultSet.getBigDecimal("price"));
                product.setImageUrl(resultSet.getString("image_url"));
                
                Orders order = new Orders(orderId);
                
                OrderDetail orderDetail = new OrderDetail(
                    resultSet.getInt("order_detail_id"),
                    order,
                    product,
                    resultSet.getInt("quantity"),
                    resultSet.getBigDecimal("unit_price")
                );
                
                orderDetails.add(orderDetail);
            }
            
        } catch (SQLException e) {
            ErrDialog.showError("Error getting order details: " + e.getMessage());
        }
        
        return orderDetails;
    }
    
    @Override
    public boolean updateOrderDetail(OrderDetail orderDetail) {
        String sql = "UPDATE Order_Detail SET quantity = ?, unit_price = ? WHERE order_detail_id = ?";
        
        try (Connection connection = dbConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, orderDetail.getQuantity());
            statement.setBigDecimal(2, orderDetail.getUnitPrice());
            statement.setInt(3, orderDetail.getOrderDetailId());
            
            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            ErrDialog.showError("Error updating order detail: " + e.getMessage());
            return false;
        }
    }
    
    @Override
    public boolean deleteOrderDetail(int orderDetailId) {
        String sql = "DELETE FROM Order_Detail WHERE order_detail_id = ?";
        
        try (Connection connection = dbConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, orderDetailId);
            
            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            ErrDialog.showError("Error deleting order detail: " + e.getMessage());
            return false;
        }
    }
}
