package com.tourismapp.controller.redirectController;

import com.tourismapp.config.ProjectPaths;
import com.tourismapp.controller.mainController.MainControllerServlet;
import com.tourismapp.model.Users;
import com.tourismapp.service.user.UserService;
import com.tourismapp.utils.ErrDialog;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.regex.Pattern;

@WebServlet(name = "ProfilePageServlet", urlPatterns = {MainControllerServlet.PROFILEPAGE_SERVLET})
public class ProfilePageServlet extends HttpServlet {

    private UserService userService;

    @Override
    public void init() throws ServletException {
        userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Users loggedUser = (Users) session.getAttribute("loggedUser");

        if (loggedUser == null) {
            response.sendRedirect(ProjectPaths.HREF_TO_LOGINPAGE);
            return;
        }

        String action = request.getParameter("action") != null ? request.getParameter("action") : MainControllerServlet.ACTION_VIEW_PROFILE;
//        ErrDialog.showError("ProServlet: " + action);

        switch (action) {
            case MainControllerServlet.ACTION_VIEW_PROFILE:
                request.setAttribute("user", loggedUser);
                request.getRequestDispatcher(ProjectPaths.JSP_PROFILEPAGE_PATH).forward(request, response);
                break;
            case MainControllerServlet.ACTION_EDIT_PROFILE:
                request.setAttribute("user", loggedUser);
                request.getRequestDispatcher(ProjectPaths.JSP_EDIT_PROFILEPAGE_PATH).forward(request, response);
                break;
            case MainControllerServlet.ACTION_CHANGE_PASSWORD:
                request.setAttribute("user", loggedUser);
                request.getRequestDispatcher(ProjectPaths.JSP_CHANGE_PASSWORD_PATH).forward(request, response);
                break;

            default:
                response.sendRedirect("errorAtMainController.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Users loggedUser = (Users) session.getAttribute("loggedUser");

        if (loggedUser == null) {
            response.sendRedirect(ProjectPaths.HREF_TO_LOGINPAGE);
            return;
        }

        String action = request.getParameter("action") != null ? request.getParameter("action") : "";

        if (action.equals(MainControllerServlet.ACTION_UPDATE_PROFILE)) {
            // Lấy dữ liệu từ form
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");

            // Kiểm tra dữ liệu đầu vào
            StringBuilder errorMessage = new StringBuilder();
            if (fullName == null || !Pattern.matches("^[a-zA-ZÀ-ỹ\\s]{2,50}$", fullName.trim())) {
                errorMessage.append("Tên phải từ 2-50 ký tự, chỉ chứa chữ cái và khoảng trắng. ");
            }
            if (email == null || !Pattern.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$", email.trim())) {
                errorMessage.append("Email không hợp lệ. ");
            }
            if (phone == null || !Pattern.matches("^[0-9]{10,11}$", phone.trim())) {
                errorMessage.append("Số điện thoại phải có 10-11 chữ số. ");
            }
            if (address == null || !Pattern.matches("^.{5,200}$", address.trim())) {
                errorMessage.append("Địa chỉ phải từ 5-200 ký tự. ");
            }

            if (errorMessage.length() > 0) {
                request.setAttribute("errorMessage", errorMessage.toString());
                request.setAttribute("user", loggedUser);
                request.getRequestDispatcher(ProjectPaths.JSP_EDIT_PROFILEPAGE_PATH).forward(request, response);
                return;
            }

            // Cập nhật thông tin user
            loggedUser.setFullName(fullName.trim());
            loggedUser.setEmail(email.trim());
            loggedUser.setPhone(phone.trim());
            loggedUser.setAddress(address.trim());

            // Lưu vào DB
            boolean updated = userService.updateUser(loggedUser);
            if (updated) {
                session.setAttribute("loggedUser", loggedUser);
                request.setAttribute("successMessage", "Cập nhật thông tin thành công!");
                request.setAttribute("user", loggedUser);
                request.getRequestDispatcher(ProjectPaths.JSP_EDIT_PROFILEPAGE_PATH).forward(request, response);
            } else {
                request.setAttribute("errorMessage", "Cập nhật thông tin thất bại!");
                request.setAttribute("user", loggedUser);
                request.getRequestDispatcher(ProjectPaths.JSP_EDIT_PROFILEPAGE_PATH).forward(request, response);
            }
        } else {
            response.sendRedirect("errorAtMainController.jsp");
        }
    }
}
