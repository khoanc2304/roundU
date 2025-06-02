/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.tourismapp.controller.redirectController;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.tourismapp.config.ProjectPaths;
import com.tourismapp.controller.mainController.MainControllerServlet;

/**
 *
 * @author LENOVO
 */
@WebServlet(name = "LoginPageServlet", urlPatterns = {MainControllerServlet.LOGINPAGE_SERVLET})
public class LoginPageServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher(ProjectPaths.JSP_LOGINPAGE_PATH).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action").trim();
        
        if (action.equals(MainControllerServlet.ACTION_LOGIN)) {
            HttpSession session = request.getSession(true);
            session.setAttribute("user", "da ton tai user");
            request.getRequestDispatcher(MainControllerServlet.HOMEPAGE_REDIRECT).forward(request, response);
            return;
        }
        request.getRequestDispatcher(ProjectPaths.JSP_LOGINPAGE_PATH).forward(request, response);
    }

    // <editor-fold defaultstate="collapsed" desc=" functional ... ">
    
    // </editor-fold>
    
}
