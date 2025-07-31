package com.tourismapp.dao.order;

import com.tourismapp.model.Orders;
import com.tourismapp.model.OrderDetail;
import com.tourismapp.model.OrderStat;
import java.util.List;
import java.util.Optional;

/**
 * Order DAO Interface
 * @author Admin
 */
public interface IOrderDAO {
    
    // NAM
    List<OrderStat> getOrderStatsByMonth();
    List<Orders> getAllOrders();
    List<OrderStat> getOrderStatsByStatus();
    List<OrderStat> getOrderStatsByProduct();
    List<OrderStat> getRevenueStatsByMonth();
    
    
    
    // HIEU
    /**
     * Create a new order
     * @param order Order object
     * @return Created order with generated ID
     */
    Orders createOrder(Orders order);
    
    /**
     * Find order by ID
     * @param orderId Order ID
     * @return Optional of Orders
     */
    Optional<Orders> findOrderById(int orderId);
    
    /**
     * Find orders by user ID
     * @param userId User ID
     * @return List of orders
     */
    List<Orders> findOrdersByUserId(int userId);
    
    /**
     * Find all orders
     * @return List of all orders
     */
    List<Orders> findAllOrders();
    
    /**
     * Update order status
     * @param orderId Order ID
     * @param status New status
     * @return true if successful
     */
    boolean updateOrderStatus(int orderId, String status);
    
    /**
     * Delete order
     * @param orderId Order ID
     * @return true if successful
     */
    boolean deleteOrder(int orderId);
    
    /**
     * Add order detail
     * @param orderDetail Order detail object
     * @return true if successful
     */
    boolean addOrderDetail(OrderDetail orderDetail);
    
    /**
     * Get order details by order ID
     * @param orderId Order ID
     * @return List of order details
     */
    List<OrderDetail> getOrderDetailsByOrderId(int orderId);
    
    /**
     * Update order detail
     * @param orderDetail Order detail object
     * @return true if successful
     */
    boolean updateOrderDetail(OrderDetail orderDetail);
    
    /**
     * Delete order detail
     * @param orderDetailId Order detail ID
     * @return true if successful
     */
    boolean deleteOrderDetail(int orderDetailId);
    boolean updateOrderHistory(Orders orders,String status);
    List<Orders> findOrdersByStatus(String status);
    
    /**
     * Update order total amount after applying discounts
     * @param orderId Order ID
     * @param discountedTotal New total amount after discount
     * @return true if successful
     */
    boolean updateOrderTotalAmount(int orderId, java.math.BigDecimal discountedTotal);
    
    /**
     * Calculate discounted total amount based on membership level and coupon
     * @param originalAmount Original order amount
     * @param membershipLevelId User's membership level ID
     * @param couponCode Applied coupon code (can be null)
     * @return Discounted total amount
     */
    java.math.BigDecimal calculateDiscountedTotal(java.math.BigDecimal originalAmount, int membershipLevelId, String couponCode);
    java.math.BigDecimal calculateTotalRevenue();
    boolean isOrderAlreadyProcessed(int orderId);
}
