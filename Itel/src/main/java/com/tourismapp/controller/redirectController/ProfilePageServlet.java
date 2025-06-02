package com.tourismapp.controller.redirectController;

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
@WebServlet(name = "ProfilePageServlet", urlPatterns = {MainControllerServlet.PROFILEPAGE_SERVLET})
public class ProfilePageServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher(ProjectPaths.JSP_PROFILEPAGE_PATH).forward(request, response);
    }

    // <editor-fold defaultstate="collapsed" desc=" functional ... ">
    
    // </editor-fold>
}
