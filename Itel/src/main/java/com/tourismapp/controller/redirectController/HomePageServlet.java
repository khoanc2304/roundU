package com.tourismapp.controller.redirectController;

import com.tourismapp.config.ProjectPaths;
import com.tourismapp.controller.mainController.MainControllerServlet;
import com.tourismapp.model.Brand;
import com.tourismapp.model.Category;
import com.tourismapp.model.Product;
import com.tourismapp.service.brand.BrandService;
import com.tourismapp.service.brand.IBrandService;
import com.tourismapp.service.category.CategoryService;
import com.tourismapp.service.category.ICategoryService;
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
import java.util.List;

@WebServlet(name = "HomePageServlet", urlPatterns = {MainControllerServlet.HOMEPAGE_SERVLET})
public class HomePageServlet extends HttpServlet {

    private final IProductService productService = new ProductService();
    private final ICategoryService categoryService = new CategoryService();
    private final IBrandService brandService = new BrandService();
    private final IBrandCategoryService brandCategoryService = new BrandCategoryService();
    

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "";
        }
        switch (action) {
            case MainControllerServlet.ACTION_SEARCH_ACTIVE_PRODUCT ->
                searchActiveProduct(request, response);
            default ->
                showActiveProducts(request, response);
        }
    }

// <editor-fold defaultstate="collapsed" desc=" functional ... ">
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher(ProjectPaths.JSP_HOMEPAGE_PATH).forward(request, response);
    }

    private void showActiveProducts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Product> activeProducts = productService.getActiveProducts();
        List<Category> categories = categoryService.getAllCategories();
        List<Brand> activeBrands = brandService.getActiveBrands();
        
        for (Category c : categories){
            request.getSession().setAttribute(c.getName() + "ImageUrl", c.getImageUrl());
        }
        
        request.getSession().setAttribute("categories", categories);
        request.getSession().setAttribute("activeProducts", activeProducts);
        request.getSession().setAttribute("activeBrands", activeBrands);
        request.getRequestDispatcher(ProjectPaths.JSP_HOMEPAGE_PATH).forward(request, response);
    }

    private void searchActiveProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String q = request.getParameter("qProduct");
        List<Product> products;
        if (q == null || q.isEmpty()) {
            products = productService.getActiveProducts();
        } else {
            products = productService.searchActiveProductsByName(q);
        }
        request.getSession().setAttribute("activeProducts", products);
        request.getRequestDispatcher(ProjectPaths.JSP_HOMEPAGE_PATH).forward(request, response);
    }
    // </editor-fold>
}
