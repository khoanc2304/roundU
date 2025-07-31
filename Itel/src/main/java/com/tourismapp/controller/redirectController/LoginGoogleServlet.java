/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.tourismapp.controller.redirectController;

import com.tourismapp.config.ProjectPaths;
import com.tourismapp.constant.GoogleLogin;
import com.tourismapp.model.GoogleAccount;
import com.tourismapp.model.Users;
import com.tourismapp.service.user.UserService;
import com.tourismapp.common.UserRole;
import com.tourismapp.common.MembershipLevel;
import com.tourismapp.common.Status;
import com.tourismapp.utils.ErrDialog;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.Optional;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "LoginGoogleServlet", urlPatterns = {"/loginGoogle"})
public class LoginGoogleServlet extends HttpServlet {

    private final UserService userService = new UserService();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        try {
            String code = request.getParameter("code");
            if (code == null || code.isEmpty()) {
//                ErrDialog.showError("Authorization code is missing");
                response.sendRedirect(ProjectPaths.HREF_TO_LOGINPAGE);
                return;
            }

            String accessToken = GoogleLogin.getToken(code);
            if (accessToken == null) {
//                ErrDialog.showError("Failed to retrieve access token");
                response.sendRedirect(ProjectPaths.HREF_TO_LOGINPAGE);
                return;
            }

            GoogleAccount googleAccount = GoogleLogin.getUserInfo(accessToken);
            if (googleAccount == null) {
//                ErrDialog.showError("Failed to retrieve user information");
                response.sendRedirect(ProjectPaths.HREF_TO_LOGINPAGE);
                return;
            }

            Optional<Users> existingUser = userService.findUserByEmail(googleAccount.getEmail());
            Users user;

            if (existingUser.isPresent()) {
                user = existingUser.get();
                user.setFullName(googleAccount.getName());
                user.setImageUrl(googleAccount.getPicture());
                user.setUpdatedAt(LocalDateTime.now());
                userService.updateUser(user);
            } else {
                user = new Users();
                user.setUsername("google_" + googleAccount.getId());
                user.setPassword("");
                user.setFullName(googleAccount.getName());
                user.setEmail(googleAccount.getEmail());
                user.setPhone("");
                user.setAddress("");
                user.setRole(UserRole.CUSTOMER);
                user.setMembershipLevel(MembershipLevel.STANDARD);
                user.setImageUrl(googleAccount.getPicture());

                user.setStatus(Status.ACTIVE);
                user.setCreatedAt(LocalDateTime.now());
                user.setUpdatedAt(LocalDateTime.now());

                boolean created = userService.insertUser(user);
                if (!created) {
//                    ErrDialog.showError("Failed to create user in the database");
                    response.sendRedirect(ProjectPaths.HREF_TO_LOGINPAGE);
                    return;
                }
            }

            HttpSession session = request.getSession();
            session.setAttribute("loggedUser", user);
            session.setAttribute("isLoggedIn", true);
            session.setMaxInactiveInterval(30 * 60);

            response.sendRedirect(ProjectPaths.HREF_TO_HOMEPAGE);

        } catch (Exception e) {
//            ErrDialog.showError("Error during Google login: " + e.getMessage());
            response.sendRedirect(ProjectPaths.HREF_TO_LOGINPAGE);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Handles Google OAuth login and session management";
    }
}
