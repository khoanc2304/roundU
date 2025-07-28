package com.tourismapp.controller.redirectController;

import java.io.IOException;
import java.util.Optional;

import com.tourismapp.config.ProjectPaths;
import com.tourismapp.controller.mainController.MainControllerServlet;
import com.tourismapp.model.Cart;
import com.tourismapp.model.Product;
import com.tourismapp.model.Users;
import com.tourismapp.service.product.ProductService;
import com.tourismapp.service.user.IUserService;
import com.tourismapp.service.user.UserService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Checkout Page Servlet
 *
 * @author Admin
 */
@WebServlet(name = "CheckoutPageServlet", urlPatterns = {MainControllerServlet.CHECKOUTPAGE_SERVLET})
public class CheckoutPageServlet extends HttpServlet {

    private UserService userService = new UserService();
    private ProductService productService = new ProductService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("CheckoutPageServlet doGet called");

        HttpSession session = request.getSession();

        // Check if user is logged in
        Users user = (Users) session.getAttribute("loggedUser");
        System.out.println("User found: " + (user != null ? user.getFullName() : "null"));

        if (user == null) {
            System.out.println("User not logged in, redirecting to login");
            response.sendRedirect("/Itel/main?action=loginPage");
            return;
        }

        // Nếu người dùng đã đăng nhập, tải lại thông tin mới nhất từ cơ sở dữ liệu
        if (user != null) {
            IUserService userService = new UserService();
            Users updatedUser = userService.getUserById(user.getUserId());
            if (updatedUser != null) {
                session.setAttribute("loggedUser", updatedUser);
                user = updatedUser;
            }
        }

        // Get cart from session
        Cart cart = (Cart) session.getAttribute("cart");
        System.out.println("Cart found: " + (cart != null ? "Yes, " + cart.getTotalItems() + " items" : "null"));

        if (cart == null || cart.isEmpty()) {
            System.out.println("Cart is empty, redirecting to cart page");
            response.sendRedirect("/Itel/main?action=cartPage");
            return;
        }

        // Get updated user info from database
        try {
            Users fullUser = userService.getUserById(user.getUserId());
            request.setAttribute("user", fullUser != null ? fullUser : user);
        } catch (Exception e) {
            request.setAttribute("user", user);
        }

        // Set cart for checkout page (all items by default)
        request.setAttribute("cart", cart);
        request.setAttribute("checkoutType", "all");

        System.out.println("Forwarding to checkout page: " + ProjectPaths.JSP_CHECKOUTPAGE_PATH);

        // Forward to checkout page
        request.getRequestDispatcher(ProjectPaths.JSP_CHECKOUTPAGE_PATH).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("CheckoutPageServlet doPost called - handling selected items");

        HttpSession session = request.getSession();

        // Check if user is logged in
        Users user = (Users) session.getAttribute("loggedUser");
        if (user == null) {
            response.sendRedirect("/Itel/main?action=loginPage");
            return;
        }

        // Get selected items from form
        String[] productIds = request.getParameterValues("selectedItems[].productId");
        String[] quantities = request.getParameterValues("selectedItems[].quantity");

        // Handle different parameter name formats
        if (productIds == null) {
            // Try alternative parameter names
            String[] altProductIds = new String[100]; // Max 100 items
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
            System.out.println("No selected items, redirecting to cart");
            response.sendRedirect("/Itel/main?action=cartPage");
            return;
        }

        System.out.println("Selected items count: " + productIds.length);

        // Create a temporary cart with only selected items
        Cart selectedCart = new Cart();

        for (int i = 0; i < productIds.length; i++) {
            try {
                int productId = Integer.parseInt(productIds[i]);
                int quantity = Integer.parseInt(quantities[i]);

                System.out.println("Processing selected item: Product ID " + productId + ", Quantity " + quantity);

                // Get product from database
                Optional<Product> productOpt = productService.findProductById(productId);
                if (productOpt.isPresent()) {
                    Product product = productOpt.get();
                    selectedCart.addItem(product, quantity);
                    System.out.println("Added to selected cart: " + product.getName());
                }
            } catch (NumberFormatException e) {
                System.err.println("Invalid product ID or quantity: " + e.getMessage());
            }
        }

        if (selectedCart.isEmpty()) {
            System.out.println("No valid selected items, redirecting to cart");
            response.sendRedirect("/Itel/main?action=cartPage");
            return;
        }

        System.out.println("Selected cart created with " + selectedCart.getTotalItems() + " items, total: " + selectedCart.getTotalAmount());

        // Get updated user info
        try {
            Users fullUser = userService.getUserById(user.getUserId());
            request.setAttribute("user", fullUser != null ? fullUser : user);
        } catch (Exception e) {
            request.setAttribute("user", user);
        }

        // Set selected cart and checkout type
        request.setAttribute("cart", selectedCart);
        request.setAttribute("checkoutType", "selected");
        request.setAttribute("selectedItemsCount", selectedCart.getTotalItems());

        System.out.println("Forwarding to checkout page with selected items");

        // Forward to checkout page
        request.getRequestDispatcher(ProjectPaths.JSP_CHECKOUTPAGE_PATH).forward(request, response);
    }
}
