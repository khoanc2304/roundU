package com.tourismapp.api;

import com.tourismapp.model.Orders;
import com.tourismapp.model.Users;
import com.tourismapp.service.order.OrderService;
import jakarta.servlet.http.HttpSession;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/orders")
public class OrderHistoryApiController {

    private final OrderService orderService = new OrderService();

    @GetMapping
    public Map<String, Object> getOrders(HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        Users user = (Users) session.getAttribute("loggedUser");

        if (user == null) {
            result.put("success", false);
            result.put("message", "Chưa đăng nhập");
            return result;
        }

        try {
            List<Orders> orders = orderService.getOrdersByUserId(user.getUserId());
            result.put("success", true);
            result.put("orders", orders);
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        }

        return result;
    }
}
