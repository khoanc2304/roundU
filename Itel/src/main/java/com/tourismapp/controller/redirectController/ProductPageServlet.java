package com.tourismapp.controller.redirectController;

import com.google.gson.Gson;
import com.tourismapp.config.ProjectPaths;
import com.tourismapp.controller.mainController.MainControllerServlet;
import com.tourismapp.dto.BrandCategoryDTO;
import com.tourismapp.model.Product;
import com.tourismapp.model.ProductImage;
import com.tourismapp.service.product.IProductService;
import com.tourismapp.service.product.ProductService;
import com.tourismapp.service.relation.BrandCategoryService;
import com.tourismapp.service.relation.IBrandCategoryService;
import com.tourismapp.utils.ErrDialog;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@WebServlet(name = "ProductPageServlet", urlPatterns = {MainControllerServlet.PRODUCTPAGE_SERVLET})
public class ProductPageServlet extends HttpServlet {

    private final IProductService productService = new ProductService();
    private final IBrandCategoryService brandCategoryService = new BrandCategoryService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
//        ErrDialog.showError("ProductSer: " + action);
        if (action == null) {
            action = "";
        }

        if (MainControllerServlet.ACTION_FILTER_BY_CRITERIA.equals(action)) {
            filterProducts(request, response);
            return;
        }

        String category = request.getParameter("c");
        String brand = request.getParameter("brand");
        if (category != null) {
            showProductsByCategory(request, response);
        } //        else if (brand != null) {
        //            showProductsByBrand(request, response);
        //        } 
        else {
            showActiveProductDetail(request, response);
        }

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher(ProjectPaths.JSP_HOMEPAGE_PATH).forward(request, response);
    }

// <editor-fold defaultstate="collapsed" desc=" functional ... ">
    private void showActiveProductDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
//        ErrDialog.showError("id para: " +idParam);
        if (idParam == null || idParam.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu tham số ID product");
            return;
        }
        int id;
        try {
            id = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID không hợp lệ");
            return;
        }
        // if product actived -> product no hidden
        Optional<Product> product = productService.findProductById(id);
        Optional<List<ProductImage>> productImages = productService.getProductImagesById(id);
        Map<String, String> infoProduct = productService.getInforProductById(id);
        request.setAttribute("product", product.get());
        request.setAttribute("productImages", productImages.get());
        request.setAttribute("infoProduct", infoProduct);
        request.getRequestDispatcher(ProjectPaths.JSP_PRODUCTDETAILPAGE_PATH).forward(request, response);
    }

    private void showProductsByCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String category = request.getParameter("c");
        int id = productService.mapCategoryId(category);
        List<Product> categoryProducts = productService.getProductsByCategory(id);// lấy List<Product> cùng category từ category_id
        List<BrandCategoryDTO> brandCategoryDTOs = brandCategoryService.getBrandsByCategoryId(id);

        Map<Product, List<String>> mapProduct_Detail = new LinkedHashMap<>();
        for (Product categoryProduct : categoryProducts) {
            List<String> productDetail = productService.getProductDetailByIdTop5(categoryProduct.getProductId());
            mapProduct_Detail.put(categoryProduct, productDetail);
        }

        request.getSession().setAttribute("mapProduct_Detail", mapProduct_Detail);
        request.getSession().setAttribute("categoryId", id);
//        request.setAttribute("categoryProducts", categoryProducts);
        request.getSession().setAttribute("brandCategoryDTOs", brandCategoryDTOs);
        request.getRequestDispatcher(ProjectPaths.JSP_PRODUCTPAGE_PATH).forward(request, response);
    }

    private void filterProducts(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String category = request.getParameter("c");
        String brands = request.getParameter("brands");
        String cpus = request.getParameter("cpus");
        String minPriceStr = request.getParameter("minPrice");
        String maxPriceStr = request.getParameter("maxPrice");

        int minPrice = minPriceStr != null ? Integer.parseInt(minPriceStr) : 0;
        int maxPrice = maxPriceStr != null ? Integer.parseInt(maxPriceStr) : Integer.MAX_VALUE;

        int categoryId = productService.mapCategoryId(category);
        List<Product> filteredProducts = productService.filterProductsByCriteria(categoryId, brands, cpus, minPrice, maxPrice);

        Map<Product, List<String>> mapProduct_Detail = new LinkedHashMap<>();
        for (Product product : filteredProducts) {
            List<String> productDetail = productService.getProductDetailByIdTop5(product.getProductId());
            mapProduct_Detail.put(product, productDetail);
        }

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        Map<String, Object> jsonResponse = new LinkedHashMap<>();
        mapProduct_Detail.forEach((product, details) -> {
            jsonResponse.put(String.valueOf(product.getProductId()), new Object[]{product, details});
        });
        String json = new Gson().toJson(jsonResponse);
        response.getWriter().write(json);
    }
    // </editor-fold>
}
