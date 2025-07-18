package com.tourismapp.api;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.tourismapp.model.Orders;
import com.tourismapp.model.Users;
import com.tourismapp.service.order.OrderService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "OrderHistoryApiServlet", urlPatterns = {"/api/orders"})
public class OrderHistoryApiServlet extends HttpServlet {
    private final OrderService orderService = new OrderService();
    private final ObjectMapper objectMapper = new ObjectMapper();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("loggedUser");
        Map<String, Object> result = new HashMap<>();
        if (user == null) {
            result.put("success", false);
            result.put("message", "Chưa đăng nhập");
            response.getWriter().write(objectMapper.writeValueAsString(result));
            return;
        }
        try {
            List<Orders> orders = orderService.getOrdersByUserId(user.getUserId());
            result.put("success", true);
            result.put("orders", orders);
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        response.getWriter().write(objectMapper.writeValueAsString(result));
    }
}
