package com.tourismapp.controller.authController;

import com.tourismapp.common.MembershipLevel;
import com.tourismapp.common.Status;
import com.tourismapp.common.UserRole;
import com.tourismapp.config.ProjectPaths;
import com.tourismapp.controller.mainController.MainControllerServlet;
import com.tourismapp.dao.DBConnection;
import com.tourismapp.model.Users;
import com.tourismapp.service.user.IUserService;
import com.tourismapp.service.user.UserService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDateTime;
import java.util.Optional;

import com.tourismapp.constant.GoogleLogin;
import com.tourismapp.model.GoogleAccount;
import com.tourismapp.constant.FacebookLogin;
import com.tourismapp.model.FacebookAccount;
import com.tourismapp.utils.ErrDialog;

@Controller
public class AuthController {

    private final IUserService userService = new UserService();

    @GetMapping(MainControllerServlet.LOGINPAGE_SERVLET)
    public String showLoginPage() {
        return ProjectPaths.JSP_LOGINPAGE_PATH;
    }

    @PostMapping(MainControllerServlet.LOGINPAGE_SERVLET)
    public String handleLogin(@RequestParam("action") String action,
                              @RequestParam("identifier") String identifier,
                              @RequestParam("password") String password,
                              HttpServletRequest request,
                              HttpSession session) {

        if (MainControllerServlet.ACTION_LOGIN.equals(action.trim())) {
            Optional<Users> loggedUser = userService.findUserByCredentials(identifier, password);
            if (loggedUser.isPresent()) {
                Users user = loggedUser.get();
                session.setAttribute("loggedUser", user);
                String role = user.getRole().getValue();
                session.setAttribute("successMessage", "Đăng nhập thành công.");

                return switch (role) {
                    case "admin" -> "redirect:" + ProjectPaths.HREF_TO_DASHBOARDPAGE;
                    case "staff" -> ProjectPaths.JSP_DASHBOARDPAGE_PATH;
                    default -> ProjectPaths.JSP_HOMEPAGE_PATH;
                };
            } else {
                session.setAttribute("errorMessage", "Sai tài khoản hoặc mật khẩu. Vui lòng nhập lại!");
                return "redirect:" + ProjectPaths.HREF_TO_LOGINPAGE;
            }
        } else {
            session.setAttribute("errorMessage", "Lỗi trong quá trình đăng nhập. Đăng nhập thất bại!");
            return "redirect:" + ProjectPaths.HREF_TO_LOGINPAGE;
        }
    }

    @GetMapping(MainControllerServlet.LOGOUTPAGE_SERVLET)
    public String handleLogout(HttpServletRequest request, HttpSession session) {
        if (session != null) {
            session.invalidate();
        }
        return "redirect:" + ProjectPaths.HREF_TO_HOMEPAGE;
    }

    @GetMapping("/registerPage")
    public String showRegisterPage() {
        return ProjectPaths.JSP_REGISTER_PAGE_PATH;
    }

    @PostMapping("/register")
    public String handleRegister(@RequestParam("username") String username,
                                 @RequestParam("password") String password,
                                 @RequestParam("fullName") String fullName,
                                 @RequestParam("email") String email,
                                 @RequestParam("phone") String phone,
                                 @RequestParam("address") String address,
                                 HttpServletRequest req) {

        try {
            req.setCharacterEncoding("UTF-8");
        } catch (Exception ignored) {}

        if (username.isEmpty() || password.isEmpty() || fullName.isEmpty() ||
                email.isEmpty() || phone.isEmpty() || address.isEmpty()) {
            req.setAttribute("errorMessage", "Tất cả các trường đều phải được điền đầy đủ.");
            preserveFormData(req, username, fullName, email, phone, address);
            return ProjectPaths.JSP_REGISTER_PAGE_PATH;
        }

        if (!isValidEmail(email)) {
            req.setAttribute("errorMessage", "Địa chỉ email không hợp lệ.");
            preserveFormData(req, username, fullName, email, phone, address);
            return ProjectPaths.JSP_REGISTER_PAGE_PATH;
        }

        if (!phone.matches("^\\d{10,11}$")) {
            req.setAttribute("errorMessage", "Số điện thoại phải gồm 10 hoặc 11 chữ số.");
            preserveFormData(req, username, fullName, email, phone, address);
            return ProjectPaths.JSP_REGISTER_PAGE_PATH;
        }

        try (Connection conn = DBConnection.getConnection()) {
            String checkUsernameSql = "SELECT COUNT(*) FROM Users WHERE username = ?";
            try (PreparedStatement stmt = conn.prepareStatement(checkUsernameSql)) {
                stmt.setString(1, username);
                ResultSet rs = stmt.executeQuery();
                if (rs.next() && rs.getInt(1) > 0) {
                    req.setAttribute("errorMessage", "Tên đăng nhập đã được sử dụng, vui lòng chọn tên khác.");
                    preserveFormData(req, username, fullName, email, phone, address);
                    return ProjectPaths.JSP_REGISTER_PAGE_PATH;
                }
            }

            String checkPhoneSql = "SELECT COUNT(*) FROM Users WHERE phone = ?";
            try (PreparedStatement stmt = conn.prepareStatement(checkPhoneSql)) {
                stmt.setString(1, phone);
                ResultSet rs = stmt.executeQuery();
                if (rs.next() && rs.getInt(1) > 0) {
                    req.setAttribute("errorMessage", "Số điện thoại đã được sử dụng, vui lòng dùng số khác.");
                    preserveFormData(req, username, fullName, email, phone, address);
                    return ProjectPaths.JSP_REGISTER_PAGE_PATH;
                }
            }

            String checkEmailSql = "SELECT COUNT(*) FROM Users WHERE email = ?";
            try (PreparedStatement stmt = conn.prepareStatement(checkEmailSql)) {
                stmt.setString(1, email);
                ResultSet rs = stmt.executeQuery();
                if (rs.next() && rs.getInt(1) > 0) {
                    req.setAttribute("errorMessage", "Email đã được sử dụng, vui lòng chọn email khác.");
                    preserveFormData(req, username, fullName, email, phone, address);
                    return ProjectPaths.JSP_REGISTER_PAGE_PATH;
                }
            }

            Users newUser = new Users(
                    username, password, fullName, email, phone, address,
                    UserRole.CUSTOMER, MembershipLevel.STANDARD, null, Status.ACTIVE,
                    LocalDateTime.now(), LocalDateTime.now()
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
                ps.setString(7, newUser.getRole().getValue());
                ps.setInt(8, newUser.getMembershipLevel().getId());
                ps.setString(9, newUser.getImageUrl());
                ps.setString(10, newUser.getStatus().toString());
                ps.setObject(11, newUser.getCreatedAt());
                ps.setObject(12, newUser.getUpdatedAt());

                ps.executeUpdate();
                return ProjectPaths.JSP_REGISTER_THANKYOU_PATH;
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMessage", "Đã xảy ra lỗi: " + e.getMessage());
            preserveFormData(req, username, fullName, email, phone, address);
            return ProjectPaths.JSP_REGISTER_PAGE_PATH;
        }
    }

    private boolean isValidEmail(String email) {
        String emailRegex = "^[a-zA-Z0-9_+&*-]+(?:\\.[a-zA-Z0-9_+&*-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,7}$";
        return email.matches(emailRegex);
    }

    private void preserveFormData(HttpServletRequest req, String username, String fullName, String email, String phone, String address) {
        req.setAttribute("username", username);
        req.setAttribute("fullName", fullName);
        req.setAttribute("email", email);
        req.setAttribute("phone", phone);
        req.setAttribute("address", address);
    }

    @GetMapping("/loginGoogle")
    public String loginGoogle(@RequestParam(value = "code", required = false) String code, HttpSession session) {
        try {
            if (code == null || code.isEmpty()) {
                return "redirect:" + ProjectPaths.HREF_TO_LOGINPAGE;
            }

            String accessToken = GoogleLogin.getToken(code);
            if (accessToken == null) {
                return "redirect:" + ProjectPaths.HREF_TO_LOGINPAGE;
            }

            GoogleAccount googleAccount = GoogleLogin.getUserInfo(accessToken);
            if (googleAccount == null) {
                return "redirect:" + ProjectPaths.HREF_TO_LOGINPAGE;
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
                    return "redirect:" + ProjectPaths.HREF_TO_LOGINPAGE;
                }
            }

            session.setAttribute("loggedUser", user);
            session.setAttribute("isLoggedIn", true);
            session.setMaxInactiveInterval(30 * 60);

            return "redirect:" + ProjectPaths.HREF_TO_HOMEPAGE;

        } catch (Exception e) {
            return "redirect:" + ProjectPaths.HREF_TO_LOGINPAGE;
        }
    }

    @GetMapping("/loginFacebook")
    public String loginFacebook(@RequestParam(value = "code", required = false) String code) {
        try {
            if (code != null) {
                String accessToken = FacebookLogin.getToken(code);
                ErrDialog.showError("accessToken: " + accessToken);
                FacebookAccount acc = FacebookLogin.getUserInfo(accessToken);
                ErrDialog.showError("acc: " + acc);
            }
        } catch (Exception ignored) {}
        return "redirect:" + ProjectPaths.HREF_TO_LOGINPAGE; // Fallback since facebook login logic was just incomplete stub in Servlet
    }
}
