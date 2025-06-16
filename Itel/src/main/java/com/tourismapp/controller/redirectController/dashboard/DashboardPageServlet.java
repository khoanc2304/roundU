package com.tourismapp.controller.redirectController.dashboard;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
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
import jakarta.servlet.http.HttpSession;
import java.util.List;

/**
 *
 * @author LENOVO
 */
@WebServlet(name = "DashboardPageServlet", urlPatterns = {MainControllerServlet.DASHBOARDPAGE_SERVLET})
public class DashboardPageServlet extends HttpServlet {

    private final IProductService productService = new ProductService();
    private final IBrandService brandService = new BrandService();
    private final ICategoryService categoryService = new CategoryService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        List<Product> products = productService.getAllProducts(); 
        List<Brand> brands = brandService.getAllBrands(); 
        List<Category> categories = categoryService.getAllCategories(); 

        session.setAttribute("products", products);
        session.setAttribute("categories", categories);
        session.setAttribute("brands", brands);

        request.getSession().setAttribute("products", products);
        request.getSession().setAttribute("brands", brands);
        request.getSession().setAttribute("categories", categories);

        request.getRequestDispatcher(ProjectPaths.JSP_DASHBOARDPAGE_PATH).forward(request, response);
    }

    // <editor-fold defaultstate="collapsed" desc=" functional ... ">
    // </editor-fold>
}
