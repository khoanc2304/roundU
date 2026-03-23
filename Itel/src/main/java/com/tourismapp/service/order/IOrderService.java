package com.tourismapp.service.order;

import com.tourismapp.model.Orders;
import com.tourismapp.model.OrderDetail;
import com.tourismapp.model.Cart;
import com.tourismapp.model.CartItem;
import java.util.List;
import java.util.Optional;

/**
 * Order Service Interface
 * @author Admin
 */
public interface IOrderService {
    
    /**
     * Create order from cart
     * @param order Order object
     * @param cart Cart object
     * @param orderNotes Order notes
     * @return Created order
     */
    Orders createOrder(Orders order, Cart cart, String orderNotes);
    
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
     * Get orders by user ID with details
     * @param userId User ID
     * @return List of orders with details
     */
    List<Orders> getOrdersByUserId(int userId);
    
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
     * Cancel order
     * @param orderId Order ID
     * @return true if successful
     */
    boolean cancelOrder(int orderId);
    
    /**
     * Get order details by order ID
     * @param orderId Order ID
     * @return List of order details
     */
    List<OrderDetail> getOrderDetailsByOrderId(int orderId);
    
    /**
     * Get order with details
     * @param orderId Order ID
     * @return Optional of Orders with details populated
     */
    Optional<Orders> getOrderWithDetails(int orderId);
    
    /**
     * Process order completion
     * @param orderId Order ID
     * @return true if successful
     */
    boolean completeOrder(int orderId);
    
    /**
     * Process order shipment
     * @param orderId Order ID
     * @return true if successful
     */
    boolean shipOrder(int orderId);

    /**
     * Find orders by status
     * @param status Order status
     * @return List of orders with the specified status
     */
    List<Orders> findOrdersByStatus(String status);
    
    /**
     * Calculate discounted total amount for an order
     * @param originalAmount Original order amount
     * @param membershipLevelId User's membership level ID
     * @param couponCode Applied coupon code (can be null)
     * @return Discounted total amount
     */
    java.math.BigDecimal calculateDiscountedTotal(java.math.BigDecimal originalAmount, int membershipLevelId, String couponCode);
    
    /**
     * Update order total amount after applying discounts
     * @param orderId Order ID
     * @param discountedTotal New total amount after discount
     * @return true if successful
     */
    boolean updateOrderTotalAmount(int orderId, java.math.BigDecimal discountedTotal);

}
