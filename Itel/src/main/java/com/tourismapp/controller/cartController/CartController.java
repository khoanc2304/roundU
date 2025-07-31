package com.tourismapp.controller.cartController;

import com.tourismapp.model.Cart;
import com.tourismapp.model.CartItem;
import com.tourismapp.model.Product;
import com.tourismapp.model.Users;
import com.tourismapp.service.cart.CartService;
import com.tourismapp.service.product.ProductService;
import com.tourismapp.utils.ErrDialog;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Optional;

/**
 * Cart Controller handles cart operations
 * @author Admin
 */
@WebServlet(name = "CartController", urlPatterns = {"/cart/*"})
public class CartController extends HttpServlet {
    
    private final ProductService productService = new ProductService();
    private final CartService cartService = new CartService();
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = getActionFromPath(request.getPathInfo());
        HttpSession session = request.getSession();
        Cart cart = getOrCreateCart(session);
        
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
        
        // Save cart back to session
        session.setAttribute("cart", cart);
        
        // Also save to database if user is logged in
        Users user = (Users) session.getAttribute("user");
        if (user != null) {
            cartService.saveUserCart(user.getUserId(), cart);
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = getActionFromPath(request.getPathInfo());
        HttpSession session = request.getSession();
        Cart cart = getOrCreateCart(session);
        
        if ("count".equals(action)) {
            // Return cart item count for AJAX
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            out.print("{\"count\":" + cart.getTotalItems() + ",\"total\":\"" + cart.getTotalAmount() + "\"}");
            out.flush();
        } else if ("preview".equals(action)) {
            // Return cart preview data for dropdown
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            PrintWriter out = response.getWriter();
            
            StringBuilder json = new StringBuilder();
            json.append("{\"totalItems\":").append(cart.getTotalItems());
            json.append(",\"total\":\"").append(cart.getTotalAmount()).append("\"");
            json.append(",\"items\":[");
            
            boolean first = true;
            // Get latest items (reverse order to show newest first)
            java.util.List<CartItem> itemsList = new java.util.ArrayList<>(cart.getItems());
            
            for (CartItem item : itemsList) {
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
            out.flush();
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
        }
    }
    
    private void addToCart(HttpServletRequest request, HttpServletResponse response, Cart cart)
        throws IOException, ServletException {
    try {
        int productId = Integer.parseInt(request.getParameter("productId"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        // Get product from database
        Optional<Product> productOpt = productService.findProductById(productId);
        if (productOpt.isPresent()) {
            Product product = productOpt.get();
            // Lấy số lượng hiện tại trong giỏ (nếu có)
            CartItem existingItem = cart.getItem(productId);
            int currentQuantity = (existingItem != null) ? existingItem.getQuantity() : 0;
            int newTotalQuantity = currentQuantity + quantity;

            // Kiểm tra stock availability với tổng số lượng mới
            if (newTotalQuantity <= product.getStockQuantity()) {
                // Use addItemWithIncrease to add or increase quantity
                cart.addItemWithIncrease(product, quantity);
                // Nếu là request từ form (không phải AJAX), redirect sang giỏ hàng
                String requestedWith = request.getHeader("X-Requested-With");
                if (requestedWith == null) {
                    response.sendRedirect(request.getContextPath() + "/main?action=cartPage");
                    return;
                }
                // Nếu là AJAX thì trả về JSON
                response.setContentType("application/json");
                PrintWriter out = response.getWriter();
                if (existingItem != null) {
                    int newQuantity = cart.getItem(productId).getQuantity();
                    out.print("{\"success\":true,\"message\":\"Đã tăng số lượng sản phẩm lên " + newQuantity + "\",\"cartCount\":" + cart.getTotalItems() + ",\"alreadyExists\":true}");
                } else {
                    out.print("{\"success\":true,\"message\":\"Đã thêm sản phẩm vào giỏ hàng\",\"cartCount\":" + cart.getTotalItems() + ",\"alreadyExists\":false}");
                }
                out.flush();
            } else {
                response.setContentType("application/json");
                PrintWriter out = response.getWriter();
                out.print("{\"success\":false,\"message\":\"Số lượng vượt quá tồn kho! Chỉ có thể đặt " + product.getStockQuantity() + " sản phẩm.\",\"stock\":" + product.getStockQuantity() + "}");
                out.flush();
            }
        } else {
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            out.print("{\"success\":false,\"message\":\"Sản phẩm không tồn tại!\",\"stock\":0}");
            out.flush();
        }
    } catch (NumberFormatException e) {
        response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid parameters");
    } catch (Exception e) {
        ErrDialog.showError("Error adding to cart: " + e.getMessage());
        response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Server error");
    }
}
    
    private void updateCart(HttpServletRequest request, HttpServletResponse response, Cart cart)
        throws IOException {
    try {
        int productId = Integer.parseInt(request.getParameter("productId"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));

        // Lấy sản phẩm từ database để kiểm tra stock
        Optional<Product> productOpt = productService.findProductById(productId);
        if (productOpt.isPresent()) {
            Product product = productOpt.get();
            if (quantity > product.getStockQuantity()) {
                // Trả về lỗi nếu vượt stock
                response.setContentType("application/json");
                PrintWriter out = response.getWriter();
                out.print("{\"success\":false,\"message\":\"Số lượng đặt vượt quá tồn kho! Chỉ có thể đặt " + product.getStockQuantity() + " sản phẩm.\"}");
                out.flush();
                return;
            }
        } else {
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            out.print("{\"success\":false,\"message\":\"Sản phẩm không tồn tại!\"}");
            out.flush();
            return;
        }

        // Nếu hợp lệ, update cart
        cart.updateItem(productId, quantity);

        // Return updated cart info
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        out.print("{\"success\":true,\"cartCount\":" + cart.getTotalItems() + ",\"total\":\"" + cart.getTotalAmount() + "\"}");
        out.flush();
    } catch (NumberFormatException e) {
        response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid parameters");
    }
}
    
    private void removeFromCart(HttpServletRequest request, HttpServletResponse response, Cart cart)
            throws IOException {
        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            
            cart.removeItem(productId);
            
            // Return updated cart info
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            out.print("{\"success\":true,\"cartCount\":" + cart.getTotalItems() + ",\"total\":\"" + cart.getTotalAmount() + "\"}");
            out.flush();
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid parameters");
        }
    }
    
    private void clearCart(HttpServletRequest request, HttpServletResponse response, Cart cart)
            throws IOException {
        cart.clear();
        
        // Return success response
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        out.print("{\"success\":true,\"message\":\"Cart cleared\"}");
        out.flush();
    }
    
    private Cart getOrCreateCart(HttpSession session) {
        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null) {
            cart = new Cart();
            
            // If user is logged in, try to load their cart from database
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
    
    private String getActionFromPath(String pathInfo) {
        if (pathInfo == null || pathInfo.length() <= 1) {
            return "";
        }
        return pathInfo.substring(1); // Remove leading slash
    }
    
    private String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\").replace("\"", "\\\"")
                  .replace("\n", "\\n").replace("\r", "\\r")
                  .replace("\t", "\\t");
    }
}
