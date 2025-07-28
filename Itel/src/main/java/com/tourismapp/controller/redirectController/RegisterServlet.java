package com.tourismapp.controller.redirectController;

import com.tourismapp.model.Users;
import com.tourismapp.common.UserRole;
import com.tourismapp.common.MembershipLevel;
import com.tourismapp.common.Status;
import com.tourismapp.dao.DBConnection;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.ServletException;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDateTime;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String fullName = req.getParameter("fullName");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");
        String address = req.getParameter("address");

        // Kiểm tra các trường bắt buộc
        if (username.isEmpty() || password.isEmpty() || fullName.isEmpty() ||
                email.isEmpty() || phone.isEmpty() || address.isEmpty()) {
            req.setAttribute("errorMessage", "Tất cả các trường đều phải được điền đầy đủ.");
            preserveFormData(req, username, fullName, email, phone, address);
            req.getRequestDispatcher("/WEB-INF/view/pages/registerPage/registerPage.jsp").forward(req, resp);
            return;
        }

        // Kiểm tra định dạng email
        if (!isValidEmail(email)) {
            req.setAttribute("errorMessage", "Địa chỉ email không hợp lệ.");
            preserveFormData(req, username, fullName, email, phone, address);
            req.getRequestDispatcher("/WEB-INF/view/pages/registerPage/registerPage.jsp").forward(req, resp);
            return;
        }

        // Kiểm tra định dạng số điện thoại (10-11 số và chỉ là số)
        if (!phone.matches("^\\d{10,11}$")) {
            req.setAttribute("errorMessage", "Số điện thoại phải gồm 10 hoặc 11 chữ số.");
            preserveFormData(req, username, fullName, email, phone, address);
            req.getRequestDispatcher("/WEB-INF/view/pages/registerPage/registerPage.jsp").forward(req, resp);
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {

            // Kiểm tra trùng username
            String checkUsernameSql = "SELECT COUNT(*) FROM Users WHERE username = ?";
            try (PreparedStatement stmt = conn.prepareStatement(checkUsernameSql)) {
                stmt.setString(1, username);
                ResultSet rs = stmt.executeQuery();
                if (rs.next() && rs.getInt(1) > 0) {
                    req.setAttribute("errorMessage", "Tên đăng nhập đã được sử dụng, vui lòng chọn tên khác.");
                    preserveFormData(req, username, fullName, email, phone, address);
                    req.getRequestDispatcher("/WEB-INF/view/pages/registerPage/registerPage.jsp").forward(req, resp);
                    return;
                }
            }

            // Kiểm tra trùng số điện thoại
            String checkPhoneSql = "SELECT COUNT(*) FROM Users WHERE phone = ?";
            try (PreparedStatement stmt = conn.prepareStatement(checkPhoneSql)) {
                stmt.setString(1, phone);
                ResultSet rs = stmt.executeQuery();
                if (rs.next() && rs.getInt(1) > 0) {
                    req.setAttribute("errorMessage", "Số điện thoại đã được sử dụng, vui lòng dùng số khác.");
                    preserveFormData(req, username, fullName, email, phone, address);
                    req.getRequestDispatcher("/WEB-INF/view/pages/registerPage/registerPage.jsp").forward(req, resp);
                    return;
                }
            }

            // Kiểm tra trùng email
            String checkEmailSql = "SELECT COUNT(*) FROM Users WHERE email = ?";
            try (PreparedStatement stmt = conn.prepareStatement(checkEmailSql)) {
                stmt.setString(1, email);
                ResultSet rs = stmt.executeQuery();
                if (rs.next() && rs.getInt(1) > 0) {
                    req.setAttribute("errorMessage", "Email đã được sử dụng, vui lòng chọn email khác.");
                    preserveFormData(req, username, fullName, email, phone, address);
                    req.getRequestDispatcher("/WEB-INF/view/pages/registerPage/registerPage.jsp").forward(req, resp);
                    return;
                }
            }

            // Nếu hợp lệ, tạo user mới
            Users newUser = new Users(
                    username,
                    password,
                    fullName,
                    email,
                    phone,
                    address,
                    UserRole.CUSTOMER,
                    MembershipLevel.STANDARD,
                    null,
                    Status.ACTIVE,
                    LocalDateTime.now(),
                    LocalDateTime.now()
            );

            // Insert vào CSDL
            String sql = "INSERT INTO Users (username, password, fullName, email, phone, address, role, membership_level_id, image_url, status, created_at, updated_at) "
                    + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, newUser.getUsername());
                ps.setString(2, newUser.getPassword());
                ps.setString(3, newUser.getFullName());
                ps.setString(4, newUser.getEmail());
                ps.setString(5, newUser.getPhone());
                ps.setString(6, newUser.getAddress());
                ps.setString(7, newUser.getRole().getValue());
                ps.setInt(8, newUser.getMembershipLevel().getId());
                ps.setString(9, newUser.getImageUrl());
                ps.setString(10, newUser.getStatus().toString());
                ps.setObject(11, newUser.getCreatedAt());
                ps.setObject(12, newUser.getUpdatedAt());

                ps.executeUpdate();

                // Thành công
                req.getRequestDispatcher("/WEB-INF/view/pages/registerPage/thankYouPage.jsp").forward(req, resp);
            }

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMessage", "Đã xảy ra lỗi: " + e.getMessage());
            preserveFormData(req, username, fullName, email, phone, address);
            req.getRequestDispatcher("/WEB-INF/view/pages/registerPage/registerPage.jsp").forward(req, resp);
        }
    }

    private boolean isValidEmail(String email) {
        String emailRegex = "^[a-zA-Z0-9_+&*-]+(?:\\.[a-zA-Z0-9_+&*-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,7}$";
        return email.matches(emailRegex);
    }

    // Hàm phụ để set lại các giá trị nhập đúng
    private void preserveFormData(HttpServletRequest req, String username, String fullName, String email, String phone, String address) {
        req.setAttribute("username", username);
        req.setAttribute("fullName", fullName);
        req.setAttribute("email", email);
        req.setAttribute("phone", phone);
        req.setAttribute("address", address);
    }
}
