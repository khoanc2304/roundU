package com.tourismapp.controller.cartController;

import com.tourismapp.config.ProjectPaths;
import com.tourismapp.controller.mainController.MainControllerServlet;
import com.tourismapp.model.Cart;
import com.tourismapp.model.CartItem;
import com.tourismapp.model.Product;
import com.tourismapp.model.Users;
import com.tourismapp.service.user.IUserService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import com.tourismapp.service.product.IProductService;
import com.tourismapp.service.cart.ICartService;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Optional;

@Controller
public class CartController {

    @Autowired
    private ICartService cartService;

    @Autowired
    private IProductService productService;
    @Autowired
    private IUserService userService;

    @RequestMapping(value = MainControllerServlet.CARTPAGE_SERVLET, method = {RequestMethod.GET, RequestMethod.POST})
    public String showCartPage(HttpServletRequest request, HttpSession session) {
        Cart cart = getOrCreateCart(session);

        Users user = (Users) session.getAttribute("user");
        if (user != null) {
            Users updatedUser = userService.getUserById(user.getUserId());
            if (updatedUser != null) {
                session.setAttribute("user", updatedUser);
            }
        }

        request.setAttribute("cart", cart);
        return ProjectPaths.JSP_CARTPAGE_PATH;
    }

    @PostMapping("/cart/{action}")
    @ResponseBody
    public void handleCartPostAction(@PathVariable("action") String action, HttpServletRequest request, HttpServletResponse response, HttpSession session) throws IOException {
        Cart cart = getOrCreateCart(session);
        
        // We set content type unless it redirects
        if (!"add".equals(action) || request.getHeader("X-Requested-With") != null) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
        }
        
        switch (action) {
            case "add":
                addToCart(request, response, cart);
                break;
            case "update":
                updateCart(request, response, cart);
                break;
            case "remove":
                removeFromCart(request, response, cart);
                break;
            case "clear":
                clearCart(request, response, cart);
                break;
            default:
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
        }

        session.setAttribute("cart", cart);
        Users user = (Users) session.getAttribute("user");
        if (user != null) {
            cartService.saveUserCart(user.getUserId(), cart);
        }
    }

    @GetMapping("/cart/{action}")
    @ResponseBody
    public void handleCartGetAction(@PathVariable("action") String action, HttpSession session, HttpServletResponse response) throws IOException {
        Cart cart = getOrCreateCart(session);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        if ("count".equals(action)) {
            out.print("{\"count\":" + cart.getTotalItems() + ",\"total\":\"" + cart.getTotalAmount() + "\"}");
        } else if ("preview".equals(action)) {
            StringBuilder json = new StringBuilder();
            json.append("{\"totalItems\":").append(cart.getTotalItems());
            json.append(",\"total\":\"").append(cart.getTotalAmount()).append("\"");
            json.append(",\"items\":[");

            boolean first = true;
            for (CartItem item : new ArrayList<>(cart.getItems())) {
                if (!first) json.append(",");

                Product product = item.getProduct();
                json.append("{")
                        .append("\"quantity\":").append(item.getQuantity()).append(",")
                        .append("\"product\":{")
                        .append("\"productId\":").append(product.getProductId()).append(",")
                        .append("\"name\":\"").append(escapeJson(product.getName())).append("\",")
                        .append("\"price\":").append(product.getPrice()).append(",")
                        .append("\"imageUrl\":\"").append(escapeJson(product.getImageUrl())).append("\"")
                        .append("}")
                        .append("}");

                first = false;
            }

            json.append("]}");
            out.print(json.toString());
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
        }
        out.flush();
    }

    private void addToCart(HttpServletRequest request, HttpServletResponse response, Cart cart) throws IOException {
        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            Optional<Product> productOpt = productService.findProductById(productId);
            if (productOpt.isPresent()) {
                Product product = productOpt.get();
                CartItem existingItem = cart.getItem(productId);
                int currentQuantity = (existingItem != null) ? existingItem.getQuantity() : 0;
                int newTotalQuantity = currentQuantity + quantity;

                if (newTotalQuantity <= product.getStockQuantity()) {
                    cart.addItemWithIncrease(product, quantity);
                    String requestedWith = request.getHeader("X-Requested-With");
                    if (requestedWith == null) {
                        response.sendRedirect(request.getContextPath() + "/main?action=cartPage");
                        return;
                    }
                    PrintWriter out = response.getWriter();
                    if (existingItem != null) {
                        int newQuantity = cart.getItem(productId).getQuantity();
                        out.print("{\"success\":true,\"message\":\"Đã tăng số lượng sản phẩm lên " + newQuantity + "\",\"cartCount\":" + cart.getTotalItems() + ",\"alreadyExists\":true}");
                    } else {
                        out.print("{\"success\":true,\"message\":\"Đã thêm sản phẩm vào giỏ hàng\",\"cartCount\":" + cart.getTotalItems() + ",\"alreadyExists\":false}");
                    }
                    out.flush();
                } else {
                    PrintWriter out = response.getWriter();
                    out.print("{\"success\":false,\"message\":\"Số lượng vượt quá tồn kho! Chỉ có thể đặt " + product.getStockQuantity() + " sản phẩm.\",\"stock\":" + product.getStockQuantity() + "}");
                    out.flush();
                }
            } else {
                PrintWriter out = response.getWriter();
                out.print("{\"success\":false,\"message\":\"Sản phẩm không tồn tại!\",\"stock\":0}");
                out.flush();
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid parameters");
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Server error");
        }
    }

    private void updateCart(HttpServletRequest request, HttpServletResponse response, Cart cart) throws IOException {
        PrintWriter out = response.getWriter();
        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));

            Optional<Product> productOpt = productService.findProductById(productId);
            if (productOpt.isPresent()) {
                Product product = productOpt.get();
                if (quantity > product.getStockQuantity()) {
                    out.print("{\"success\":false,\"message\":\"Số lượng đặt vượt quá tồn kho! Chỉ có thể đặt " + product.getStockQuantity() + " sản phẩm.\"}");
                    out.flush();
                    return;
                }
            } else {
                out.print("{\"success\":false,\"message\":\"Sản phẩm không tồn tại!\"}");
                out.flush();
                return;
            }

            cart.updateItem(productId, quantity);
            out.print("{\"success\":true,\"cartCount\":" + cart.getTotalItems() + ",\"total\":\"" + cart.getTotalAmount() + "\"}");
            out.flush();
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid parameters");
        }
    }

    private void removeFromCart(HttpServletRequest request, HttpServletResponse response, Cart cart) throws IOException {
        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            cart.removeItem(productId);
            PrintWriter out = response.getWriter();
            out.print("{\"success\":true,\"cartCount\":" + cart.getTotalItems() + ",\"total\":\"" + cart.getTotalAmount() + "\"}");
            out.flush();
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid parameters");
        }
    }

    private void clearCart(HttpServletRequest request, HttpServletResponse response, Cart cart) throws IOException {
        cart.clear();
        PrintWriter out = response.getWriter();
        out.print("{\"success\":true,\"message\":\"Cart cleared\"}");
        out.flush();
    }

    private Cart getOrCreateCart(HttpSession session) {
        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null) {
            cart = new Cart();
            Users user = (Users) session.getAttribute("user");
            if (user != null) {
                Cart userCart = cartService.loadUserCart(user.getUserId());
                if (userCart != null && !userCart.isEmpty()) {
                    cart = userCart;
                }
            }
            session.setAttribute("cart", cart);
        }
        return cart;
    }

    private String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\").replace("\"", "\\\"")
                .replace("\n", "\\n").replace("\r", "\\r")
                .replace("\t", "\\t");
    }
}
