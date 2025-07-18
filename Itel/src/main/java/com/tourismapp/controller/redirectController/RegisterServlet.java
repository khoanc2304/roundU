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

        // Kiểm tra email đã tồn tại trong DB
        try (Connection conn = DBConnection.getConnection()) {
            String checkEmailSql = "SELECT COUNT(*) FROM Users WHERE email = ?";
            try (PreparedStatement checkEmailStmt = conn.prepareStatement(checkEmailSql)) {
                checkEmailStmt.setString(1, email);
                ResultSet resultSet = checkEmailStmt.executeQuery();
                if (resultSet.next() && resultSet.getInt(1) > 0) {
                    // Nếu email đã tồn tại, trả về thông báo lỗi
                    req.setAttribute("errorMessage", "Email đã được sử dụng, vui lòng chọn email khác.");
                    req.getRequestDispatcher("/WEB-INF/view/pages/registerPage/registerPage.jsp").forward(req, resp);
                    return;
                }
            }

            // Kiểm tra các trường bắt buộc và hợp lệ
            if (username.isEmpty() || password.isEmpty() || fullName.isEmpty() || email.isEmpty() || phone.isEmpty() || address.isEmpty()) {
                req.setAttribute("errorMessage", "Tất cả các trường đều phải được điền đầy đủ.");
                req.getRequestDispatcher("/WEB-INF/view/pages/registerPage/registerPage.jsp").forward(req, resp);
                return;
            }

            // Kiểm tra định dạng email
            if (!isValidEmail(email)) {
                req.setAttribute("errorMessage", "Địa chỉ email không hợp lệ.");
                req.getRequestDispatcher("/WEB-INF/view/pages/registerPage/registerPage.jsp").forward(req, resp);
                return;
            }

            // Nếu mọi thứ hợp lệ, thực hiện insert
            Users newUser = new Users(
                    username,
                    password,
                    fullName,
                    email,
                    phone,
                    address,
                    UserRole.CUSTOMER, // Mặc định
                    MembershipLevel.BRONZE, // Mặc định
                    null, // imageUrl
                    Status.ACTIVE, // Mặc định
                    LocalDateTime.now(), // createdAt
                    LocalDateTime.now() // updatedAt
            );

            String sql = "INSERT INTO Users (username, password, fullName, email, phone, address, role, membership_level_id, image_url, status, created_at, updated_at) "
                    + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, newUser.getUsername());
                ps.setString(2, newUser.getPassword());
                ps.setString(3, newUser.getFullName());
                ps.setString(4, newUser.getEmail());
                ps.setString(5, newUser.getPhone());
                ps.setString(6, newUser.getAddress());
                ps.setString(7, newUser.getRole().getValue());              // customer
                ps.setInt(8, newUser.getMembershipLevel().getId());         // BRONZE (id = 1)
                ps.setString(9, newUser.getImageUrl());                     // null
                ps.setString(10, newUser.getStatus().toString());           // ACTIVE
                ps.setObject(11, newUser.getCreatedAt());
                ps.setObject(12, newUser.getUpdatedAt());

                ps.executeUpdate();

                // Sau khi insert thành công, chuyển đến trang cảm ơn
                req.getRequestDispatcher("/WEB-INF/view/pages/registerPage/thankYouPage.jsp").forward(req, resp);

            }
        } catch (Exception e) {
            // In thông báo lỗi chi tiết để kiểm tra
            e.printStackTrace();

            // Gửi thông báo lỗi chi tiết về JSP
            req.setAttribute("errorMessage", "Đã xảy ra lỗi: " + e.getMessage());
            req.getRequestDispatcher("/WEB-INF/view/pages/registerPage/registerPage.jsp").forward(req, resp);
        }
    }

    private boolean isValidEmail(String email) {
        // Kiểm tra định dạng email hợp lệ bằng regex
        String emailRegex = "^[a-zA-Z0-9_+&*-]+(?:\\.[a-zA-Z0-9_+&*-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,7}$";
        return email.matches(emailRegex);
    }

}
