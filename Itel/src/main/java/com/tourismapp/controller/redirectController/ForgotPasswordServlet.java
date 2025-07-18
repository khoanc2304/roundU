package com.tourismapp.controller.redirectController;

import com.tourismapp.controller.mainController.MainControllerServlet;
import static com.tourismapp.controller.mainController.MainControllerServlet.ACTION_FORGOT_PASSWORD;
import com.tourismapp.dao.DBConnection;
import com.tourismapp.utils.ErrDialog;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.ServletException;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.UUID;
import jakarta.mail.*;
import jakarta.mail.internet.*;
import java.util.Properties;
import org.mindrot.jbcrypt.BCrypt;

@WebServlet(name = "ForgotPasswordServlet", urlPatterns = {MainControllerServlet.FORGOTPASSWORD_SERVLET})
public class ForgotPasswordServlet extends HttpServlet {

    private static final String FROM_EMAIL = "huyhntde180836@fpt.edu.vn"; // Thay bằng email của bạn
    private static final String PASSWORD = "pyhg btpo uppz mibh";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String action = request.getParameter("action");
//        ErrDialog.showError("ForGotServlet doGet: " + action);
        // Forward tới trang quên mật khẩu
        request.getRequestDispatcher("/WEB-INF/view/pages/forgotPasswordPage/forgotPasswordPage.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action") != null ? request.getParameter("action").trim() : "";
        ErrDialog.showError("ForgotServlet doPost: " + action);
        switch (action) {
            case ACTION_FORGOT_PASSWORD:
                handleForgotPassword(request, response);
                break;
            case "verifyOtp":
                handleVerifyOtp(request, response);
                break;
            case "resetPassword":
                handleResetPassword(request, response);
                break;
            default:
                // Kiểm tra lỗi và điều hướng khi action không hợp lệ
                response.sendRedirect("errorPage.jsp"); // Chuyển hướng đến trang lỗi
                return;  // Dừng lại ở đây và không tiếp tục xử lý sau đó
        }
    }

    private void handleForgotPassword(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");

        // Kiểm tra xem email có tồn tại trong CSDL hay không
        try (Connection conn = DBConnection.getConnection()) {
            String checkEmailSql = "SELECT * FROM Users WHERE email = ?";
            try (PreparedStatement ps = conn.prepareStatement(checkEmailSql)) {
                ps.setString(1, email);
                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
                    // Email đã tồn tại, tạo OTP và gửi email
                    String otp = generateOtp(); // Tạo OTP
                    sendOtpEmail(email, "Reset Password OTP", "Mã OTP của bạn là: " + otp);   // Gửi OTP qua email

                    // Lưu OTP vào session để sử dụng sau này khi xác thực
                    request.getSession().setAttribute("otp", otp);  // Lưu OTP vào session
                    request.getSession().setAttribute("email", email);  // Lưu email vào session

                    // Hiển thị thông báo thành công
                    request.setAttribute("successMessage", "Đã gửi OTP vào email của bạn.");
                    request.getRequestDispatcher("/WEB-INF/view/pages/forgotPasswordPage/otpPage.jsp").forward(request, response);
                } else {
                    // Email không tồn tại
                    request.setAttribute("errorMessage", "Email không tồn tại.");
                    request.getRequestDispatcher("/WEB-INF/view/pages/forgotPasswordPage/forgotPasswordPage.jsp").forward(request, response);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Đã xảy ra lỗi, vui lòng thử lại sau.");
            request.getRequestDispatcher("/WEB-INF/view/pages/forgotPasswordPage/forgotPasswordPage.jsp").forward(request, response);
        }
    }

    // Tạo OTP ngẫu nhiên
    private String generateOtp() {
        return UUID.randomUUID().toString().substring(0, 6);  // Tạo OTP dài 6 ký tự
    }

    // Gửi OTP qua email (Jakarta Mail)
    public static boolean sendOtpEmail(String toEmail, String subject, String message) {
        try {
            // Cấu hình properties cho email
            Properties props = new Properties();
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.host", "smtp.gmail.com");
            props.put("mail.smtp.port", "587");

            // Tạo session
            Session session = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(FROM_EMAIL, PASSWORD);
                }
            });

            // Tạo email
            Message msg = new MimeMessage(session);
            msg.setFrom(new InternetAddress(FROM_EMAIL));
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            msg.setSubject(subject);
            msg.setText(message);

            // Gửi email
            Transport.send(msg);
            return true; // Gửi thành công
        } catch (Exception e) {
            e.printStackTrace();
            return false; // Gửi thất bại
        }
    }

    private void handleVerifyOtp(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String otpEntered = request.getParameter("otp");  // OTP người dùng nhập vào
        String email = request.getParameter("email");

        // Lấy OTP đã lưu trong session (hoặc cookie) khi gửi email
        String otpStored = (String) request.getSession().getAttribute("otp");  // OTP lưu trong session

        if (otpStored == null) {
            // Nếu không tìm thấy OTP trong session, báo lỗi
            request.setAttribute("errorMessage", "Mã OTP đã hết hạn hoặc không hợp lệ.");
            request.getRequestDispatcher("/WEB-INF/view/pages/forgotPasswordPage/otpPage.jsp").forward(request, response);
            return;
        }

        if (otpEntered.equals(otpStored)) {
            // Nếu OTP đúng, chuyển đến trang thay đổi mật khẩu
            ErrDialog.showError("Đúng otp");
            request.getRequestDispatcher("/WEB-INF/view/pages/forgotPasswordPage/resetPasswordPage.jsp").forward(request, response);
        } else {
            // Nếu OTP sai, hiển thị lỗi
            ErrDialog.showError("Sai otp");
            request.setAttribute("errorMessage", "OTP không đúng.");
            request.getRequestDispatcher("/WEB-INF/view/pages/forgotPasswordPage/otpPage.jsp").forward(request, response);
        }
    }

    private void handleResetPassword(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Lấy email từ session
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("email");  // Email người dùng từ session

        // Nếu email không tồn tại trong session, chuyển hướng đến trang quên mật khẩu
        if (email == null) {
            response.sendRedirect("/WEB-INF/view/pages/forgotPasswordPage/forgotPasswordPage.jsp");
            return;
        }

        // Lấy mật khẩu mới và xác nhận mật khẩu từ form
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // Kiểm tra tính hợp lệ của mật khẩu mới và xác nhận mật khẩu
        if (newPassword == null || confirmPassword == null || newPassword.isEmpty() || confirmPassword.isEmpty()) {
            request.setAttribute("message", "❌ Mật khẩu không được để trống!");
            request.getRequestDispatcher("/WEB-INF/view/pages/forgotPasswordPage/resetPasswordPage.jsp").forward(request, response);
            return;
        }

        // Kiểm tra xem mật khẩu xác nhận có khớp với mật khẩu mới không
        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("message", "❌ Mật khẩu không khớp!");
            request.getRequestDispatcher("/WEB-INF/view/pages/forgotPasswordPage/resetPasswordPage.jsp").forward(request, response);
            return;
        }

        // Cập nhật mật khẩu trong cơ sở dữ liệu
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "UPDATE Users SET password = ? WHERE email = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, newPassword);  // Lưu mật khẩu mới (không mã hóa)
            stmt.setString(2, email);  // Lưu email vào điều kiện cập nhật

            int updated = stmt.executeUpdate();  // Cập nhật mật khẩu trong CSDL

            // Kiểm tra nếu cập nhật thành công
            if (updated > 0) {
                // Mật khẩu đã được cập nhật thành công
                session.removeAttribute("email");  // Xóa email khỏi session
                response.sendRedirect("/WEB-INF/view/pages/loginPage/loginPage.jsp");  // Chuyển hướng đến trang đăng nhập
            } else {
                // Không tìm thấy email trong cơ sở dữ liệu
                request.setAttribute("message", "❌ Không tìm thấy tài khoản với email này.");
                request.getRequestDispatcher("/WEB-INF/view/pages/forgotPasswordPage/resetPasswordPage.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "❌ Lỗi hệ thống khi thay đổi mật khẩu.");
            request.getRequestDispatcher("reset-password.jsp").forward(request, response);
        }
    }

}
