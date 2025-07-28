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
import com.tourismapp.model.OrderStat;
import com.tourismapp.model.Orders;
import com.tourismapp.model.Product;
import com.tourismapp.model.Users;
import com.tourismapp.utils.ErrDialog;
import java.util.logging.Logger;

/**
 * Order DAO Implementation
 *
 * @author Admin
 */
public class OrderDAO implements IOrderDAO {

    private final DBConnection dbConnection = new DBConnection();

    // NAM
    private static final Logger LOGGER = Logger.getLogger(OrderDAO.class.getName());
    private static final String GET_ORDERS_BY_MONTH = "SELECT YEAR(order_date) AS year, MONTH(order_date) AS month, COUNT(order_id) AS order_count "
            + "FROM Orders "
            + "WHERE order_date IS NOT NULL "
            + "GROUP BY YEAR(order_date), MONTH(order_date) "
            + "ORDER BY year, month";
    private static final String GET_ALL_ORDERS = "SELECT order_id, user_id, order_date, status, total_amount, shipping_address FROM Orders";
    private static final String GET_ORDERS_BY_STATUS = "SELECT status, COUNT(order_id) AS order_count "
            + "FROM Orders "
            + "GROUP BY status";
    private static final String GET_ORDERS_BY_PRODUCT = "SELECT od.product_id, p.name AS product_name, COUNT(DISTINCT od.order_id) AS order_count "
            + "FROM Order_Detail od "
            + "JOIN Orders o ON od.order_id = o.order_id "
            + "JOIN Product p ON od.product_id = p.product_id "
            + "GROUP BY od.product_id, p.name";

    public List<OrderStat> getOrderStatsByMonth() {
        List<OrderStat> stats = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(GET_ORDERS_BY_MONTH); ResultSet rs = stmt.executeQuery()) {
            if (!rs.isBeforeFirst()) {
                LOGGER.warning("Không có dữ liệu thống kê theo tháng trong database.");
            }
            while (rs.next()) {
                OrderStat stat = new OrderStat(rs.getInt("year"), rs.getInt("month"), rs.getInt("order_count"));
                stats.add(stat);
                LOGGER.info("Thống kê: Năm=" + stat.getYear() + ", Tháng=" + stat.getMonth() + ", Số lượng=" + stat.getOrderCount());
            }
            LOGGER.info("Tổng số thống kê theo tháng: " + stats.size());
        } catch (SQLException e) {
            LOGGER.severe("Lỗi truy vấn thống kê theo tháng: " + e.getMessage());
            throw new RuntimeException("Lỗi truy vấn thống kê theo tháng", e);
        }
        return stats;
    }

    public List<Orders> getAllOrders() {
        List<Orders> orders = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(GET_ALL_ORDERS); ResultSet rs = stmt.executeQuery()) {
            if (!rs.isBeforeFirst()) {
                LOGGER.warning("Không có dữ liệu đơn hàng trong database.");
            }
            while (rs.next()) {
                Users user = new Users(rs.getInt("user_id")); // Giả định có constructor
                Orders order = new Orders(rs.getInt("order_id"), user,
                        rs.getTimestamp("order_date") != null ? rs.getTimestamp("order_date").toLocalDateTime() : null,
                        rs.getString("status"), rs.getBigDecimal("total_amount"), rs.getString("shipping_address"));
                orders.add(order);
                LOGGER.info("Đơn hàng: " + order);
            }
            LOGGER.info("Tổng số đơn hàng: " + orders.size());
        } catch (SQLException e) {
            LOGGER.severe("Lỗi truy vấn tất cả đơn hàng: " + e.getMessage());
            throw new RuntimeException("Lỗi truy vấn tất cả đơn hàng", e);
        }
        return orders;
    }

    public List<OrderStat> getOrderStatsByStatus() {
        List<OrderStat> stats = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(GET_ORDERS_BY_STATUS); ResultSet rs = stmt.executeQuery()) {
            if (!rs.isBeforeFirst()) {
                LOGGER.warning("Không có dữ liệu thống kê theo status trong database.");
            }
            while (rs.next()) {
                OrderStat stat = new OrderStat(0, 0, rs.getInt("order_count"));
                stat.setStatus(rs.getString("status"));
                stats.add(stat);
                LOGGER.info("Thống kê theo status: Status=" + stat.getStatus() + ", Số lượng=" + stat.getOrderCount());
            }
            LOGGER.info("Tổng số thống kê theo status: " + stats.size());
        } catch (SQLException e) {
            LOGGER.severe("Lỗi truy vấn thống kê theo status: " + e.getMessage());
            throw new RuntimeException("Lỗi truy vấn thống kê theo status", e);
        }
        return stats;
    }

    public List<OrderStat> getOrderStatsByProduct() {
        List<OrderStat> stats = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(GET_ORDERS_BY_PRODUCT); ResultSet rs = stmt.executeQuery()) {
            if (!rs.isBeforeFirst()) {
                LOGGER.warning("Không có dữ liệu thống kê theo sản phẩm trong database.");
            }
            while (rs.next()) {
                OrderStat stat = new OrderStat(0, 0, rs.getInt("order_count"));
                stat.setProductId(rs.getInt("product_id"));
                // Nếu OrderStat có setProductName thì set luôn tên sản phẩm
                stat.setProductName(rs.getString("product_name"));
                stats.add(stat);
                LOGGER.info("Thống kê theo sản phẩm: ProductID=" + stat.getProductId() + ", Name=" + rs.getString("product_name") + ", Số lượng=" + stat.getOrderCount());
            }
            LOGGER.info("Tổng số thống kê theo sản phẩm: " + stats.size());
        } catch (SQLException e) {
            LOGGER.severe("Lỗi truy vấn thống kê theo sản phẩm: " + e.getMessage());
            throw new RuntimeException("Lỗi truy vấn thống kê theo sản phẩm", e);
        }
        return stats;
    }

    public List<OrderStat> getRevenueStatsByMonth() {
        String sql = "SELECT YEAR(order_date) AS year, MONTH(order_date) AS month, SUM(total_amount) AS revenue "
                + "FROM Orders WHERE order_date IS NOT NULL "
                + "GROUP BY YEAR(order_date), MONTH(order_date) ORDER BY year, month";
        List<OrderStat> stats = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                OrderStat stat = new OrderStat(rs.getInt("year"), rs.getInt("month"), 0);
                stat.setRevenue(rs.getBigDecimal("revenue"));
                stats.add(stat);
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return stats;
    }

    
    //////////////////////////////////////////// HIEU ///////////////////////////////
    @Override
    public Orders createOrder(Orders order) {
        String sql = "INSERT INTO Orders (user_id, order_date, status, total_amount, shipping_address) VALUES (?, ?, ?, ?, ?)";

        try (Connection connection = dbConnection.getConnection(); PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

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
        String sql = "SELECT o.order_id, o.user_id, o.order_date, o.status, o.total_amount, o.shipping_address, "
                + "u.username, u.fullName, u.email "
                + "FROM Orders o JOIN Users u ON o.user_id = u.user_id WHERE o.order_id = ?";

        try (Connection connection = dbConnection.getConnection(); PreparedStatement statement = connection.prepareStatement(sql)) {

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
        String sql = "SELECT o.order_id, o.user_id, o.order_date, o.status, o.total_amount, o.shipping_address, "
                + "u.username, u.fullName, u.email "
                + "FROM Orders o JOIN Users u ON o.user_id = u.user_id WHERE o.user_id = ? ORDER BY o.order_date DESC";

        System.out.println("OrderDAO.findOrdersByUserId called with userId: " + userId);
        System.out.println("SQL Query: " + sql);

        try (Connection connection = dbConnection.getConnection(); PreparedStatement statement = connection.prepareStatement(sql)) {

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
        String sql = "SELECT o.order_id, o.user_id, o.order_date, o.status, o.total_amount, o.shipping_address, "
                + "u.username, u.fullName, u.email "
                + "FROM Orders o JOIN Users u ON o.user_id = u.user_id ORDER BY o.order_date DESC";

        try (Connection connection = dbConnection.getConnection(); PreparedStatement statement = connection.prepareStatement(sql)) {

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

        try (Connection connection = dbConnection.getConnection(); PreparedStatement statement = connection.prepareStatement(sql)) {

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

        try (Connection connection = dbConnection.getConnection(); PreparedStatement statement = connection.prepareStatement(sql)) {

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

        try (Connection connection = dbConnection.getConnection(); PreparedStatement statement = connection.prepareStatement(sql)) {

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
        String sql = "SELECT od.order_detail_id, od.order_id, od.product_id, od.quantity, od.unit_price, "
                + "p.name, p.price, p.image_url "
                + "FROM Order_Detail od JOIN Product p ON od.product_id = p.product_id WHERE od.order_id = ?";

        try (Connection connection = dbConnection.getConnection(); PreparedStatement statement = connection.prepareStatement(sql)) {

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

        try (Connection connection = dbConnection.getConnection(); PreparedStatement statement = connection.prepareStatement(sql)) {

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

        try (Connection connection = dbConnection.getConnection(); PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, orderDetailId);

            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            ErrDialog.showError("Error deleting order detail: " + e.getMessage());
            return false;
        }
    }
    
    @Override
    public boolean updateOrderHistory(Orders orders,String status) {
        String sql = "UPDATE Orders SET status = ?";

        try (Connection connection = dbConnection.getConnection(); PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setString(1, orders.getStatus());
            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            ErrDialog.showError("Error updating order detail: " + e.getMessage());
            return false;
        }
    }
    
    @Override
    public List<Orders> findOrdersByStatus(String status) {
        List<Orders> orders = new ArrayList<>();
        String sql = "SELECT o.order_id, o.user_id, o.order_date, o.status, o.total_amount, o.shipping_address, "
               + "u.username, u.fullName, u.email "
               + "FROM Orders o JOIN Users u ON o.user_id = u.user_id WHERE o.status = ? ORDER BY o.order_date DESC";
        try (Connection connection = dbConnection.getConnection(); PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, status);
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
            ErrDialog.showError("Error finding orders by status: " + e.getMessage());
        }
        return orders;
    }
    
    public static void main(String[] args) {
        OrderDAO od = new OrderDAO();
        List<Orders> os = od.findAllOrders();
        for (Orders o: os) {
            System.out.println(o);
        }
    }
    
}
