package com.tourismapp.controller.redirectController.dashboard;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.tourismapp.config.ProjectPaths;
import com.tourismapp.controller.mainController.MainControllerServlet;
import com.tourismapp.model.Orders;
import com.tourismapp.service.order.IOrderService;
import com.tourismapp.service.order.OrderService;
import com.tourismapp.utils.ErrDialog;
import java.util.List;

/**
 *
 * @author LENOVO
 */
@WebServlet(name = "OrderManagementServlet", urlPatterns = {MainControllerServlet.ORDER_MANAGEMENT_SERVLET})
public class OrderManagementServlet extends HttpServlet {
    private IOrderService orderService;

    @Override
    public void init() throws ServletException {
        orderService = new OrderService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("viewOrderDetail".equals(action)) {
            String orderIdStr = request.getParameter("orderId");
            if (orderIdStr != null) {
                try {
                    int orderId = Integer.parseInt(orderIdStr);
                    Orders order = orderService.findAllOrders().stream()
                        .filter(o -> o.getOrderId() == orderId)
                        .findFirst().orElse(null);
                    if (order != null) {
                        // Lấy danh sách sản phẩm trong đơn hàng
                        order.setOrderDetails(orderService.getOrderDetailsByOrderId(orderId));
                        request.setAttribute("order", order);
                        request.getRequestDispatcher("/WEB-INF/view/dashboard/orderManagement/orderDetail.jsp").forward(request, response);
                        return;
                    } else {
                        request.setAttribute("errorMessage", "Không tìm thấy đơn hàng.");
                    }
                } catch (Exception e) {
                    request.setAttribute("errorMessage", "Lỗi khi xem chi tiết đơn hàng: " + e.getMessage());
                }
            } else {
                request.setAttribute("errorMessage", "Thiếu mã đơn hàng.");
            }
            // Nếu lỗi, forward về trang quản lý đơn hàng
            List<Orders> orders = orderService.findAllOrders();
            request.setAttribute("orders", orders);
            request.getRequestDispatcher(com.tourismapp.config.ProjectPaths.JSP_ORDERMANAGEMENT_PATH).forward(request, response);
            return;
        }
        // Lấy danh sách tất cả đơn hàng
        List<Orders> orders = orderService.findAllOrders();
        request.setAttribute("orders", orders);
        System.out.println("DEBUG: orders.size() = " + (orders != null ? orders.size() : "null"));
        // Forward sang trang quản lý đơn hàng
        request.getRequestDispatcher(ProjectPaths.JSP_ORDERMANAGEMENT_PATH).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String orderIdStr = request.getParameter("orderId");
        String status = request.getParameter("status");
        if (orderIdStr != null && status != null) {
            try {
                int orderId = Integer.parseInt(orderIdStr);
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
        // Lấy lại danh sách đơn hàng và forward về trang quản lý
        List<Orders> orders = orderService.findAllOrders();
        request.setAttribute("orders", orders);
        request.getRequestDispatcher(com.tourismapp.config.ProjectPaths.JSP_ORDERMANAGEMENT_PATH).forward(request, response);
    }

    // <editor-fold defaultstate="collapsed" desc=" functional ... ">
    // Có thể bổ sung các hàm xử lý khác nếu cần
    // </editor-fold>
}
