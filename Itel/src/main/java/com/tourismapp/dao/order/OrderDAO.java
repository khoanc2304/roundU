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
import java.math.BigDecimal;
import java.math.RoundingMode;

import com.tourismapp.dao.DBConnection;
import com.tourismapp.dao.coupon.CouponDAO;
import com.tourismapp.dao.coupon.ICouponDAO;
import com.tourismapp.model.OrderDetail;
import com.tourismapp.model.OrderStat;
import com.tourismapp.model.Orders;
import com.tourismapp.model.Product;
import com.tourismapp.model.Users;
import com.tourismapp.model.Coupon;
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
    private static final String GET_ALL_ORDERS = "SELECT o.order_id, o.user_id, o.order_date, o.status, o.total_amount, o.shipping_address, " +
            "u.username, u.fullName, u.email " +
            "FROM Orders o " +
            "LEFT JOIN Users u ON o.user_id = u.user_id";
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
                // Tạo user object với thông tin đầy đủ
                Users user = new Users();
                user.setUserId(rs.getInt("user_id"));
                user.setUsername(rs.getString("username"));
                user.setFullName(rs.getString("fullName"));
                user.setEmail(rs.getString("email"));
                
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
                + "FROM Orders WHERE order_date IS NOT NULL and status = 'Completed' "
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
    
    public java.math.BigDecimal calculateTotalRevenue() {
        java.math.BigDecimal totalRevenue = java.math.BigDecimal.ZERO;
        String sql = "SELECT SUM(total_amount) AS total_revenue FROM Orders WHERE status = 'Completed'";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                totalRevenue = rs.getBigDecimal("total_revenue") != null ? rs.getBigDecimal("total_revenue") : java.math.BigDecimal.ZERO;
            }
        } catch (SQLException e) {
            ErrDialog.showError("Error calculating total revenue: " + e.getMessage());
        }
        return totalRevenue;
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
        String sqlUpdateOrder = "UPDATE Orders SET status = ? WHERE order_id = ?";
        String sqlGetOrderDetails = "SELECT product_id, quantity FROM Order_Detail WHERE order_id = ?";
        String sqlUpdateStock = "UPDATE Product SET stock_quantity = stock_quantity + ? WHERE product_id = ?";
        Connection conn = null;
        try {
            conn = dbConnection.getConnection();
            conn.setAutoCommit(false); // Bắt đầu giao dịch

            // Cập nhật trạng thái đơn hàng
            PreparedStatement stmtUpdateOrder = conn.prepareStatement(sqlUpdateOrder);
            stmtUpdateOrder.setString(1, status);
            stmtUpdateOrder.setInt(2, orderId);
            int rowsAffected = stmtUpdateOrder.executeUpdate();
            if (rowsAffected == 0) {
                conn.rollback();
                return false;
            }

            // Nếu trạng thái là "Canceled" hoặc "Pending" bị hủy, cộng lại stock
            if ("canceled".equals(status) || ("pending".equals(status) && !isOrderAlreadyProcessed(orderId))) { // [NOTE] Thêm kiểm tra trạng thái
                PreparedStatement stmtGetDetails = conn.prepareStatement(sqlGetOrderDetails);
                stmtGetDetails.setInt(1, orderId);
                ResultSet rs = stmtGetDetails.executeQuery();
                List<OrderDetail> orderDetails = new ArrayList<>();
                while (rs.next()) {
                    OrderDetail detail = new OrderDetail();
                    detail.setProduct(new Product()); // Tạo đối tượng Product tạm
                    detail.getProduct().setProductId(rs.getInt("product_id")); // [NOTE] Sửa cách lấy product_id
                    detail.setQuantity(rs.getInt("quantity"));
                    orderDetails.add(detail);
                }
                rs.close();

                if (!orderDetails.isEmpty()) {
                    PreparedStatement stmtUpdateStock = conn.prepareStatement(sqlUpdateStock);
                    for (OrderDetail detail : orderDetails) {
                        stmtUpdateStock.setInt(1, detail.getQuantity());
                        stmtUpdateStock.setInt(2, detail.getProduct().getProductId()); // [NOTE] Sử dụng getProduct().getProductId()
                        stmtUpdateStock.addBatch();
                    }
                    int[] updateCounts = stmtUpdateStock.executeBatch(); // [NOTE] Lưu kết quả batch để kiểm tra
                    if (updateCounts.length != orderDetails.size()) {
                        throw new SQLException("Not all stock updates were successful");
                    }
                }
            }

            conn.commit(); // Hoàn tất giao dịch
            return true;
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback(); // Hoàn tác nếu có lỗi
                } catch (SQLException ex) {
                    ErrDialog.showError("Error rolling back: " + ex.getMessage());
                }
            }
            ErrDialog.showError("Error updating order status: " + e.getMessage());
            return false;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    ErrDialog.showError("Error closing connection: " + e.getMessage());
                }
            }
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
        
        // Test getAllOrders
        System.out.println("=== Testing getAllOrders ===");
        List<Orders> allOrders = od.getAllOrders();
        System.out.println("Total orders: " + allOrders.size());
        for (Orders o: allOrders) {
            System.out.println("Order: " + o);
        }
        
        // Test getOrderStatsByMonth
        System.out.println("\n=== Testing getOrderStatsByMonth ===");
        List<OrderStat> monthStats = od.getOrderStatsByMonth();
        System.out.println("Month stats: " + monthStats.size());
        for (OrderStat stat: monthStats) {
            System.out.println("Stat: " + stat);
        }
        
        // Test getRevenueStatsByMonth
        System.out.println("\n=== Testing getRevenueStatsByMonth ===");
        List<OrderStat> revenueStats = od.getRevenueStatsByMonth();
        System.out.println("Revenue stats: " + revenueStats.size());
        for (OrderStat stat: revenueStats) {
            System.out.println("Revenue stat: " + stat);
        }
    }
    
    @Override
    public boolean updateOrderTotalAmount(int orderId, BigDecimal discountedTotal) {
        String sql = "UPDATE Orders SET total_amount = ? WHERE order_id = ?";
        
        try (Connection connection = dbConnection.getConnection(); 
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setBigDecimal(1, discountedTotal);
            statement.setInt(2, orderId);
            
            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            LOGGER.severe("Error updating order total amount: " + e.getMessage());
            ErrDialog.showError("Error updating order total amount: " + e.getMessage());
            return false;
        }
    }
    
    @Override
    public BigDecimal calculateDiscountedTotal(BigDecimal originalAmount, int membershipLevelId, String couponCode) {
        BigDecimal finalAmount = originalAmount;
        
        // Apply membership level discount
        if (membershipLevelId > 0 && membershipLevelId <= 4) {
            BigDecimal discountPercent = BigDecimal.ZERO;
            
            switch (membershipLevelId) {
                case 1: // Đồng
                    discountPercent = new BigDecimal("3");
                    break;
                case 2: // Bạc
                    discountPercent = new BigDecimal("5");
                    break;
                case 3: // Vàng
                    discountPercent = new BigDecimal("7");
                    break;
                case 4: // Kim cương
                    discountPercent = new BigDecimal("10");
                    break;
                default:
                    discountPercent = BigDecimal.ZERO;
            }
            
            if (discountPercent.compareTo(BigDecimal.ZERO) > 0) {
                BigDecimal discountFactor = discountPercent.divide(new BigDecimal("100"), 4, RoundingMode.HALF_UP);
                BigDecimal membershipDiscount = originalAmount.multiply(discountFactor).setScale(0, RoundingMode.HALF_UP);
                finalAmount = finalAmount.subtract(membershipDiscount);
                
                LOGGER.info("Applied membership discount: " + membershipDiscount + " (" + discountPercent + "%)");
            }
        }
        
        // Apply coupon discount if provided
        if (couponCode != null && !couponCode.trim().isEmpty()) {
            try {
                ICouponDAO couponDAO = new CouponDAO();
                Optional<Coupon> couponOpt = couponDAO.findCouponByCode(couponCode);
                
                if (couponOpt.isPresent()) {
                    Coupon coupon = couponOpt.get();
                    if (coupon.isActive() && coupon.isValid()) {
                        BigDecimal couponDiscountPercent = coupon.getDiscountPercent();
                        BigDecimal discountFactor = couponDiscountPercent.divide(new BigDecimal("100"), 4, RoundingMode.HALF_UP);
                        BigDecimal couponDiscount = originalAmount.multiply(discountFactor).setScale(0, RoundingMode.HALF_UP);
                        finalAmount = finalAmount.subtract(couponDiscount);
                        
                        LOGGER.info("Applied coupon discount: " + couponDiscount + " (" + couponDiscountPercent + "%)");
                    }
                }
            } catch (Exception e) {
                LOGGER.warning("Error applying coupon discount: " + e.getMessage());
            }
        }
        
        // Ensure final amount is not negative
        if (finalAmount.compareTo(BigDecimal.ZERO) < 0) {
            finalAmount = BigDecimal.ZERO;
        }
        
        LOGGER.info("Original amount: " + originalAmount + ", Final amount after discount: " + finalAmount);
        return finalAmount;
    }
    

    @Override
    public boolean isOrderAlreadyProcessed(int orderId) {
        String sql = "SELECT COUNT(*) FROM Order_Detail od JOIN Orders o ON od.order_id = o.order_id WHERE o.order_id = ? AND o.status NOT IN ('Pending', 'Canceled')";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, orderId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            ErrDialog.showError("Error checking order status: " + e.getMessage());
        }
        return false;
    }
}
    
