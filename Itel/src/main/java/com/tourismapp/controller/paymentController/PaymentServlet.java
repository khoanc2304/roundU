package com.tourismapp.controller.paymentController;

import com.tourismapp.common.PaymentMethod;
import static com.tourismapp.common.PaymentMethod.BANKING;
import static com.tourismapp.common.PaymentMethod.CASH;
import static com.tourismapp.common.PaymentMethod.CASH_ON_DELIVERY;
import com.tourismapp.common.Status;
import com.tourismapp.model.*;
import com.tourismapp.service.cart.CartService;
import com.tourismapp.service.order.OrderService;
import com.tourismapp.service.product.ProductService;
import com.tourismapp.utils.ErrDialog;
//import com.tourismapp.utils.MailUtil;
//import jakarta.mail.MessagingException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.Random;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Payment Servlet handles payment processing
 * @author Admin
 */
@WebServlet(name = "PaymentServlet", urlPatterns = {"/payment"})
public class PaymentServlet extends HttpServlet {

    private final OrderService orderService = new OrderService();
    private final CartService cartService = new CartService();
    private final ProductService productService = new ProductService();
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("loggedUser");
        Cart cart = (Cart) session.getAttribute("cart");
        
        // Validate user and cart
        if (user == null) {
            response.sendRedirect("/Itel/main?action=loginPage");
            return;
        }
        
        if (cart == null || cart.isEmpty()) {
            response.sendRedirect("/Itel/main?action=cartPage");
            return;
        }
        
        try {
            // Get form data
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String city = request.getParameter("city");
            String district = request.getParameter("district");
            String paymentMethodStr = request.getParameter("paymentMethod");
            String orderNotes = request.getParameter("orderNotes");
            String checkoutType = request.getParameter("checkoutType"); // "all" or "selected"
            
            System.out.println("Payment processing - checkoutType: " + checkoutType);
            
            // Validate required fields
            if (firstName == null || lastName == null || email == null || 
                phone == null || address == null || city == null || 
                district == null || paymentMethodStr == null) {
                
                request.setAttribute("error", "Please fill in all required fields");
                request.getRequestDispatcher("/WEB-INF/view/pages/checkoutPage/checkoutPage.jsp")
                        .forward(request, response);
                return;
            }
            
            // Build full shipping address
            String fullShippingAddress = address + ", " + district + ", " + city;
            
            // Parse payment method
            PaymentMethod paymentMethod;
            try {
                paymentMethod = PaymentMethod.valueOf(paymentMethodStr);
            } catch (IllegalArgumentException e) {
                paymentMethod = PaymentMethod.CASH_ON_DELIVERY;
            }
            
            // Validate stock availability before processing order
            for (CartItem item : cart.getItems()) {
                Product product = productService.findProductById(item.getProduct().getProductId())
                        .orElse(null);
                if (product == null || product.getStockQuantity() < item.getQuantity()) {
                    request.setAttribute("error", "Some items in your cart are no longer available or out of stock");
                    request.getRequestDispatcher("/WEB-INF/view/pages/checkoutPage/checkoutPage.jsp")
                            .forward(request, response);
                    return;
                }
            }
            
            // Create order
            Orders order = new Orders(
                user,
                LocalDateTime.now(),
                "pending",
                cart.getTotalAmount(),
                fullShippingAddress
            );
            
            System.out.println("Creating order for user: " + user.getUserId() + ", amount: " + cart.getTotalAmount());
            
            // Process fake payment
            PaymentResult paymentResult = processFakePayment(paymentMethod, cart.getTotalAmount());
            System.out.println("Payment result: " + paymentResult.isSuccess() + ", message: " + paymentResult.getMessage());
            
            if (paymentResult.isSuccess()) {
                // Create order in database
                Orders createdOrder = orderService.createOrder(order, cart, orderNotes);
                System.out.println("Order creation result: " + (createdOrder != null ? "Success, ID: " + createdOrder.getOrderId() : "Failed"));
                
                if (createdOrder != null) {
                    // Create payment record
                    Payment payment = new Payment(
                        createdOrder,
                        LocalDateTime.now(),
                        paymentMethod,
                        cart.getTotalAmount(),
                        Status.ACTIVE
                    );
                    
                    // Gửi email hướng dẫn chuyển khoản nếu chọn BANKING
//                    if (paymentMethod == PaymentMethod.BANKING) {
//                        String subject = "Hướng dẫn chuyển khoản đơn hàng #" + createdOrder.getOrderId();
//                        String content = "<h3>Cảm ơn bạn đã đặt hàng tại Itel Shop!</h3>"
//                            + "<p>Vui lòng chuyển khoản theo thông tin sau để hoàn tất đơn hàng:</p>"
//                            + "<b>Ngân hàng:</b> Vietcombank (VCB)<br>"
//                            + "<b>Số tài khoản:</b> 0123456789<br>"
//                            + "<b>Chủ tài khoản:</b> NGUYEN VAN A<br>"
//                            + "<b>Số tiền:</b> " + cart.getTotalAmount() + " VNĐ<br>"
//                            + "<b>Nội dung chuyển khoản:</b> DH" + createdOrder.getOrderId() + " hoặc số điện thoại của bạn<br>"
//                            + "<p><i>Vui lòng chuyển khoản đúng nội dung để được xác nhận đơn hàng nhanh nhất.</i></p>";
//                        try {
//                            MailUtil.sendMail(email, subject, content);
//                        } catch (MessagingException e) {
//                            System.err.println("Gửi email thất bại: " + e.getMessage());
//                        } catch (Exception ex) {
//                            Logger.getLogger(PaymentServlet.class.getName()).log(Level.SEVERE, null, ex);
//                        }
//                    }
                    
                    // Get original cart from session to modify
                    Cart originalCart = (Cart) session.getAttribute("cart");
                    
                    // Handle cart cleanup based on checkout type
                    if ("selected".equals(checkoutType)) {
                        // Only remove selected items from original cart
                        System.out.println("Removing selected items from original cart");
                        
                        // Get selected items from form
                        String[] productIds = new String[100];
                        int count = 0;
                        
                        for (int i = 0; i < 100; i++) {
                            String productId = request.getParameter("selectedItems[" + i + "].productId");
                            if (productId != null) {
                                productIds[count++] = productId;
                            }
                        }
                        
                        // Remove selected items from original cart
                        for (int i = 0; i < count; i++) {
                            try {
                                int productId = Integer.parseInt(productIds[i]);
                                originalCart.removeItem(productId);
                                System.out.println("Removed product ID " + productId + " from original cart");
                            } catch (NumberFormatException e) {
                                System.err.println("Invalid product ID: " + productIds[i]);
                            }
                        }
                        
                        // Update session with modified cart
                        session.setAttribute("cart", originalCart);
                        System.out.println("Original cart updated, remaining items: " + originalCart.getTotalItems());
                        
                    } else {
                        // Clear entire cart for "all" checkout
                        originalCart.clear();
                        session.setAttribute("cart", originalCart);
                        
                        // Clear user's persistent cart if logged in
                        cartService.clearUserCart(user.getUserId());
                        System.out.println("Entire cart cleared");
                    }
                    
                    // Set success attributes for thank you page
                    request.setAttribute("order", createdOrder);
                    request.setAttribute("payment", payment);
                    request.setAttribute("paymentResult", paymentResult);
                    if (paymentMethod == PaymentMethod.BANKING) {
                        request.getRequestDispatcher("/WEB-INF/view/pages/thankYouPage/waitingBankTransfer.jsp")
                            .forward(request, response);
                        return;
                    }
                    // Forward to success page
                    request.getRequestDispatcher("/WEB-INF/view/pages/thankYouPage/thankYou.jsp")
                        .forward(request, response);
                } else {
                    request.setAttribute("error", "Failed to create order. Please try again.");
                    request.getRequestDispatcher("/WEB-INF/view/pages/checkoutPage/checkoutPage.jsp")
                            .forward(request, response);
                }
            } else {
                request.setAttribute("error", "Payment failed: " + paymentResult.getMessage());
                request.getRequestDispatcher("/WEB-INF/view/pages/checkoutPage/checkoutPage.jsp")
                        .forward(request, response);
            }
            
        } catch (Exception e) {
            ErrDialog.showError("Payment processing error: " + e.getMessage());
            request.setAttribute("error", "An error occurred while processing your payment. Please try again.");
            request.getRequestDispatcher("/WEB-INF/view/pages/checkoutPage/checkoutPage.jsp")
                    .forward(request, response);
        }
    }
    
    /**
     * Process fake payment - simulates different payment methods
     */
    private PaymentResult processFakePayment(PaymentMethod paymentMethod, BigDecimal amount) {
        Random random = new Random();
        
        switch (paymentMethod) {
            case CASH_ON_DELIVERY:
                // COD always succeeds
                return new PaymentResult(true, "COD-" + System.currentTimeMillis(), 
                    "Order placed successfully. You will pay when receiving the product.");
                
            case BANKING:
                // Bank transfer - 95% success rate
                if (random.nextInt(100) < 95) {
                    return new PaymentResult(true, "BANK-" + System.currentTimeMillis(), 
                        "Bank transfer initiated successfully.");
                } else {
                    return new PaymentResult(false, null, "Bank transfer failed. Please try again.");
                }
                
            case CASH:
                // Credit card - 90% success rate (demo)
                if (random.nextInt(100) < 90) {
                    return new PaymentResult(true, "CARD-" + System.currentTimeMillis(), 
                        "Card payment processed successfully.");
                } else {
                    return new PaymentResult(false, null, "Card payment declined. Please check your card details.");
                }
                
            default:
                return new PaymentResult(false, null, "Invalid payment method.");
        }
    }
    
    /**
     * Helper class to represent payment result
     */
    public static class PaymentResult {
        private final boolean success;
        private final String transactionId;
        private final String message;
        
        public PaymentResult(boolean success, String transactionId, String message) {
            this.success = success;
            this.transactionId = transactionId;
            this.message = message;
        }
        
        public boolean isSuccess() {
            return success;
        }
        
        public String getTransactionId() {
            return transactionId;
        }
        
        public String getMessage() {
            return message;
        }
    }
}
