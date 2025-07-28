package com.tourismapp.controller.redirectController;

import com.tourismapp.config.ProjectPaths;
import static com.tourismapp.config.ProjectPaths.JSP_LOGINPAGE_PATH;
import com.tourismapp.controller.mainController.MainControllerServlet;

import com.tourismapp.dao.DBConnection;
import com.tourismapp.model.Users;
import com.tourismapp.utils.ErrDialog;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet(name = "changePasswordServlet", urlPatterns = {MainControllerServlet.CHANGEPASSWORD_SERVLET})
public class ChangePasswordServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
//        ErrDialog.showError("changeServPost");

        req.setCharacterEncoding("UTF-8");

        String currentPassword = req.getParameter("currentPassword");
        String newPassword = req.getParameter("newPassword");
        String confirmPassword = req.getParameter("confirmPassword");

        HttpSession session = req.getSession();
        Users user = (Users) session.getAttribute("loggedUser");

         
        if (user == null) {
            resp.sendRedirect(JSP_LOGINPAGE_PATH);
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {

            // Bước 1: Lấy mật khẩu hiện tại từ database
            String sql = "SELECT password FROM Users WHERE username = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, user.getUsername());
                ResultSet rs = stmt.executeQuery();

                if (rs.next()) {
                    String dbPassword = rs.getString("password");

                    // So sánh mật khẩu hiện tại
                    if (!dbPassword.equals(currentPassword)) {
                        req.setAttribute("errorMessage", "Mật khẩu hiện tại không đúng.");
                        req.getRequestDispatcher("/WEB-INF/view/pages/profilePage/changePasswordPage.jsp").forward(req, resp);
                        return;
                    }
                } else {
                    req.setAttribute("errorMessage", "Tài khoản không tồn tại.");
                    req.getRequestDispatcher("/WEB-INF/view/pages/profilePage/changePasswordPage.jsp").forward(req, resp);
                    return;
                }
            }

            // Bước 2: Kiểm tra mật khẩu mới và xác nhận
            if (!newPassword.equals(confirmPassword)) {
                req.setAttribute("errorMessage", "Mật khẩu mới và xác nhận không khớp.");
                req.getRequestDispatcher("/WEB-INF/view/pages/profilePage/changePasswordPage.jsp").forward(req, resp);
                return;
            }

            // Bước 3: Cập nhật mật khẩu mới vào DB
            String updateSql = "UPDATE Users SET password = ?, updated_at = GETDATE() WHERE username = ?";
            try (PreparedStatement stmt = conn.prepareStatement(updateSql)) {
                stmt.setString(1, newPassword);
                stmt.setString(2, user.getUsername());
                stmt.executeUpdate();
            }

            // Đặt thông báo thành công
            req.setAttribute("successMessage", "Đổi mật khẩu thành công.");
            req.getRequestDispatcher("/WEB-INF/view/pages/profilePage/changePasswordPage.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMessage", "Đã xảy ra lỗi: " + e.getMessage());
            req.getRequestDispatcher("/WEB-INF/view/pages/profilePage/changePasswordPage.jsp").forward(req, resp);
        }
    }

}
