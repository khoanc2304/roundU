package com.tourismapp.controller.orderController;

import com.tourismapp.config.ProjectPaths;
import com.tourismapp.controller.mainController.MainControllerServlet;
import com.tourismapp.entity.Cart;
import com.tourismapp.entity.Orders;
import com.tourismapp.entity.Product;
import com.tourismapp.entity.Users;
import org.springframework.beans.factory.annotation.Autowired;
import com.tourismapp.service.order.IOrderService;
import com.tourismapp.service.product.IProductService;
import com.tourismapp.service.user.IUserService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Controller
public class OrderController {

    @Autowired
    private IUserService userService;

    @Autowired
    private IOrderService orderService;

    @Autowired
    private IProductService productService;

    // CHECKOUT PAGE GET
    @GetMapping(MainControllerServlet.CHECKOUTPAGE_SERVLET)
    public String showCheckoutPage(HttpServletRequest request, HttpSession session) {
        Users user = (Users) session.getAttribute("loggedUser");
        if (user == null) {
            return "redirect:" + ProjectPaths.HREF_TO_LOGINPAGE.substring(ProjectPaths.PREFIX_WEB_PATH.length());
        }

        Users updatedUser = userService.getUserById(user.getUserId());
        if (updatedUser != null) {
            session.setAttribute("loggedUser", updatedUser);
            user = updatedUser;
        }

        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null || cart.isEmpty()) {
            return "redirect:" + ProjectPaths.HREF_TO_CARTPAGE.substring(ProjectPaths.PREFIX_WEB_PATH.length());
        }

        try {
            Users fullUser = userService.getUserById(user.getUserId());
            request.setAttribute("user", fullUser != null ? fullUser : user);
        } catch (Exception e) {
            request.setAttribute("user", user);
        }

        request.setAttribute("cart", cart);
        request.setAttribute("checkoutType", "all");

        return ProjectPaths.JSP_CHECKOUTPAGE_PATH;
    }

    // CHECKOUT PAGE POST (Selected Items)
    @PostMapping(MainControllerServlet.CHECKOUTPAGE_SERVLET)
    public String handleCheckoutSelectedItems(HttpServletRequest request, HttpSession session) {
        Users user = (Users) session.getAttribute("loggedUser");
        if (user == null) {
            return "redirect:" + ProjectPaths.HREF_TO_LOGINPAGE.substring(ProjectPaths.PREFIX_WEB_PATH.length());
        }

        String[] productIds = request.getParameterValues("selectedItems[].productId");
        String[] quantities = request.getParameterValues("selectedItems[].quantity");

        if (productIds == null) {
            String[] altProductIds = new String[100];
            String[] altQuantities = new String[100];
            int count = 0;
            for (int i = 0; i < 100; i++) {
                String productId = request.getParameter("selectedItems[" + i + "].productId");
                String quantity = request.getParameter("selectedItems[" + i + "].quantity");
                if (productId != null && quantity != null) {
                    altProductIds[count] = productId;
                    altQuantities[count] = quantity;
                    count++;
                }
            }
            if (count > 0) {
                productIds = new String[count];
                quantities = new String[count];
                System.arraycopy(altProductIds, 0, productIds, 0, count);
                System.arraycopy(altQuantities, 0, quantities, 0, count);
            }
        }

        if (productIds == null || quantities == null || productIds.length == 0) {
            return "redirect:" + ProjectPaths.HREF_TO_CARTPAGE.substring(ProjectPaths.PREFIX_WEB_PATH.length());
        }

        Cart selectedCart = new Cart();
        for (int i = 0; i < productIds.length; i++) {
            try {
                int productId = Integer.parseInt(productIds[i]);
                int quantity = Integer.parseInt(quantities[i]);
                Optional<Product> productOpt = productService.findProductById(productId);
                if (productOpt.isPresent()) {
                    Product product = productOpt.get();
                    selectedCart.addItem(product, quantity);
                }
            } catch (NumberFormatException ignored) {
            }
        }

        if (selectedCart.isEmpty()) {
            return "redirect:" + ProjectPaths.HREF_TO_CARTPAGE.substring(ProjectPaths.PREFIX_WEB_PATH.length());
        }

        try {
            Users fullUser = userService.getUserById(user.getUserId());
            request.setAttribute("user", fullUser != null ? fullUser : user);
        } catch (Exception e) {
            request.setAttribute("user", user);
        }

        session.setAttribute("selectedCart", selectedCart);
        request.setAttribute("cart", selectedCart);
        request.setAttribute("checkoutType", "selected");
        request.setAttribute("selectedItemsCount", selectedCart.getTotalItems());

        return ProjectPaths.JSP_CHECKOUTPAGE_PATH;
    }

    // ORDER HISTORY
    @GetMapping(MainControllerServlet.ORDERHISTORY_SERVLET)
    public String showOrderHistory(
            @RequestParam(value = "status", required = false, defaultValue = "all") String status,
            HttpServletRequest request, HttpSession session) {
        Users user = (Users) session.getAttribute("loggedUser");
        if (user == null) {
            return "redirect:" + ProjectPaths.HREF_TO_LOGINPAGE.substring(ProjectPaths.PREFIX_WEB_PATH.length());
        }

        try {
            List<Orders> orders = orderService.getOrdersByUserId(user.getUserId());
            if (!"all".equalsIgnoreCase(status)) {
                orders = orders.stream()
                        .filter(o -> o.getStatus() != null && o.getStatus().equalsIgnoreCase(status))
                        .collect(Collectors.toList());
            }

            request.setAttribute("orders", orders);
            request.setAttribute("user", user);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi tải lịch sử đơn hàng: " + e.getMessage());
        }

        return ProjectPaths.JSP_ORDERHISTORY_PATH;
    }

    // SIMPLE ORDER HISTORY DEBUG
    @GetMapping("/simpleOrderHistory")
    @ResponseBody
    public void debugSimpleOrderHistory(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        try {
            out.println("<!DOCTYPE html><html><head><title>Simple Order History Test</title></head><body>");
            out.println("<h2>Simple Order History Debug</h2>");

            HttpSession session = request.getSession();
            Users user = (Users) session.getAttribute("loggedUser");

            out.println("<p><strong>User from session:</strong> "
                    + (user != null ? user.getFullName() + " (ID: " + user.getUserId() + ")" : "NULL") + "</p>");

            if (user == null) {
                out.println("<p style='color:red'>No user in session!</p>");
                out.println("<a href='" + ProjectPaths.PREFIX_WEB_PATH + "/main?action=loginPage'>Login</a>");
            } else {
                out.println("<p>Calling OrderService...</p>");
                List<Orders> orders = orderService.getOrdersByUserId(user.getUserId());
                out.println("<p><strong>Orders found:</strong> " + (orders != null ? orders.size() : "NULL") + "</p>");

                if (orders != null && !orders.isEmpty()) {
                    out.println(
                            "<table border='1'><tr><th>Order ID</th><th>Status</th><th>Amount</th><th>Date</th><th>Details</th></tr>");
                    for (Orders order : orders) {
                        out.println("<tr>");
                        out.println("<td>" + order.getOrderId() + "</td>");
                        out.println("<td>" + order.getStatus() + "</td>");
                        out.println("<td>" + order.getTotalAmount() + "</td>");
                        out.println("<td>" + order.getOrderDate() + "</td>");
                        out.println("<td>" + (order.getOrderDetails() != null ? order.getOrderDetails().size() : "NULL")
                                + "</td>");
                        out.println("</tr>");
                    }
                    out.println("</table>");
                } else {
                    out.println("<p style='color:orange'>No orders found for user " + user.getUserId() + "</p>");
                }
            }
            out.println("<hr><a href='" + ProjectPaths.PREFIX_WEB_PATH
                    + "/main?action=orderHistory'>Try Original OrderHistory</a><br><a href='"
                    + ProjectPaths.PREFIX_WEB_PATH + "/orderHistory'>Try Direct OrderHistory</a><br><a href='"
                    + ProjectPaths.PREFIX_WEB_PATH + "/main?action=homePage'>Home</a></body></html>");
        } catch (Exception e) {
            out.println("<p style='color:red'>ERROR: " + e.getMessage() + "</p>");
            e.printStackTrace(out);
        } finally {
            out.close();
        }
    }
}
