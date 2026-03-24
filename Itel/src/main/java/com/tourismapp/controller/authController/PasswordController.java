package com.tourismapp.controller.authController;

import com.tourismapp.config.ProjectPaths;
import com.tourismapp.controller.mainController.MainControllerServlet;
import com.tourismapp.repository.DBConnection;
import com.tourismapp.model.Users;
import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Properties;
import java.util.UUID;

@Controller
public class PasswordController {

    private static final String FROM_EMAIL = "nteo9820@gmail.com";
    private static final String PASSWORD = "cjxy fpgh ivyd emrk";

    // --- Forgot Password logic ---
    @GetMapping(MainControllerServlet.FORGOTPASSWORD_SERVLET)
    public String showForgotPasswordPage() {
        return "/WEB-INF/view/pages/forgotPasswordPage/forgotPasswordPage.jsp";
    }

    @PostMapping(MainControllerServlet.FORGOTPASSWORD_SERVLET)
    public String handleForgotPasswordPost(@RequestParam(value = "action", required = false, defaultValue = "") String action,
                                           HttpServletRequest request, HttpServletResponse response) {
        String act = action.trim();
        switch (act) {
            case MainControllerServlet.ACTION_FORGOT_PASSWORD:
                return handleForgotPassword(request);
            case "verifyOtp":
                return handleVerifyOtp(request);
            case "resetPassword":
                return handleResetPassword(request);
            default:
                return "redirect:errorPage.jsp";
        }
    }

    private String handleForgotPassword(HttpServletRequest request) {
        String email = request.getParameter("email");
        try (Connection conn = DBConnection.getConnection()) {
            String checkEmailSql = "SELECT * FROM Users WHERE email = ?";
            try (PreparedStatement ps = conn.prepareStatement(checkEmailSql)) {
                ps.setString(1, email);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    String otp = generateOtp();
                    sendOtpEmail(email, "Reset Password OTP", "Mã OTP của bạn là: " + otp);
                    request.getSession().setAttribute("otp", otp);
                    request.getSession().setAttribute("email", email);
                    request.setAttribute("successMessage", "Đã gửi OTP vào email của bạn.");
                    return "/WEB-INF/view/pages/forgotPasswordPage/otpPage.jsp";
                } else {
                    request.setAttribute("errorMessage", "Email không tồn tại.");
                    return "/WEB-INF/view/pages/forgotPasswordPage/forgotPasswordPage.jsp";
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Đã xảy ra lỗi, vui lòng thử lại sau.");
            return "/WEB-INF/view/pages/forgotPasswordPage/forgotPasswordPage.jsp";
        }
    }

    private String handleVerifyOtp(HttpServletRequest request) {
        String otpEntered = request.getParameter("otp");
        String otpStored = (String) request.getSession().getAttribute("otp");
        if (otpStored == null) {
            request.setAttribute("errorMessage", "Mã OTP đã hết hạn hoặc không hợp lệ.");
            return "/WEB-INF/view/pages/forgotPasswordPage/otpPage.jsp";
        }
        if (otpEntered.equals(otpStored)) {
            return "/WEB-INF/view/pages/forgotPasswordPage/resetPasswordPage.jsp";
        } else {
            request.setAttribute("errorMessage", "OTP không đúng.");
            return "/WEB-INF/view/pages/forgotPasswordPage/otpPage.jsp";
        }
    }

    private String handleResetPassword(HttpServletRequest request) {
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("email");
        if (email == null) {
            return "redirect:/WEB-INF/view/pages/forgotPasswordPage/forgotPasswordPage.jsp";
        }
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        if (newPassword == null || confirmPassword == null || newPassword.isEmpty() || confirmPassword.isEmpty()) {
            request.setAttribute("message", "❌ Mật khẩu không được để trống!");
            return "/WEB-INF/view/pages/forgotPasswordPage/resetPasswordPage.jsp";
        }
        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("message", "❌ Mật khẩu không khớp!");
            return "/WEB-INF/view/pages/forgotPasswordPage/resetPasswordPage.jsp";
        }
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "UPDATE Users SET password = ? WHERE email = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, newPassword);
            stmt.setString(2, email);
            int updated = stmt.executeUpdate();
            if (updated > 0) {
                session.removeAttribute("email");
                return "redirect:/WEB-INF/view/pages/loginPage/loginPage.jsp";
            } else {
                request.setAttribute("message", "❌ Không tìm thấy tài khoản với email này.");
                return "/WEB-INF/view/pages/forgotPasswordPage/resetPasswordPage.jsp";
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "❌ Lỗi hệ thống khi thay đổi mật khẩu.");
            return "reset-password.jsp";
        }
    }

    private String generateOtp() {
        return UUID.randomUUID().toString().substring(0, 6);
    }

    private boolean sendOtpEmail(String toEmail, String subject, String message) {
        try {
            Properties props = new Properties();
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.host", "smtp.gmail.com");
            props.put("mail.smtp.port", "587");
            Session session = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(FROM_EMAIL, PASSWORD);
                }
            });
            Message msg = new MimeMessage(session);
            msg.setFrom(new InternetAddress(FROM_EMAIL));
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            msg.setSubject(subject);
            msg.setText(message);
            Transport.send(msg);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // --- Reset Password Servlet logic (redundant but keeping for mapping) ---
    @PostMapping("/ResetPasswordServlet")
    public String handleResetPasswordServlet(HttpServletRequest request, HttpSession session) {
        String email = (String) session.getAttribute("email");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        if (email == null) {
            return "redirect:/WEB-INF/view/pages/forgotPasswordPage/resetPasswordPage.jsp";
        }
        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("message", "❌ Mật khẩu không khớp!");
            return "/WEB-INF/view/pages/forgotPasswordPage/resetPasswordPage.jsp";
        }
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "UPDATE Users SET password = ? WHERE email = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, newPassword);
            stmt.setString(2, email);
            int updated = stmt.executeUpdate();
            if (updated > 0) {
                session.removeAttribute("email");
                return "/WEB-INF/view/pages/loginPage/loginPage.jsp";
            } else {
                request.setAttribute("message", "❌ Lỗi cập nhật mật khẩu!");
                return "/WEB-INF/view/pages/forgotPasswordPage/resetPasswordPage.jsp";
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "❌ Lỗi hệ thống!");
            return "/WEB-INF/view/pages/forgotPasswordPage/resetPasswordPage.jsp";
        }
    }

    // --- Change Password logic ---
    @PostMapping(MainControllerServlet.CHANGEPASSWORD_SERVLET)
    public String handleChangePassword(@RequestParam("currentPassword") String currentPassword,
                                       @RequestParam("newPassword") String newPassword,
                                       @RequestParam("confirmPassword") String confirmPassword,
                                       HttpServletRequest request, HttpSession session) {
        try {
            request.setCharacterEncoding("UTF-8");
        } catch (Exception ignored) {}

        Users user = (Users) session.getAttribute("loggedUser");
        if (user == null) {
            return "redirect:" + ProjectPaths.JSP_LOGINPAGE_PATH;
        }

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT password FROM Users WHERE username = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, user.getUsername());
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    String dbPassword = rs.getString("password");
                    if (!dbPassword.equals(currentPassword)) {
                        request.setAttribute("errorMessage", "Mật khẩu hiện tại không đúng.");
                        return "/WEB-INF/view/pages/profilePage/changePasswordPage.jsp";
                    }
                } else {
                    request.setAttribute("errorMessage", "Tài khoản không tồn tại.");
                    return "/WEB-INF/view/pages/profilePage/changePasswordPage.jsp";
                }
            }

            if (!newPassword.equals(confirmPassword)) {
                request.setAttribute("errorMessage", "Mật khẩu mới và xác nhận không khớp.");
                return "/WEB-INF/view/pages/profilePage/changePasswordPage.jsp";
            }

            // Using standard SQL GETDATE() is SQL Server specific, maybe we should use java.sql.Timestamp for MySQL or SQLServer?
            // The original used GETDATE() which means it's SQL Server.
            String updateSql = "UPDATE Users SET password = ?, updated_at = GETDATE() WHERE username = ?";
            try (PreparedStatement stmt = conn.prepareStatement(updateSql)) {
                stmt.setString(1, newPassword);
                stmt.setString(2, user.getUsername());
                stmt.executeUpdate();
            }

            request.setAttribute("successMessage", "Đổi mật khẩu thành công.");
            return "/WEB-INF/view/pages/profilePage/changePasswordPage.jsp";

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Đã xảy ra lỗi: " + e.getMessage());
            return "/WEB-INF/view/pages/profilePage/changePasswordPage.jsp";
        }
    }
}
