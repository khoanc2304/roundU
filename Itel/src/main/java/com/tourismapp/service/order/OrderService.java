package com.tourismapp.service.order;

import com.tourismapp.dao.order.IOrderDAO;
import com.tourismapp.dao.order.OrderDAO;
import com.tourismapp.model.Orders;
import com.tourismapp.model.OrderDetail;
import com.tourismapp.model.Cart;
import com.tourismapp.model.CartItem;
import com.tourismapp.service.product.ProductService;
import com.tourismapp.utils.ErrDialog;

import java.util.List;
import java.util.Optional;

/**
 * Order Service Implementation
 *
 * @author Admin
 */
public class OrderService implements IOrderService {

    private final IOrderDAO orderDAO = new OrderDAO();
    private final ProductService productService = new ProductService();

    @Override
    public Orders createOrder(Orders order, Cart cart, String orderNotes) {
        try {
            System.out.println("OrderService.createOrder called");
            System.out.println("Order user ID: " + (order.getUser() != null ? order.getUser().getUserId() : "null"));
            System.out.println("Cart items: " + (cart != null ? cart.getItems().size() : "null"));

            // Validate input
            if (order == null || cart == null || cart.isEmpty()) {
                System.out.println("Validation failed - order or cart is null/empty");
                return null;
            }

            // Create order in database
            Orders createdOrder = orderDAO.createOrder(order);
            System.out.println("OrderDAO.createOrder result: " + (createdOrder != null ? "Success, ID: " + createdOrder.getOrderId() : "Failed"));

            if (createdOrder != null) {
                // Create order details for each cart item
                boolean allDetailsCreated = true;

                for (CartItem cartItem : cart.getItems()) {
                    OrderDetail orderDetail = new OrderDetail(
                            createdOrder,
                            cartItem.getProduct(),
                            cartItem.getQuantity(),
                            cartItem.getProduct().getPrice()
                    );

                    boolean detailCreated = orderDAO.addOrderDetail(orderDetail);
                    if (!detailCreated) {
                        allDetailsCreated = false;
                        ErrDialog.showError("Failed to create order detail for product: " + cartItem.getProduct().getName());
                    }

                    // Update product stock
                    try {
                        productService.updateProductStock(
                                cartItem.getProduct().getProductId(),
                                cartItem.getProduct().getStockQuantity() - cartItem.getQuantity()
                        );
                    } catch (Exception e) {
                        ErrDialog.showError("Failed to update stock for product: " + cartItem.getProduct().getName());
                    }
                }

                if (allDetailsCreated) {
                    return createdOrder;
                } else {
                    // If some order details failed, consider rolling back
                    ErrDialog.showError("Some order details failed to create, but order was created successfully");
                    return createdOrder;
                }
            }

            return null;
        } catch (Exception e) {
            ErrDialog.showError("Error in OrderService.createOrder: " + e.getMessage());
            return null;
        }
    }

    @Override
    public Optional<Orders> findOrderById(int orderId) {
        try {
            return orderDAO.findOrderById(orderId);
        } catch (Exception e) {
            ErrDialog.showError("Error in OrderService.findOrderById: " + e.getMessage());
            return Optional.empty();
        }
    }

    @Override
    public List<Orders> findOrdersByUserId(int userId) {
        try {
            List<Orders> orders = orderDAO.findOrdersByUserId(userId);
            for (Orders order : orders) {
                order.setOrderDetails(orderDAO.getOrderDetailsByOrderId(order.getOrderId()));
            }
            return orders;
        } catch (Exception e) {
            ErrDialog.showError("Error in OrderService.findOrdersByUserId: " + e.getMessage());
            return List.of();
        }
    }

    @Override
    public List<Orders> getOrdersByUserId(int userId) {
        try {
            System.out.println("OrderService.getOrdersByUserId called for userId: " + userId);
            List<Orders> orders = orderDAO.findOrdersByUserId(userId);
            System.out.println("OrderDAO returned " + orders.size() + " orders");

            // Load order details for each order
            for (Orders order : orders) {
                System.out.println("Loading details for order: " + order.getOrderId());
                List<OrderDetail> orderDetails = orderDAO.getOrderDetailsByOrderId(order.getOrderId());
                System.out.println("Found " + orderDetails.size() + " order details");
                order.setOrderDetails(orderDetails);
            }

            System.out.println("Returning " + orders.size() + " orders with details");
            return orders;
        } catch (Exception e) {
            System.err.println("Error in OrderService.getOrdersByUserId: " + e.getMessage());
            e.printStackTrace();
            ErrDialog.showError("Error in OrderService.getOrdersByUserId: " + e.getMessage());
            return List.of();
        }
    }

    @Override
    public List<Orders> findAllOrders() {
        try {
            List<Orders> orders = orderDAO.findAllOrders();
            for (Orders order : orders) {
                order.setOrderDetails(orderDAO.getOrderDetailsByOrderId(order.getOrderId()));
            }
            return orders;
        } catch (Exception e) {
            ErrDialog.showError("Error in OrderService.findAllOrders: " + e.getMessage());
            return List.of();
        }
    }

    @Override
    public boolean updateOrderStatus(int orderId, String status) {
        try {
//            ErrDialog.showError("OrderService.updateOrderStatus called for orderId: " + orderId + ", status: " + status);
            // Get order details to restore stock if canceled
            if ("Canceled".equalsIgnoreCase(status)) {
                List<OrderDetail> orderDetails = orderDAO.getOrderDetailsByOrderId(orderId);
                if (orderDetails != null && !orderDetails.isEmpty()) {
                    for (OrderDetail detail : orderDetails) {
                        try {
                            // Lấy stock hiện tại từ cơ sở dữ liệu để đảm bảo chính xác
                            int currentStock = productService.getProductById(detail.getProduct().getProductId()).getStockQuantity();
//                            productService.updateProductStock(
//                                    detail.getProduct().getProductId(),
//                                    currentStock + detail.getQuantity()
//                            );
//                            ErrDialog.showError("Restored stock for productId: " + detail.getProduct().getProductId() + ", quantity: " + detail.getQuantity());
                        } catch (Exception e) {
                            ErrDialog.showError("Failed to restore stock for product: " + detail.getProduct().getName());
                            ErrDialog.showError("Stock restoration failed: " + e.getMessage());
                        }
                    }
                }
            }

            // Update order status
            boolean updated = orderDAO.updateOrderStatus(orderId, status);
            if (updated) {
                System.out.println("Successfully updated orderId: " + orderId + " to status: " + status);
//                ErrDialog.showError("Successfully updated orderId: " + orderId + " to status: " + status);
            } else {
                ErrDialog.showError("Failed to update orderId: " + orderId + " to status: " + status);
            }
            return updated;
        } catch (Exception e) {
            ErrDialog.showError("Error in OrderService.updateOrderStatus: " + e.getMessage());
            ErrDialog.showError("Exception in updateOrderStatus: " + e.getMessage());
            return false;
        }
    }

    @Override
    public boolean cancelOrder(int orderId) {
        try {
//            ErrDialog.showError("OrderService.cancelOrder called for orderId: " + orderId);
            return updateOrderStatus(orderId, "canceled"); // Sử dụng updateOrderStatus để tái sử dụng logic
        } catch (Exception e) {
            ErrDialog.showError("Error in OrderService.cancelOrder: " + e.getMessage());
            return false;
        }
    }

    @Override
    public List<OrderDetail> getOrderDetailsByOrderId(int orderId) {
        try {
            return orderDAO.getOrderDetailsByOrderId(orderId);
        } catch (Exception e) {
            ErrDialog.showError("Error in OrderService.getOrderDetailsByOrderId: " + e.getMessage());
            return List.of();
        }
    }

    @Override
    public Optional<Orders> getOrderWithDetails(int orderId) {
        try {
            Optional<Orders> orderOpt = orderDAO.findOrderById(orderId);

            if (orderOpt.isPresent()) {
                Orders order = orderOpt.get();
                List<OrderDetail> orderDetails = orderDAO.getOrderDetailsByOrderId(orderId);
                // Note: You might want to add a field to Orders model to store order details
                // For now, we'll just return the order
                return Optional.of(order);
            }

            return Optional.empty();
        } catch (Exception e) {
            ErrDialog.showError("Error in OrderService.getOrderWithDetails: " + e.getMessage());
            return Optional.empty();
        }
    }

    @Override
    public boolean completeOrder(int orderId) {
        try {
            return orderDAO.updateOrderStatus(orderId, "completed");
        } catch (Exception e) {
            ErrDialog.showError("Error in OrderService.completeOrder: " + e.getMessage());
            return false;
        }
    }

    @Override
    public boolean shipOrder(int orderId) {
        try {
            return orderDAO.updateOrderStatus(orderId, "shipped");
        } catch (Exception e) {
            ErrDialog.showError("Error in OrderService.shipOrder: " + e.getMessage());
            return false;
        }
    }
    public List<Orders> findOrdersByStatus(String status) {
        return orderDAO.findOrdersByStatus(status);
    }
    
    /**
     * Calculate discounted total amount for an order
     * @param originalAmount Original order amount
     * @param membershipLevelId User's membership level ID
     * @param couponCode Applied coupon code (can be null)
     * @return Discounted total amount
     */
    public java.math.BigDecimal calculateDiscountedTotal(java.math.BigDecimal originalAmount, int membershipLevelId, String couponCode) {
        return orderDAO.calculateDiscountedTotal(originalAmount, membershipLevelId, couponCode);
    }
    
    /**
     * Update order total amount after applying discounts
     * @param orderId Order ID
     * @param discountedTotal New total amount after discount
     * @return true if successful
     */
    public boolean updateOrderTotalAmount(int orderId, java.math.BigDecimal discountedTotal) {
        return orderDAO.updateOrderTotalAmount(orderId, discountedTotal);
    }
}
