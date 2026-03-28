package com.tourismapp.controller.dashboardController;

import com.tourismapp.config.ProjectPaths;
import com.tourismapp.entity.Orders;
import com.tourismapp.service.order.IOrderService;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.stereotype.Controller;
import com.tourismapp.annotation.RequiresRole;
import com.tourismapp.common.UserRole;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@RequiresRole({UserRole.ADMIN, UserRole.STAFF})
@Controller
@RequestMapping("/orderManagement")
public class OrderManagementController {

    @Autowired
    private IOrderService orderService;

    @GetMapping
    public String showOrderManagement(@RequestParam(value = "action", required = false) String action,
                                      @RequestParam(value = "status", required = false, defaultValue = "all") String status,
                                      @RequestParam(value = "orderId", required = false) Integer orderId,
                                      HttpServletRequest request) {

        if ("viewOrderDetail".equals(action) && orderId != null) {
            try {
                Orders order = orderService.findAllOrders().stream()
                        .filter(o -> o.getOrderId() == orderId)
                        .findFirst().orElse(null);
                if (order != null) {
                    order.setOrderDetails(orderService.getOrderDetailsByOrderId(orderId));
                    request.setAttribute("order", order);
                    return "/WEB-INF/view/dashboard/orderManagement/orderDetail.jsp";
                } else {
                    request.setAttribute("errorMessage", "Không tìm thấy đơn hàng.");
                }
            } catch (Exception e) {
                request.setAttribute("errorMessage", "Lỗi khi xem chi tiết đơn hàng: " + e.getMessage());
            }
        }

        List<Orders> orders = ("all".equals(status) || status.isEmpty()) ? orderService.findAllOrders() : orderService.findOrdersByStatus(status);
        request.setAttribute("orders", orders);
        return ProjectPaths.JSP_ORDERMANAGEMENT_PATH;
    }

    @PostMapping
    public String updateOrderStatus(@RequestParam("orderId") Integer orderId,
                                    @RequestParam("status") String status,
                                    @RequestParam(value = "filterStatus", required = false, defaultValue = "all") String filterStatus,
                                    HttpServletRequest request) {
        if (orderId != null && status != null) {
            try {
                boolean updated = orderService.updateOrderStatus(orderId, status);
                if (updated) {
                    request.setAttribute("successMessage", "Cập nhật trạng thái thành công!");
                } else {
                    request.setAttribute("errorMessage", "Cập nhật trạng thái thất bại!");
                }
            } catch (Exception e) {
                request.setAttribute("errorMessage", "Lỗi cập nhật trạng thái: " + e.getMessage());
            }
        }

        List<Orders> orders = ("all".equals(filterStatus) || filterStatus.isEmpty()) ? orderService.findAllOrders() : orderService.findOrdersByStatus(filterStatus);
        request.setAttribute("orders", orders);
        return ProjectPaths.JSP_ORDERMANAGEMENT_PATH;
    }
}
