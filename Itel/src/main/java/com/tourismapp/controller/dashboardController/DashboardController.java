package com.tourismapp.controller.dashboardController;

import com.tourismapp.common.UserRole;
import com.tourismapp.config.ProjectPaths;
import com.tourismapp.controller.mainController.MainControllerServlet;
import com.tourismapp.entity.Brand;
import com.tourismapp.entity.Category;
import com.tourismapp.dto.OrderStat;
import com.tourismapp.entity.Orders;
import org.springframework.beans.factory.annotation.Autowired;
import com.tourismapp.entity.Product;
import com.tourismapp.entity.Users;
import com.tourismapp.service.brand.BrandService;
import com.tourismapp.service.brand.IBrandService;
import com.tourismapp.service.category.CategoryService;
import com.tourismapp.service.category.ICategoryService;
import com.tourismapp.service.product.IProductService;
import com.tourismapp.service.user.IUserService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.*;
import java.util.logging.Logger;

@Controller
@RequestMapping(MainControllerServlet.DASHBOARDPAGE_SERVLET)
public class DashboardController {

    @Autowired
    private IProductService productService;
    @Autowired private IBrandService brandService;
    @Autowired private ICategoryService categoryService;
    @Autowired
    private com.tourismapp.repository.order.OrderRepository OrderRepository;
    @Autowired
    private IUserService userService;
    private static final Logger LOGGER = Logger.getLogger(DashboardController.class.getName());

    @GetMapping
    public String showDashboard(@RequestParam(value = "month", required = false) Integer selectedMonth,
                                @RequestParam(value = "year", required = false) Integer selectedYear,
                                HttpServletRequest request, HttpSession session) {

        List<Product> products = productService.getAllProducts();
        List<Brand> brands = brandService.getAllBrands();
        List<Category> categories = categoryService.getAllCategories();
        List<Users> users = userService.getAllUsers();

        List<Users> customers = new ArrayList<>();
        for (Users u : users) {
            if (UserRole.CUSTOMER.equals(u.getRole())) {
                customers.add(u);
            }
        }

        session.setAttribute("products", products);
        session.setAttribute("brands", brands);
        session.setAttribute("categories", categories);
        session.setAttribute("users", customers);

        Map<Integer, String> productIdToName = new HashMap<>();
        for (Product p : products) {
            productIdToName.put(p.getProductId(), p.getName());
        }
        request.setAttribute("productIdToName", productIdToName);

        List<Orders> allOrders;
        try {
            processStatisticData(request);
            allOrders = (List<Orders>) request.getAttribute("allOrders");
        } catch (Exception e) {
            LOGGER.severe("Lỗi khi tải thống kê: " + e.getMessage());
            request.setAttribute("error", "Lỗi khi tải thống kê: " + e.getMessage());
            return ProjectPaths.JSP_DASHBOARDPAGE_PATH;
        }

        BigDecimal totalRevenue = OrderRepository.calculateTotalRevenue();
        if (allOrders != null) {
            for (Orders o : allOrders) {
                if (o.getTotalAmount() != null && "Completed".equals(o.getStatus())) {
                    totalRevenue = totalRevenue.add(o.getTotalAmount());
                }
            }
        }
        request.setAttribute("totalRevenue", totalRevenue);

        List<OrderStat> revenueStatsByMonth = OrderRepository.getRevenueStatsByMonth();
        request.setAttribute("revenueStatsByMonth", revenueStatsByMonth);

        List<OrderStat> orderStatsByMonth = (List<OrderStat>) request.getAttribute("orderStatsByMonth");

        Set<Integer> uniqueYears = new HashSet<>();
        if (orderStatsByMonth != null) {
            for (OrderStat stat : orderStatsByMonth) {
                uniqueYears.add(stat.getYear());
            }
        }
        List<Integer> sortedYears = new ArrayList<>(uniqueYears);
        sortedYears.sort(Collections.reverseOrder());
        request.setAttribute("uniqueYears", sortedYears);

        int idx = -1;
        if (selectedMonth != null && selectedYear != null && orderStatsByMonth != null) {
            for (int i = 0; i < orderStatsByMonth.size(); i++) {
                if (orderStatsByMonth.get(i).getMonth() == selectedMonth && orderStatsByMonth.get(i).getYear() == selectedYear) {
                    idx = i;
                    break;
                }
            }
        } else if (orderStatsByMonth != null && !orderStatsByMonth.isEmpty()) {
            idx = orderStatsByMonth.size() - 1;
            selectedMonth = orderStatsByMonth.get(idx).getMonth();
            selectedYear = orderStatsByMonth.get(idx).getYear();
        }

        request.setAttribute("selectedMonth", selectedMonth);
        request.setAttribute("selectedYear", selectedYear);

        BigDecimal revenuePercent = null;
        Double orderPercent = null;
        Double productPercent = null;
        Double customerPercent = null;

        if (idx > 0 && orderStatsByMonth != null && revenueStatsByMonth != null && idx < revenueStatsByMonth.size()) {
            int thisMonthOrder = orderStatsByMonth.get(idx).getOrderCount();
            int lastMonthOrder = orderStatsByMonth.get(idx - 1).getOrderCount();
            if (lastMonthOrder > 0) {
                orderPercent = ((double) thisMonthOrder - lastMonthOrder) / lastMonthOrder * 100.0;
            }

            BigDecimal thisMonthRevenue = revenueStatsByMonth.get(idx).getRevenue();
            BigDecimal lastMonthRevenue = revenueStatsByMonth.get(idx - 1).getRevenue();
            if (lastMonthRevenue != null && lastMonthRevenue.compareTo(BigDecimal.ZERO) > 0) {
                revenuePercent = (thisMonthRevenue.subtract(lastMonthRevenue))
                        .divide(lastMonthRevenue, 4, RoundingMode.HALF_UP)
                        .multiply(new BigDecimal(100));
            }

            if (products != null && !products.isEmpty()) {
                productPercent = 0.0; // Simulated unchanged product size logic
            }

            if (customers.size() > 1) {
                int thisMonth = customers.size();
                int lastMonth = thisMonth - 1;
                if (lastMonth > 0) {
                    customerPercent = ((double) thisMonth - lastMonth) / lastMonth * 100.0;
                }
            }
        }

        request.setAttribute("revenuePercent", revenuePercent);
        request.setAttribute("orderPercent", orderPercent);
        request.setAttribute("productPercent", productPercent);
        request.setAttribute("customerPercent", customerPercent);

        List<Orders> ordersOfMonth = new ArrayList<>();
        if (allOrders != null && selectedMonth != null && selectedYear != null) {
            for (Orders o : allOrders) {
                if (o.getOrderDate() != null &&
                        o.getOrderDate().getMonthValue() == selectedMonth &&
                        o.getOrderDate().getYear() == selectedYear) {
                    ordersOfMonth.add(o);
                }
            }
        }
        request.setAttribute("ordersOfMonth", ordersOfMonth);

        BigDecimal revenueOfMonth = BigDecimal.ZERO;
        if (revenueStatsByMonth != null && selectedMonth != null && selectedYear != null) {
            for (OrderStat stat : revenueStatsByMonth) {
                if (stat.getMonth() == selectedMonth && stat.getYear() == selectedYear) {
                    revenueOfMonth = stat.getRevenue();
                    break;
                }
            }
        }
        request.setAttribute("revenueOfMonth", revenueOfMonth);

        Set<Integer> customerIdsOfMonth = new HashSet<>();
        for (Orders o : ordersOfMonth) {
            if (o.getUser() != null) {
                customerIdsOfMonth.add(o.getUser().getUserId());
            }
        }
        request.setAttribute("activeCustomerCount", customerIdsOfMonth.size());

        Double activeCustomerPercent = null;
        if (idx > 0 && orderStatsByMonth != null && idx < orderStatsByMonth.size()) {
            int lastMonth = orderStatsByMonth.get(idx - 1).getMonth();
            int lastYear = orderStatsByMonth.get(idx - 1).getYear();
            Set<Integer> customerIdsOfLastMonth = new HashSet<>();
            for (Orders o : allOrders) {
                if (o.getOrderDate() != null &&
                        o.getOrderDate().getMonthValue() == lastMonth &&
                        o.getOrderDate().getYear() == lastYear && o.getUser() != null) {
                    customerIdsOfLastMonth.add(o.getUser().getUserId());
                }
            }
            int activeCustomerCountLastMonth = customerIdsOfLastMonth.size();
            if (activeCustomerCountLastMonth > 0) {
                activeCustomerPercent = ((double) customerIdsOfMonth.size() - activeCustomerCountLastMonth) / activeCustomerCountLastMonth * 100.0;
            }
        }
        request.setAttribute("activeCustomerPercent", activeCustomerPercent);

        return ProjectPaths.JSP_DASHBOARDPAGE_PATH;
    }

    private void processStatisticData(HttpServletRequest request) throws Exception {
        request.setAttribute("orderStatsByMonth", OrderRepository.getOrderStatsByMonth());
        request.setAttribute("allOrders", OrderRepository.getAllOrders());
        request.setAttribute("orderStatsByStatus", OrderRepository.getOrderStatsByStatus());
        request.setAttribute("orderStatsByProduct", OrderRepository.getOrderStatsByProduct());
    }
}
