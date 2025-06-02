package com.tourismapp.controller.redirectController.dashboard;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.tourismapp.config.ProjectPaths;
import com.tourismapp.controller.mainController.MainControllerServlet;

/**
 *
 * @author LENOVO
 */
@WebServlet(name = "CategoryManagementServlet", urlPatterns = {MainControllerServlet.CATEGORY_MANAGEMENT_SERVLET})
public class CategoryManagementServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher(ProjectPaths.JSP_CATEGORYMANAGEMENT_PATH).forward(request, response);
    }

    // <editor-fold defaultstate="collapsed" desc=" functional ... ">
    
    // </editor-fold>
}
