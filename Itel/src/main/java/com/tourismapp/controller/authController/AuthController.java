package com.tourismapp.controller.authController;

import com.tourismapp.common.MembershipLevel;
import com.tourismapp.common.Status;
import com.tourismapp.common.UserRole;
import com.tourismapp.config.ProjectPaths;
import com.tourismapp.entity.Users;
import com.tourismapp.service.user.IUserService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ModelAttribute;
import jakarta.validation.Valid;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import com.tourismapp.dto.RegisterRequest;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletResponse;
import com.tourismapp.utils.JwtTokenProvider;
import java.time.LocalDateTime;
import java.util.Optional;

import com.tourismapp.constant.GoogleLogin;
import com.tourismapp.entity.GoogleAccount;
import com.tourismapp.constant.FacebookLogin;
import com.tourismapp.entity.FacebookAccount;
import com.tourismapp.utils.ErrDialog;

@Controller
public class AuthController {

    @Autowired
    private IUserService userService;

    @Autowired
    private JwtTokenProvider jwtTokenProvider;

    @GetMapping("/loginPage")
    public String showLoginPage() {
        return ProjectPaths.JSP_LOGINPAGE_PATH;
    }

    @PostMapping("/loginPage")
    public String handleLogin(@RequestParam("action") String action,
            @RequestParam("identifier") String identifier,
            @RequestParam("password") String password,
            HttpServletRequest request,
            HttpServletResponse response,
            HttpSession session) {

        if ("login".equals(action.trim())) {
            Optional<Users> loggedUser = userService.findUserByCredentials(identifier, password);
            if (loggedUser.isPresent()) {
                Users user = loggedUser.get();

                // Issue JWT via HttpOnly Cookie instead of persisting user to session
                String jwt = jwtTokenProvider.generateToken(user);
                Cookie jwtCookie = new Cookie("JWT_TOKEN", jwt);
                jwtCookie.setHttpOnly(true);
                jwtCookie.setPath("/");
                jwtCookie.setMaxAge(24 * 60 * 60); // 24 hours
                response.addCookie(jwtCookie);

                String role = user.getRole().getValue();
                session.setAttribute("successMessage", "Đăng nhập thành công.");

                return switch (role) {
                    case "admin" -> "redirect:"
                            + ProjectPaths.HREF_TO_DASHBOARDPAGE.substring(ProjectPaths.PREFIX_WEB_PATH.length());
                    case "staff" -> "redirect:"
                            + ProjectPaths.HREF_TO_DASHBOARDPAGE.substring(ProjectPaths.PREFIX_WEB_PATH.length());
                    default -> ProjectPaths.JSP_HOMEPAGE_PATH;
                };
            } else {
                session.setAttribute("errorMessage", "Sai tài khoản hoặc mật khẩu. Vui lòng nhập lại!");
                return "redirect:" + ProjectPaths.HREF_TO_LOGINPAGE.substring(ProjectPaths.PREFIX_WEB_PATH.length());
            }
        } else {
            session.setAttribute("errorMessage", "Lỗi trong quá trình đăng nhập. Đăng nhập thất bại!");
            return "redirect:" + ProjectPaths.HREF_TO_LOGINPAGE.substring(ProjectPaths.PREFIX_WEB_PATH.length());
        }
    }

    @GetMapping("/logoutPage")
    public String handleLogout(HttpServletRequest request, HttpServletResponse response, HttpSession session) {
        if (session != null) {
            session.invalidate();
        }
        // Destroy JWT Cookie
        Cookie jwtCookie = new Cookie("JWT_TOKEN", "");
        jwtCookie.setHttpOnly(true);
        jwtCookie.setPath("/");
        jwtCookie.setMaxAge(0); // Tell browser to delete immediately
        response.addCookie(jwtCookie);

        return "redirect:" + ProjectPaths.HREF_TO_HOMEPAGE.substring(ProjectPaths.PREFIX_WEB_PATH.length());
    }

    @GetMapping("/registerPage")
    public String showRegisterPage() {
        return ProjectPaths.JSP_REGISTER_PAGE_PATH;
    }

    @PostMapping("/register")
    public String handleRegister(@Valid @ModelAttribute("registerReq") RegisterRequest reqDto,
            BindingResult bindingResult,
            HttpServletRequest req) {

        try {
            req.setCharacterEncoding("UTF-8");
        } catch (Exception ignored) {
        }

        if (bindingResult.hasErrors()) {
            FieldError firstError = bindingResult.getFieldErrors().get(0);
            req.setAttribute("errorMessage", firstError.getDefaultMessage());
            preserveFormData(req, reqDto.getUsername(), reqDto.getFullName(), reqDto.getEmail(), reqDto.getPhone(),
                    reqDto.getAddress());
            return ProjectPaths.JSP_REGISTER_PAGE_PATH;
        }

        String username = reqDto.getUsername();
        String password = reqDto.getPassword();
        String fullName = reqDto.getFullName();
        String email = reqDto.getEmail();
        String phone = reqDto.getPhone();
        String address = reqDto.getAddress();

        try {
            if (userService.isUsernameExists(username)) {
                req.setAttribute("errorMessage", "Tên đăng nhập đã được sử dụng, vui lòng chọn tên khác.");
                preserveFormData(req, username, fullName, email, phone, address);
                return ProjectPaths.JSP_REGISTER_PAGE_PATH;
            }

            if (userService.isPhoneExists(phone)) {
                req.setAttribute("errorMessage", "Số điện thoại đã được sử dụng, vui lòng dùng số khác.");
                preserveFormData(req, username, fullName, email, phone, address);
                return ProjectPaths.JSP_REGISTER_PAGE_PATH;
            }

            if (userService.isEmailExists(email)) {
                req.setAttribute("errorMessage", "Email đã được sử dụng, vui lòng chọn email khác.");
                preserveFormData(req, username, fullName, email, phone, address);
                return ProjectPaths.JSP_REGISTER_PAGE_PATH;
            }

            Users newUser = new Users(
                    username, password, fullName, email, phone, address,
                    UserRole.CUSTOMER, MembershipLevel.STANDARD, null, Status.ACTIVE,
                    LocalDateTime.now(), LocalDateTime.now());

            boolean created = userService.insertUser(newUser);
            if (created) {
                return ProjectPaths.JSP_REGISTER_THANKYOU_PATH;
            } else {
                req.setAttribute("errorMessage", "Lỗi tạo tài khoản. Vui lòng thử lại.");
                preserveFormData(req, username, fullName, email, phone, address);
                return ProjectPaths.JSP_REGISTER_PAGE_PATH;
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMessage", "Đã xảy ra lỗi: " + e.getMessage());
            preserveFormData(req, username, fullName, email, phone, address);
            return ProjectPaths.JSP_REGISTER_PAGE_PATH;
        }
    }

    private void preserveFormData(HttpServletRequest req, String username, String fullName, String email, String phone,
            String address) {
        req.setAttribute("username", username);
        req.setAttribute("fullName", fullName);
        req.setAttribute("email", email);
        req.setAttribute("phone", phone);
        req.setAttribute("address", address);
    }

    @GetMapping("/loginGoogle")
    public String loginGoogle(@RequestParam(value = "code", required = false) String code, HttpServletResponse response,
            HttpSession session) {
        try {
            if (code == null || code.isEmpty()) {
            }

            String accessToken = GoogleLogin.getToken(code);
            if (accessToken == null) {
                return "redirect:" + ProjectPaths.HREF_TO_LOGINPAGE.substring(ProjectPaths.PREFIX_WEB_PATH.length());
            }

            GoogleAccount googleAccount = GoogleLogin.getUserInfo(accessToken);
            if (googleAccount == null) {
                return "redirect:" + ProjectPaths.HREF_TO_LOGINPAGE.substring(ProjectPaths.PREFIX_WEB_PATH.length());
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
                    return "redirect:"
                            + ProjectPaths.HREF_TO_LOGINPAGE.substring(ProjectPaths.PREFIX_WEB_PATH.length());
                }
            }

            // Issue JWT via Cookie
            String jwt = jwtTokenProvider.generateToken(user);
            Cookie jwtCookie = new Cookie("JWT_TOKEN", jwt);
            jwtCookie.setHttpOnly(true);
            jwtCookie.setPath("/");
            jwtCookie.setMaxAge(24 * 60 * 60);
            response.addCookie(jwtCookie);

            session.setAttribute("isLoggedIn", true);
            session.setMaxInactiveInterval(30 * 60);

            return "redirect:" + ProjectPaths.HREF_TO_HOMEPAGE.substring(ProjectPaths.PREFIX_WEB_PATH.length());

        } catch (Exception e) {
            return "redirect:" + ProjectPaths.HREF_TO_LOGINPAGE.substring(ProjectPaths.PREFIX_WEB_PATH.length());
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
        } catch (Exception ignored) {
        }
        return "redirect:" + ProjectPaths.HREF_TO_LOGINPAGE.substring(ProjectPaths.PREFIX_WEB_PATH.length()); // Fallback
                                                                                                              // since
                                                                                                              // facebook
                                                                                                              // login
                                                                                                              // logic
                                                                                                              // was
                                                                                                              // just
                                                                                                              // incomplete
        // stub in Servlet
    }
}
