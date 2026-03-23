package com.tourismapp.controller.redirectController.dashboard;

import com.tourismapp.common.UserRole;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import java.util.logging.Logger;

import com.tourismapp.config.ProjectPaths;
import com.tourismapp.controller.mainController.MainControllerServlet;
import com.tourismapp.dao.order.OrderDAO;
import com.tourismapp.model.Brand;
import com.tourismapp.model.Category;
import com.tourismapp.model.OrderStat;
import com.tourismapp.model.Orders;
import com.tourismapp.model.Product;
import com.tourismapp.service.brand.BrandService;
import com.tourismapp.service.brand.IBrandService;
import com.tourismapp.service.category.CategoryService;
import com.tourismapp.service.category.ICategoryService;
import com.tourismapp.service.product.IProductService;
import com.tourismapp.service.product.ProductService;
import com.tourismapp.service.user.IUserService;
import com.tourismapp.service.user.UserService;
import com.tourismapp.model.Users;
import com.tourismapp.common.UserRole;
import java.util.HashSet;
import java.util.Set;
import java.util.ArrayList;

@WebServlet(name = "DashboardPageServlet", urlPatterns = {MainControllerServlet.DASHBOARDPAGE_SERVLET})
public class DashboardPageServlet extends HttpServlet {

    private final IProductService productService = new ProductService();
    private final IBrandService brandService = new BrandService();
    private final ICategoryService categoryService = new CategoryService();
    private final OrderDAO orderDAO = new OrderDAO();
    private final IUserService userService = new UserService();
    private static final Logger LOGGER = Logger.getLogger(DashboardPageServlet.class.getName());

    private void processStatisticData(HttpServletRequest request) throws Exception {
        List<OrderStat> orderStatsByMonth = orderDAO.getOrderStatsByMonth();
        request.setAttribute("orderStatsByMonth", orderStatsByMonth);
        LOGGER.info("Dữ liệu thống kê theo tháng: " + (orderStatsByMonth != null ? orderStatsByMonth.size() : 0));

        List<Orders> allOrders = orderDAO.getAllOrders();
        request.setAttribute("allOrders", allOrders);
        LOGGER.info("Dữ liệu đơn hàng: " + (allOrders != null ? allOrders.size() : 0));

        List<OrderStat> orderStatsByStatus = orderDAO.getOrderStatsByStatus();
        request.setAttribute("orderStatsByStatus", orderStatsByStatus);
        LOGGER.info("Dữ liệu thống kê theo status: " + (orderStatsByStatus != null ? orderStatsByStatus.size() : 0));

        List<OrderStat> orderStatsByProduct = orderDAO.getOrderStatsByProduct();
        request.setAttribute("orderStatsByProduct", orderStatsByProduct);
        LOGGER.info("Dữ liệu thống kê theo sản phẩm: " + (orderStatsByProduct != null ? orderStatsByProduct.size() : 0));
    }

    private void forwardToView(HttpServletRequest request, HttpServletResponse response, String path)
            throws ServletException, IOException {
        request.getRequestDispatcher(path).forward(request, response);
    }

    private void handleError(HttpServletRequest request, HttpServletResponse response, String errorMessage)
            throws ServletException, IOException {
        request.setAttribute("error", errorMessage);
        forwardToView(request, response, ProjectPaths.JSP_DASHBOARDPAGE_PATH);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String monthParam = request.getParameter("month");
        String yearParam = request.getParameter("year");
        Integer selectedMonth = null, selectedYear = null;
        if (monthParam != null && yearParam != null) {
            try {
                selectedMonth = Integer.parseInt(monthParam);
                selectedYear = Integer.parseInt(yearParam);
            } catch (NumberFormatException e) {
                selectedMonth = null;
                selectedYear = null;
            }
        }
        List<Product> products = productService.getAllProducts();
        List<Brand> brands = brandService.getAllBrands();
        List<Category> categories = categoryService.getAllCategories();
        List<Users> users = userService.getAllUsers(); // Lấy toàn bộ user
        // Lọc chỉ khách hàng
        List<Users> customers = new java.util.ArrayList<>();
        for (Users u : users) {
            if (UserRole.CUSTOMER.equals(u.getRole())) {
                customers.add(u);
            }
        }
        session.setAttribute("products", products);
        session.setAttribute("brands", brands);
        session.setAttribute("categories", categories);
        session.setAttribute("users", customers);
        // Thêm map productId -> productName để dùng ở dashboard.jsp
        java.util.Map<Integer, String> productIdToName = new java.util.HashMap<>();
        for (Product p : products) {
            productIdToName.put(p.getProductId(), p.getName());
        }
        request.setAttribute("productIdToName", productIdToName);
        // Luôn xử lý dữ liệu thống kê khi vào dashboard
        List<Orders> allOrders = null;
        try {
            processStatisticData(request);
            allOrders = (List<Orders>) request.getAttribute("allOrders");
        } catch (Exception e) {
            LOGGER.severe("Lỗi khi tải thống kê trên dashboard: " + e.getMessage());
            handleError(request, response, "Lỗi khi tải thống kê: " + e.getMessage());
            return;
        }
        // Tính tổng doanh thu
        java.math.BigDecimal totalRevenue = java.math.BigDecimal.ZERO;
        totalRevenue = orderDAO.calculateTotalRevenue();
        if (allOrders != null) {
            for (Orders o : allOrders) {
                if (o.getTotalAmount() != null && "Completed".equals(o.getStatus())) {
                    totalRevenue = totalRevenue.add(o.getTotalAmount());
                }
            }
        }
        request.setAttribute("totalRevenue", totalRevenue);
        // Lấy doanh thu từng tháng
        List<com.tourismapp.model.OrderStat> revenueStatsByMonth = orderDAO.getRevenueStatsByMonth();
        request.setAttribute("revenueStatsByMonth", revenueStatsByMonth);
        // Lấy orderStatsByMonth để filter tháng/năm
        List<com.tourismapp.model.OrderStat> orderStatsByMonth = (List<com.tourismapp.model.OrderStat>) request.getAttribute("orderStatsByMonth");
        
        // Tạo danh sách năm duy nhất từ orderStatsByMonth
        java.util.Set<Integer> uniqueYears = new java.util.HashSet<>();
        if (orderStatsByMonth != null) {
            for (com.tourismapp.model.OrderStat stat : orderStatsByMonth) {
                uniqueYears.add(stat.getYear());
            }
        }
        java.util.List<Integer> sortedYears = new java.util.ArrayList<>(uniqueYears);
        java.util.Collections.sort(sortedYears, java.util.Collections.reverseOrder()); // Sắp xếp giảm dần
        request.setAttribute("uniqueYears", sortedYears);
        
        // Truyền selectedMonth, selectedYear lên JSP
        request.setAttribute("selectedMonth", selectedMonth);
        request.setAttribute("selectedYear", selectedYear);
        // Tìm index của tháng/năm được chọn
        int idx = -1;
        if (selectedMonth != null && selectedYear != null && orderStatsByMonth != null) {
            for (int i = 0; i < orderStatsByMonth.size(); i++) {
                if (orderStatsByMonth.get(i).getMonth() == selectedMonth && orderStatsByMonth.get(i).getYear() == selectedYear) {
                    idx = i;
                    break;
                }
            }
        } else if (orderStatsByMonth != null && !orderStatsByMonth.isEmpty()) {
            idx = orderStatsByMonth.size() - 1; // Mặc định lấy tháng mới nhất
            selectedMonth = orderStatsByMonth.get(idx).getMonth();
            selectedYear = orderStatsByMonth.get(idx).getYear();
            request.setAttribute("selectedMonth", selectedMonth);
            request.setAttribute("selectedYear", selectedYear);
        }
        // Tính % tăng/giảm cho tháng được chọn
        java.math.BigDecimal revenuePercent = null;
        Double orderPercent = null;
        Double productPercent = null;
        Double customerPercent = null;
        if (idx > 0 && orderStatsByMonth != null && revenueStatsByMonth != null && idx < revenueStatsByMonth.size()) {
            int thisMonthOrder = orderStatsByMonth.get(idx).getOrderCount();
            int lastMonthOrder = orderStatsByMonth.get(idx-1).getOrderCount();
            if (lastMonthOrder > 0) {
                orderPercent = ((double)thisMonthOrder - lastMonthOrder) / lastMonthOrder * 100.0;
            }
            java.math.BigDecimal thisMonthRevenue = revenueStatsByMonth.get(idx).getRevenue();
            java.math.BigDecimal lastMonthRevenue = revenueStatsByMonth.get(idx-1).getRevenue();
            if (lastMonthRevenue != null && lastMonthRevenue.compareTo(java.math.BigDecimal.ZERO) > 0) {
                revenuePercent = (thisMonthRevenue.subtract(lastMonthRevenue))
                    .divide(lastMonthRevenue, 4, java.math.RoundingMode.HALF_UP)
                    .multiply(new java.math.BigDecimal(100));
            }
            // Chỉ tính productPercent nếu tổng số sản phẩm thay đổi
            if (products != null && products.size() > 0) {
                int thisMonth = products.size();
                // TODO: Nếu có logic lưu số sản phẩm theo từng tháng, hãy lấy số sản phẩm tháng trước ở đây
                // Hiện tại, mặc định là không đổi
                int lastMonth = thisMonth; // Nếu có số sản phẩm tháng trước, thay bằng giá trị đó
                if (thisMonth != lastMonth) {
                    if (lastMonth > 0) {
                        productPercent = ((double)thisMonth - lastMonth) / lastMonth * 100.0;
                    }
                } else {
                    productPercent = null;
                }
            }
            if (customers != null && customers.size() > 1) {
                int thisMonth = customers.size();
                int lastMonth = thisMonth - 1;
                if (lastMonth > 0) {
                    customerPercent = ((double)thisMonth - lastMonth) / lastMonth * 100.0;
                }
            }
        } else {
            orderPercent = null;
            revenuePercent = null;
            productPercent = null;
            customerPercent = null;
        }
        request.setAttribute("revenuePercent", revenuePercent);
        request.setAttribute("orderPercent", orderPercent);
        request.setAttribute("productPercent", productPercent);
        request.setAttribute("customerPercent", customerPercent);
        // Sau khi lấy allOrders, selectedMonth, selectedYear
        List<Orders> ordersOfMonth = new java.util.ArrayList<>();
        if (allOrders != null && selectedMonth != null && selectedYear != null) {
            for (Orders o : allOrders) {
                if (o.getOrderDate() != null &&
                    o.getOrderDate().getMonthValue() == selectedMonth &&
                    o.getOrderDate().getYear() == selectedYear) {
                    // Lấy tất cả đơn hàng trong tháng, không chỉ Completed
                    ordersOfMonth.add(o);
                }
            }
        }
        request.setAttribute("ordersOfMonth", ordersOfMonth);
        
        // Debug logging
        LOGGER.info("ordersOfMonth size: " + (ordersOfMonth != null ? ordersOfMonth.size() : 0));
        LOGGER.info("selectedMonth: " + selectedMonth + ", selectedYear: " + selectedYear);
        
        // Lấy doanh thu tháng từ revenueStatsByMonth
        java.math.BigDecimal revenueOfMonth = java.math.BigDecimal.ZERO;
        if (revenueStatsByMonth != null && selectedMonth != null && selectedYear != null) {
            for (com.tourismapp.model.OrderStat stat : revenueStatsByMonth) {
                if (stat.getMonth() == selectedMonth && stat.getYear() == selectedYear) {
                    revenueOfMonth = stat.getRevenue();
                    break;
                }
            }
        }
        request.setAttribute("revenueOfMonth", revenueOfMonth);
        
        // Sau khi đã có ordersOfMonth - đếm tất cả khách hàng có đơn hàng trong tháng
        Set<Integer> customerIdsOfMonth = new HashSet<>();
        for (Orders o : ordersOfMonth) {
            if (o.getUser() != null) {
                customerIdsOfMonth.add(o.getUser().getUserId());
            }
        }
        int activeCustomerCount = customerIdsOfMonth.size();
        request.setAttribute("activeCustomerCount", activeCustomerCount);
        
        // Debug logging
        LOGGER.info("activeCustomerCount: " + activeCustomerCount);
        LOGGER.info("customerIdsOfMonth: " + customerIdsOfMonth);
        
        // Tính phần trăm tăng/giảm active customers so với tháng trước
        Double activeCustomerPercent = null;
        if (idx > 0 && orderStatsByMonth != null && idx < orderStatsByMonth.size()) {
            int lastMonth = orderStatsByMonth.get(idx-1).getMonth();
            int lastYear = orderStatsByMonth.get(idx-1).getYear();
            List<Orders> ordersOfLastMonth = new ArrayList<>();
            for (Orders o : allOrders) {
                if (o.getOrderDate() != null &&
                    o.getOrderDate().getMonthValue() == lastMonth &&
                    o.getOrderDate().getYear() == lastYear) {
                    ordersOfLastMonth.add(o);
                }
            }
            Set<Integer> customerIdsOfLastMonth = new HashSet<>();
            for (Orders o : ordersOfLastMonth) {
                if (o.getUser() != null) {
                    customerIdsOfLastMonth.add(o.getUser().getUserId());
                }
            }
            int activeCustomerCountLastMonth = customerIdsOfLastMonth.size();
            if (activeCustomerCountLastMonth > 0) {
                activeCustomerPercent = ((double)activeCustomerCount - activeCustomerCountLastMonth) / activeCustomerCountLastMonth * 100.0;
            }
        }
        request.setAttribute("activeCustomerPercent", activeCustomerPercent);
        forwardToView(request, response, ProjectPaths.JSP_DASHBOARDPAGE_PATH);
    }
}