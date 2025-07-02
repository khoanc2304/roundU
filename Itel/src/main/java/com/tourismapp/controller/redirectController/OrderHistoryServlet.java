package com.tourismapp.controller.redirectController;

import com.tourismapp.config.ProjectPaths;
import com.tourismapp.controller.mainController.MainControllerServlet;
import com.tourismapp.model.Users;
import com.tourismapp.model.Orders;
import com.tourismapp.service.order.OrderService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

/**
 * Order History Servlet
 * @author Admin
 */
@WebServlet(name = "OrderHistoryServlet", urlPatterns = {MainControllerServlet.ORDERHISTORY_SERVLET})
public class OrderHistoryServlet extends HttpServlet {
    
    private final OrderService orderService = new OrderService();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        // Check if user is logged in
        Users user = (Users) session.getAttribute("loggedUser");
        
        if (user == null) {
            response.sendRedirect("/Itel/main?action=loginPage");
            return;
        }
        
        try {
            // Get user's orders
            List<Orders> orders = orderService.getOrdersByUserId(user.getUserId());
            
            // Set attributes for JSP
            request.setAttribute("orders", orders);
            request.setAttribute("user", user);
            
            // Forward to order history page
            request.getRequestDispatcher(ProjectPaths.JSP_ORDERHISTORY_PATH).forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi tải lịch sử đơn hàng: " + e.getMessage());
            request.getRequestDispatcher(ProjectPaths.JSP_ORDERHISTORY_PATH).forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
