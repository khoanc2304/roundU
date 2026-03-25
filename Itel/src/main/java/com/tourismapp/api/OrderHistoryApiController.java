package com.tourismapp.api;

import com.tourismapp.entity.Orders;
import com.tourismapp.entity.Users;
import com.tourismapp.service.order.IOrderService;
import jakarta.servlet.http.HttpSession;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/orders")
public class OrderHistoryApiController {

    @Autowired
    private IOrderService orderService;

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
