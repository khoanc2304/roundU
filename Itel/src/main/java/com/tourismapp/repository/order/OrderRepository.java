package com.tourismapp.repository.order;

import com.tourismapp.entity.Coupon;
import com.tourismapp.entity.OrderDetail;
import com.tourismapp.dto.OrderStat;
import com.tourismapp.entity.Orders;
import com.tourismapp.entity.Product;
import com.tourismapp.entity.Users;
import com.tourismapp.repository.coupon.CouponRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.PreparedStatement;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.logging.Logger;

@Repository
public class OrderRepository {

    private static final Logger LOGGER = Logger.getLogger(OrderRepository.class.getName());

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Autowired
    private CouponRepository couponRepository;

    private static final String GET_ORDERS_BY_MONTH = "SELECT YEAR(order_date) AS year, MONTH(order_date) AS month, COUNT(order_id) AS order_count "
            + "FROM Orders WHERE order_date IS NOT NULL GROUP BY YEAR(order_date), MONTH(order_date) ORDER BY year, month";
            
    private static final String GET_ALL_ORDERS = "SELECT o.order_id, o.user_id, o.order_date, o.status, o.total_amount, o.shipping_address, "
            + "u.username, u.fullName, u.email FROM Orders o LEFT JOIN Users u ON o.user_id = u.user_id";
            
    private static final String GET_ORDERS_BY_STATUS = "SELECT status, COUNT(order_id) AS order_count FROM Orders GROUP BY status";
    
    private static final String GET_ORDERS_BY_PRODUCT = "SELECT od.product_id, p.name AS product_name, COUNT(DISTINCT od.order_id) AS order_count "
            + "FROM Order_Detail od JOIN Orders o ON od.order_id = o.order_id JOIN Product p ON od.product_id = p.product_id "
            + "GROUP BY od.product_id, p.name";

    private final RowMapper<Orders> orderWithUserRowMapper = (rs, rowNum) -> {
        Users user = new Users();
        user.setUserId(rs.getInt("user_id"));
        user.setUsername(rs.getString("username"));
        user.setFullName(rs.getString("fullName"));
        user.setEmail(rs.getString("email"));

        Timestamp date = rs.getTimestamp("order_date");
        return new Orders(
                rs.getInt("order_id"),
                user,
                date != null ? date.toLocalDateTime() : null,
                rs.getString("status"),
                rs.getBigDecimal("total_amount"),
                rs.getString("shipping_address")
        );
    };

    public List<OrderStat> getOrderStatsByMonth() {
        return jdbcTemplate.query(GET_ORDERS_BY_MONTH, (rs, rowNum) -> new OrderStat(rs.getInt("year"), rs.getInt("month"), rs.getInt("order_count")));
    }

    public List<Orders> getAllOrders() {
        return jdbcTemplate.query(GET_ALL_ORDERS, orderWithUserRowMapper);
    }

    public List<OrderStat> getOrderStatsByStatus() {
        return jdbcTemplate.query(GET_ORDERS_BY_STATUS, (rs, rowNum) -> {
            OrderStat stat = new OrderStat(0, 0, rs.getInt("order_count"));
            stat.setStatus(rs.getString("status"));
            return stat;
        });
    }

    public List<OrderStat> getOrderStatsByProduct() {
        return jdbcTemplate.query(GET_ORDERS_BY_PRODUCT, (rs, rowNum) -> {
            OrderStat stat = new OrderStat(0, 0, rs.getInt("order_count"));
            stat.setProductId(rs.getInt("product_id"));
            stat.setProductName(rs.getString("product_name"));
            return stat;
        });
    }

    public List<OrderStat> getRevenueStatsByMonth() {
        String sql = "SELECT YEAR(order_date) AS year, MONTH(order_date) AS month, SUM(total_amount) AS revenue "
                + "FROM Orders WHERE order_date IS NOT NULL and status = 'Completed' "
                + "GROUP BY YEAR(order_date), MONTH(order_date) ORDER BY year, month";
        return jdbcTemplate.query(sql, (rs, rowNum) -> {
            OrderStat stat = new OrderStat(rs.getInt("year"), rs.getInt("month"), 0);
            stat.setRevenue(rs.getBigDecimal("revenue"));
            return stat;
        });
    }

    public BigDecimal calculateTotalRevenue() {
        String sql = "SELECT SUM(total_amount) AS total_revenue FROM Orders WHERE status = 'Completed'";
        BigDecimal revenue = jdbcTemplate.queryForObject(sql, BigDecimal.class);
        return revenue != null ? revenue : BigDecimal.ZERO;
    }

    public Orders createOrder(Orders order) {
        String sql = "INSERT INTO Orders (user_id, order_date, status, total_amount, shipping_address) VALUES (?, ?, ?, ?, ?)";
        KeyHolder keyHolder = new GeneratedKeyHolder();

        jdbcTemplate.update(connection -> {
            PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, order.getUser().getUserId());
            ps.setTimestamp(2, Timestamp.valueOf(order.getOrderDate()));
            ps.setString(3, order.getStatus());
            ps.setBigDecimal(4, order.getTotalAmount());
            ps.setString(5, order.getShippingAddress());
            return ps;
        }, keyHolder);

        if (keyHolder.getKey() != null) {
            order.setOrderId(keyHolder.getKey().intValue());
            return order;
        }
        return null;
    }

    public Optional<Orders> findOrderById(int orderId) {
        String sql = "SELECT o.order_id, o.user_id, o.order_date, o.status, o.total_amount, o.shipping_address, "
                + "u.username, u.fullName, u.email "
                + "FROM Orders o JOIN Users u ON o.user_id = u.user_id WHERE o.order_id = ?";
        List<Orders> orders = jdbcTemplate.query(sql, orderWithUserRowMapper, orderId);
        return orders.isEmpty() ? Optional.empty() : Optional.of(orders.get(0));
    }

    public List<Orders> findOrdersByUserId(int userId) {
        String sql = "SELECT o.order_id, o.user_id, o.order_date, o.status, o.total_amount, o.shipping_address, "
                + "u.username, u.fullName, u.email "
                + "FROM Orders o JOIN Users u ON o.user_id = u.user_id WHERE o.user_id = ? ORDER BY o.order_date DESC";
        return jdbcTemplate.query(sql, orderWithUserRowMapper, userId);
    }

    public List<Orders> findAllOrders() {
        String sql = "SELECT o.order_id, o.user_id, o.order_date, o.status, o.total_amount, o.shipping_address, "
                + "u.username, u.fullName, u.email "
                + "FROM Orders o JOIN Users u ON o.user_id = u.user_id ORDER BY o.order_date DESC";
        return jdbcTemplate.query(sql, orderWithUserRowMapper);
    }

    @Transactional
    public boolean updateOrderStatus(int orderId, String status) {
        String sqlUpdateOrder = "UPDATE Orders SET status = ? WHERE order_id = ?";
        int rows = jdbcTemplate.update(sqlUpdateOrder, status, orderId);
        
        if (rows == 0) {
            return false;
        }

        if ("canceled".equals(status.toLowerCase()) || ("pending".equals(status.toLowerCase()) && !isOrderAlreadyProcessed(orderId))) {
            String sqlGetOrderDetails = "SELECT product_id, quantity FROM Order_Detail WHERE order_id = ?";
            List<OrderDetail> orderDetails = jdbcTemplate.query(sqlGetOrderDetails, (rs, rowNum) -> {
                OrderDetail detail = new OrderDetail();
                Product p = new Product();
                p.setProductId(rs.getInt("product_id"));
                detail.setProduct(p);
                detail.setQuantity(rs.getInt("quantity"));
                return detail;
            }, orderId);

            if (!orderDetails.isEmpty()) {
                String sqlUpdateStock = "UPDATE Product SET stock_quantity = stock_quantity + ? WHERE product_id = ?";
                List<Object[]> batchParams = new ArrayList<>();
                for (OrderDetail detail : orderDetails) {
                    batchParams.add(new Object[]{detail.getQuantity(), detail.getProduct().getProductId()});
                }
                jdbcTemplate.batchUpdate(sqlUpdateStock, batchParams);
            }
        }
        return true;
    }

    public boolean deleteOrder(int orderId) {
        String sql = "DELETE FROM Orders WHERE order_id = ?";
        return jdbcTemplate.update(sql, orderId) > 0;
    }

    public boolean addOrderDetail(OrderDetail orderDetail) {
        String sql = "INSERT INTO Order_Detail (order_id, product_id, quantity, unit_price) VALUES (?, ?, ?, ?)";
        return jdbcTemplate.update(sql, 
                orderDetail.getOrder().getOrderId(),
                orderDetail.getProduct().getProductId(),
                orderDetail.getQuantity(),
                orderDetail.getUnitPrice()
        ) > 0;
    }

    public List<OrderDetail> getOrderDetailsByOrderId(int orderId) {
        String sql = "SELECT od.order_detail_id, od.order_id, od.product_id, od.quantity, od.unit_price, "
                + "p.name, p.price, p.image_url "
                + "FROM Order_Detail od JOIN Product p ON od.product_id = p.product_id WHERE od.order_id = ?";
        return jdbcTemplate.query(sql, (rs, rowNum) -> {
            Product product = new Product();
            product.setProductId(rs.getInt("product_id"));
            product.setName(rs.getString("name"));
            product.setPrice(rs.getBigDecimal("price"));
            product.setImageUrl(rs.getString("image_url"));

            Orders order = new Orders(orderId);

            return new OrderDetail(
                    rs.getInt("order_detail_id"),
                    order,
                    product,
                    rs.getInt("quantity"),
                    rs.getBigDecimal("unit_price")
            );
        }, orderId);
    }

    public boolean updateOrderDetail(OrderDetail orderDetail) {
        String sql = "UPDATE Order_Detail SET quantity = ?, unit_price = ? WHERE order_detail_id = ?";
        return jdbcTemplate.update(sql, 
                orderDetail.getQuantity(),
                orderDetail.getUnitPrice(),
                orderDetail.getOrderDetailId()
        ) > 0;
    }

    public boolean deleteOrderDetail(int orderDetailId) {
        String sql = "DELETE FROM Order_Detail WHERE order_detail_id = ?";
        return jdbcTemplate.update(sql, orderDetailId) > 0;
    }

    public boolean updateOrderHistory(Orders orders, String status) {
        String sql = "UPDATE Orders SET status = ? WHERE order_id = ?";
        return jdbcTemplate.update(sql, status, orders.getOrderId()) > 0;
    }

    public List<Orders> findOrdersByStatus(String status) {
        String sql = "SELECT o.order_id, o.user_id, o.order_date, o.status, o.total_amount, o.shipping_address, "
                + "u.username, u.fullName, u.email "
                + "FROM Orders o JOIN Users u ON o.user_id = u.user_id WHERE o.status = ? ORDER BY o.order_date DESC";
        return jdbcTemplate.query(sql, orderWithUserRowMapper, status);
    }

    public boolean updateOrderTotalAmount(int orderId, BigDecimal discountedTotal) {
        String sql = "UPDATE Orders SET total_amount = ? WHERE order_id = ?";
        return jdbcTemplate.update(sql, discountedTotal, orderId) > 0;
    }

    public BigDecimal calculateDiscountedTotal(BigDecimal originalAmount, int membershipLevelId, String couponCode) {
        BigDecimal finalAmount = originalAmount;

        if (membershipLevelId > 0 && membershipLevelId <= 4) {
            BigDecimal discountPercent = BigDecimal.ZERO;
            switch (membershipLevelId) {
                case 1: discountPercent = new BigDecimal("3"); break;
                case 2: discountPercent = new BigDecimal("5"); break;
                case 3: discountPercent = new BigDecimal("7"); break;
                case 4: discountPercent = new BigDecimal("10"); break;
            }

            if (discountPercent.compareTo(BigDecimal.ZERO) > 0) {
                BigDecimal discountFactor = discountPercent.divide(new BigDecimal("100"), 4, RoundingMode.HALF_UP);
                BigDecimal membershipDiscount = originalAmount.multiply(discountFactor).setScale(0, RoundingMode.HALF_UP);
                finalAmount = finalAmount.subtract(membershipDiscount);
            }
        }

        if (couponCode != null && !couponCode.trim().isEmpty() && couponRepository != null) {
            try {
                Optional<Coupon> couponOpt = couponRepository.findCouponByCode(couponCode);
                if (couponOpt.isPresent()) {
                    Coupon coupon = couponOpt.get();
                    if (coupon.isActive() && coupon.isValid()) {
                        BigDecimal couponDiscountPercent = coupon.getDiscountPercent();
                        BigDecimal discountFactor = couponDiscountPercent.divide(new BigDecimal("100"), 4, RoundingMode.HALF_UP);
                        BigDecimal couponDiscount = originalAmount.multiply(discountFactor).setScale(0, RoundingMode.HALF_UP);
                        finalAmount = finalAmount.subtract(couponDiscount);
                    }
                }
            } catch (Exception e) {
                LOGGER.warning("Error applying coupon discount: " + e.getMessage());
            }
        }

        if (finalAmount.compareTo(BigDecimal.ZERO) < 0) {
            finalAmount = BigDecimal.ZERO;
        }

        return finalAmount;
    }

    public boolean isOrderAlreadyProcessed(int orderId) {
        String sql = "SELECT COUNT(*) FROM Order_Detail od JOIN Orders o ON od.order_id = o.order_id WHERE o.order_id = ? AND o.status NOT IN ('Pending', 'Canceled')";
        Integer count = jdbcTemplate.queryForObject(sql, Integer.class, orderId);
        return count != null && count > 0;
    }
}
