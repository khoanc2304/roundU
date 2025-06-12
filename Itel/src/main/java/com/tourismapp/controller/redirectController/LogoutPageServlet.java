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
@WebServlet(name = "LogoutPageServlet", urlPatterns = {MainControllerServlet.LOGOUTPAGE_SERVLET})
public class LogoutPageServlet extends HttpServlet {


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(true);
        if (session != null) {
            session.invalidate();
        }

        HttpSession newSession = request.getSession();
//        newSession.setAttribute("successMessage", "Đăng xuất thành công!");
        response.sendRedirect(ProjectPaths.HREF_TO_HOMEPAGE);
    }

    

    // <editor-fold defaultstate="collapsed" desc=" functional ... ">
    // </editor-fold>
}
