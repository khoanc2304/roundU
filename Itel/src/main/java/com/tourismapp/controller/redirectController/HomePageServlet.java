package com.tourismapp.controller.redirectController;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.tourismapp.config.ProjectPaths;
import com.tourismapp.controller.mainController.MainControllerServlet;
import com.tourismapp.model.Product;
import com.tourismapp.service.product.IProductService;
import com.tourismapp.service.product.ProductService;
import com.tourismapp.utils.ErrDialog;
import java.util.List;

/**
 *
 * @author LENOVO
 */
@WebServlet(name = "HomePageServlet", urlPatterns = {MainControllerServlet.HOMEPAGE_SERVLET})
public class HomePageServlet extends HttpServlet {

    private final IProductService productService = new ProductService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "";
        }
        showActiveProducts(request, response);
//        request.getRequestDispatcher(ProjectPaths.JSP_HOMEPAGE_PATH).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher(ProjectPaths.JSP_HOMEPAGE_PATH).forward(request, response);
    }

    // <editor-fold defaultstate="collapsed" desc=" functional ... ">
    private void showActiveProducts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Product> activeProducts = productService.findActiveProducts();
//        ErrDialog.showError("HomePageServlet Active Product size: " + activeProducts.size());
        request.setAttribute("activeProducts", activeProducts);
        request.getRequestDispatcher(ProjectPaths.JSP_HOMEPAGE_PATH).forward(request, response);
    }
    // </editor-fold>
}
