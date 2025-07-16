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
import java.io.IOException;
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

//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        String category = request.getParameter("c");
//        int id = productService.mapCategoryId(category);
//        List<Product> categoryProducts = productService.getProductsByCategory(id);// lấy List<Product> cùng category từ category_id
//        List<BrandCategoryDTO> brandCategoryDTOs = brandCategoryService.getBrandsByCategoryId(id);
//        HttpSession session = request.getSession();
//        List<Product> compareList = (List<Product>) session.getAttribute("compareList");
//
//        if (compareList == null || compareList.isEmpty()) {
//            // Redirect to product page if no items to compare
//            response.sendRedirect(request.getContextPath() + ProjectPaths.HREF_TO_PRODUCTPAGE);
//            return;
//        }
//
//        Map<Product, List<String>> mapProduct_Detail = new LinkedHashMap<>();
//        for (Product categoryProduct : categoryProducts) {
//            List<String> productDetail = productService.getProductDetailByIdTop5(categoryProduct.getProductId());
//            mapProduct_Detail.put(categoryProduct, productDetail);
//        }
//
//        // Set attributes for JSP
//        request.setAttribute("mapProduct_Detail", mapProduct_Detail);
//        request.setAttribute("compareList", compareList);
//
//        // Forward to compareProduct.jsp
//        request.getRequestDispatcher(ProjectPaths.JSP_COMPARE_PATH).forward(request, response);
//    }
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

        
        Map<Product, List<String>> compateDetails = new LinkedHashMap<>();
        for (Product compareProduct : compareProducts) {
            List<String> productDetail = productService.getProductDetailByIdTop5(compareProduct.getProductId());
            compateDetails.put(compareProduct, productDetail);
        }
        
        request.setAttribute("compareDetails", compateDetails);
        
        request.getRequestDispatcher(ProjectPaths.JSP_COMPARE_PATH).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + MainControllerServlet.COMPARE_SERVLET);
    }
}
