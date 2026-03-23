package com.tourismapp.controller.redirectController;

import com.tourismapp.config.ProjectPaths;
import com.tourismapp.controller.mainController.MainControllerServlet;
import com.tourismapp.model.Product;
import com.tourismapp.service.product.IProductService;
import com.tourismapp.service.product.ProductService;
import com.tourismapp.service.relation.BrandCategoryService;
import com.tourismapp.service.relation.IBrandCategoryService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import java.util.stream.Stream;

@WebServlet(name = "ComparePageServlet", urlPatterns = {MainControllerServlet.COMPARE_SERVLET})
public class ComparePageServlet extends HttpServlet {

    private IProductService productService = new ProductService();
    private IBrandCategoryService brandCategoryService = new BrandCategoryService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String productIds = request.getParameter("productIds");
        String[] ids = productIds.split("-");
        List<Product> compareProducts = Arrays.stream(ids)
                .map(Integer::parseInt)
                .map(productService::findProductById)
                .flatMap(opt -> opt.map(Stream::of).orElseGet(Stream::empty))
                .collect(Collectors.toList());

        Map<Product, List<String>> compareDetails = new LinkedHashMap<>();
        for (Product compareProduct : compareProducts) {
            List<String> productDetail = productService.getProductDetailByIdTop5(compareProduct.getProductId());
            compareDetails.put(compareProduct, productDetail);
        }

        HttpSession session = request.getSession();
        session.setAttribute("compareDetails", compareDetails);

        request.getRequestDispatcher(ProjectPaths.JSP_COMPARE_PATH).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String action = request.getParameter("action");
        String productId = request.getParameter("productId");

        List<String> compareList = (List<String>) session.getAttribute("compareList");
        if (compareList == null) {
            compareList = new ArrayList<>();
        }

        if ("addCompare".equals(action) && productId != null && !compareList.contains(productId)) {
            if (compareList.size() < 3) { 
                compareList.add(productId);
            }
        } else if ("removeCompare".equals(action) && productId != null) {
            compareList.remove(productId);
        } else if ("clearCompare".equals(action)) {
            compareList.clear();
        }

        session.setAttribute("compareList", compareList);

        response.setContentType("application/json");
        response.getWriter().write("{\"compareList\": [" + String.join(",", compareList.stream().map(id -> "\"" + id + "\"").toArray(String[]::new)) + "]}");
    }
}
