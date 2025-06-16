/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.tourismapp.controller.redirectController;

import com.tourismapp.common.UserRole;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.tourismapp.config.ProjectPaths;
import com.tourismapp.controller.mainController.MainControllerServlet;
import com.tourismapp.model.Users;
import com.tourismapp.service.user.IUserService;
import com.tourismapp.service.user.UserService;
import com.tourismapp.utils.ErrDialog;
import java.util.Optional;

/**
 *
 * @author LENOVO
 */
@WebServlet(name = "LoginPageServlet", urlPatterns = {MainControllerServlet.LOGINPAGE_SERVLET})
public class LoginPageServlet extends HttpServlet {

    private final IUserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher(ProjectPaths.JSP_LOGINPAGE_PATH).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action").trim();
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        HttpSession session = request.getSession(true);

        if (action != null && action.equals(MainControllerServlet.ACTION_LOGIN)) {
            Optional<Users> loggedUser = userService.findUserByCredentials(username, email, password);
//            ErrDialog.showError("loggedUser: " + loggedUser);
            if (loggedUser.isPresent()) {
                Users user = loggedUser.get();
                session.setAttribute("loggedUser", user);
                String role = user.getRole().getValue();
                session.setAttribute("successMessage", "Đăng nhập thành công.");

                switch (role) {
                    case "admin" -> {
//                        request.getRequestDispatcher(ProjectPaths.JSP_DASHBOARDPAGE_PATH).forward(request, response);
                          response.sendRedirect(ProjectPaths.HREF_TO_DASHBOARDPAGE);
                    }
                    case "staff" -> {
                        request.getRequestDispatcher(ProjectPaths.JSP_DASHBOARDPAGE_PATH).forward(request, response);
                    }
                    case "customer" -> {
                        request.getRequestDispatcher(ProjectPaths.JSP_HOMEPAGE_PATH).forward(request, response);
                    }
                    default ->
                        request.getRequestDispatcher(ProjectPaths.JSP_HOMEPAGE_PATH).forward(request, response);
                }
            } else {
                session.setAttribute("errorMessage", "Sai tài khoản hoặc mật khẩu. Vui lòng nhập lại!");
                response.sendRedirect(ProjectPaths.HREF_TO_LOGINPAGE);
            }
        } else {
            session.setAttribute("errorMessage", "Lỗi trong quá trình đăng nhập. Đăng nhập thất bại!");
            response.sendRedirect(ProjectPaths.HREF_TO_LOGINPAGE);
        }
    }

    // <editor-fold defaultstate="collapsed" desc=" functional ... ">
    // </editor-fold>
}
