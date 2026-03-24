package com.tourismapp.controller.paymentController;

import com.tourismapp.common.PaymentMethod;
import com.tourismapp.common.Status;
import com.tourismapp.model.*;
import com.tourismapp.service.user.IUserService;
import com.tourismapp.utils.MailUtil;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.Random;

import org.springframework.beans.factory.annotation.Autowired;
import com.tourismapp.service.cart.ICartService;
import com.tourismapp.service.order.IOrderService;
import com.tourismapp.service.product.IProductService;

@Controller
@RequestMapping("/")
public class PaymentController {

    @Autowired
    private IOrderService orderService;

    @Autowired
    private ICartService cartService;

    @Autowired
    private IProductService productService;

    @Autowired
    private IUserService userService;

    private static final String ADMIN_EMAIL = "admin@gmail.com";

    @PostMapping("/payment")
    public String processPayment(@RequestParam(value = "checkoutType", required = false) String checkoutType,
            @RequestParam(value = "firstName", required = false) String firstName,
            @RequestParam(value = "lastName", required = false) String lastName,
            @RequestParam(value = "email", required = false) String email,
            @RequestParam(value = "phone", required = false) String phone,
            @RequestParam(value = "address", required = false) String address,
            @RequestParam(value = "city", required = false) String city,
            @RequestParam(value = "district", required = false) String district,
            @RequestParam(value = "paymentMethod", required = false) String paymentMethodStr,
            @RequestParam(value = "orderNotes", required = false) String orderNotes,
            HttpServletRequest request, HttpSession session) {

        Users user = (Users) session.getAttribute("loggedUser");
        if (user == null) {
            return "redirect:/main?action=loginPage";
        }

        Cart cart = "selected".equals(checkoutType) ? (Cart) session.getAttribute("selectedCart")
                : (Cart) session.getAttribute("cart");

        if (cart == null || cart.isEmpty()) {
            return "redirect:/main?action=cartPage";
        }

        try {
            if (firstName == null || lastName == null || email == null || phone == null || address == null ||
                    city == null || district == null || paymentMethodStr == null) {
                request.setAttribute("error", "Vui lòng nhập đầy đủ thông tin");
                return "/WEB-INF/view/pages/checkoutPage/checkoutPage.jsp";
            }

            String fullShippingAddress = address + ", " + district + ", " + city;
            PaymentMethod paymentMethod;
            try {
                paymentMethod = PaymentMethod.valueOf(paymentMethodStr);
            } catch (IllegalArgumentException e) {
                paymentMethod = PaymentMethod.CASH_ON_DELIVERY;
            }

            for (CartItem item : cart.getItems()) {
                Product product = productService.findProductById(item.getProduct().getProductId()).orElse(null);
                if (product == null || product.getStockQuantity() < item.getQuantity()) {
                    request.setAttribute("error", "Sản phẩm trong giỏ hàng không đủ số lượng tồn");
                    return "/WEB-INF/view/pages/checkoutPage/checkoutPage.jsp";
                }
            }

            BigDecimal originalAmount = cart.getTotalAmount();
            int membershipLevelId = user.getMembershipLevel() != null ? user.getMembershipLevel().getLevelId() : 5;
            BigDecimal finalAmount = orderService.calculateDiscountedTotal(originalAmount, membershipLevelId, null);

            Orders order = new Orders(user, LocalDateTime.now(), "pending", finalAmount, fullShippingAddress);
            PaymentResult paymentResult = processFakePayment(paymentMethod, finalAmount);

            if (paymentResult.isSuccess()) {
                Orders createdOrder = orderService.createOrder(order, cart, orderNotes);
                if (createdOrder != null) {
                    orderService.updateOrderTotalAmount(createdOrder.getOrderId(), finalAmount);
                    createdOrder.setTotalAmount(finalAmount);

                    Payment payment = new Payment(createdOrder, LocalDateTime.now(), paymentMethod, finalAmount,
                            Status.ACTIVE);

                    if (userService.checkAndUpgradeMembership(user.getUserId(), originalAmount)) {
                        Users updatedUser = userService.getUserById(user.getUserId());
                        if (updatedUser != null) {
                            session.setAttribute("user", updatedUser);
                            session.setAttribute("loggedUser", updatedUser);
                            request.setAttribute("membershipUpgraded", true);
                            request.setAttribute("upgradeMessage", "Chúc mừng! Bạn đã được nâng cấp lên thành viên "
                                    + updatedUser.getMembershipLevel().getValue());
                        }
                    }

                    if (paymentMethod == PaymentMethod.BANKING || paymentMethod == PaymentMethod.CASH_ON_DELIVERY) {
                        try {
                            String subject = "Hướng dẫn chuyển khoản đơn hàng #" + createdOrder.getOrderId();
                            String content = "<h3>Cảm ơn bạn đã đặt hàng tại Itel Shop!</h3><p>Vui lòng chuyển khoản...</p>";
                            MailUtil.sendMail(email, subject, content);
                        } catch (Exception ignored) {
                        }
                    }

                    Cart originalCart = (Cart) session.getAttribute("cart");
                    if ("selected".equals(checkoutType)) {
                        for (int i = 0; i < 100; i++) {
                            String productId = request.getParameter("selectedItems[" + i + "].productId");
                            if (productId != null)
                                originalCart.removeItem(Integer.parseInt(productId));
                        }
                        session.setAttribute("cart", originalCart);
                    } else {
                        originalCart.clear();
                        session.setAttribute("cart", originalCart);
                        cartService.clearUserCart(user.getUserId());
                    }

                    session.removeAttribute("selectedCart");
                    request.setAttribute("order", createdOrder);
                    request.setAttribute("payment", payment);
                    request.setAttribute("paymentResult", paymentResult);
                    request.setAttribute("originalAmount", originalAmount);
                    request.setAttribute("finalAmount", finalAmount);
                    request.setAttribute("discountAmount", originalAmount.subtract(finalAmount));

                    if (paymentMethod == PaymentMethod.BANKING) {
                        return "/WEB-INF/view/pages/thankYouPage/waitingBankTransfer.jsp";
                    }
                    return "/WEB-INF/view/pages/thankYouPage/thankYou.jsp";
                } else {
                    request.setAttribute("error", "Lỗi tạo đơn hàng. Vui lòng thử lại.");
                    return "/WEB-INF/view/pages/checkoutPage/checkoutPage.jsp";
                }
            } else {
                request.setAttribute("error", "Thanh toán lỗi: " + paymentResult.getMessage());
                return "/WEB-INF/view/pages/checkoutPage/checkoutPage.jsp";
            }

        } catch (Exception e) {
            request.setAttribute("error", "Lỗi xử lý thanh toán. Vui lòng thử lại.");
            return "/WEB-INF/view/pages/checkoutPage/checkoutPage.jsp";
        }
    }

    @PostMapping("/bankTransferNotify")
    public String notifyBankTransfer(@RequestParam("orderId") String orderId, HttpSession session) {
        try {
            String subject = "[Itel Shop] User đã chuyển khoản cho đơn hàng #" + orderId;
            String content = "Khách hàng vừa báo đã chuyển khoản... #" + orderId;
            MailUtil.sendMail(ADMIN_EMAIL, subject, content);
        } catch (Exception ignored) {
        }
        return "redirect:/main?action=orderHistory";
    }

    private PaymentResult processFakePayment(PaymentMethod paymentMethod, BigDecimal amount) {
        Random random = new Random();
        switch (paymentMethod) {
            case CASH_ON_DELIVERY:
                return new PaymentResult(true, "COD-" + System.currentTimeMillis(), "Thành công.");
            case BANKING:
                return random.nextInt(100) < 95
                        ? new PaymentResult(true, "BANK-" + System.currentTimeMillis(), "Thành công.")
                        : new PaymentResult(false, null, "Lỗi.");
            case CASH:
                return random.nextInt(100) < 90
                        ? new PaymentResult(true, "CARD-" + System.currentTimeMillis(), "Thành công.")
                        : new PaymentResult(false, null, "Lỗi.");
            default:
                return new PaymentResult(false, null, "Không hợp lệ.");
        }
    }

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
