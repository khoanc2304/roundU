package com.tourismapp.controller.userController;

import com.tourismapp.config.ProjectPaths;
import com.tourismapp.controller.mainController.MainControllerServlet;
import com.tourismapp.model.Users;
import com.tourismapp.service.user.IUserService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestParam;

import java.io.IOException;
import java.util.regex.Pattern;

@Controller
public class ProfileController {

    @Autowired
    private IUserService userService;

    @GetMapping(MainControllerServlet.PROFILEPAGE_SERVLET)
    public String handleGetProfile(@RequestParam(value = "action", required = false, defaultValue = MainControllerServlet.ACTION_VIEW_PROFILE) String action,
                                   HttpServletRequest request, HttpSession session) {
        Users loggedUser = (Users) session.getAttribute("loggedUser");

        if (loggedUser == null) {
            return "redirect:" + ProjectPaths.HREF_TO_LOGINPAGE;
        }

        switch (action) {
            case MainControllerServlet.ACTION_VIEW_PROFILE:
                request.setAttribute("user", loggedUser);
                return ProjectPaths.JSP_PROFILEPAGE_PATH;
            case MainControllerServlet.ACTION_EDIT_PROFILE:
                request.setAttribute("user", loggedUser);
                return ProjectPaths.JSP_EDIT_PROFILEPAGE_PATH;
            case MainControllerServlet.ACTION_CHANGE_PASSWORD:
                request.setAttribute("user", loggedUser);
                return ProjectPaths.JSP_CHANGE_PASSWORD_PATH;
            default:
                return "redirect:errorAtMainController.jsp";
        }
    }

    @PostMapping(MainControllerServlet.PROFILEPAGE_SERVLET)
    public String handlePostProfile(@RequestParam(value = "action", required = false, defaultValue = "") String action,
                                    @RequestParam(value = "fullName", required = false) String fullName,
                                    @RequestParam(value = "email", required = false) String email,
                                    @RequestParam(value = "phone", required = false) String phone,
                                    @RequestParam(value = "address", required = false) String address,
                                    HttpServletRequest request, HttpSession session) {

        Users loggedUser = (Users) session.getAttribute("loggedUser");

        if (loggedUser == null) {
            return "redirect:" + ProjectPaths.HREF_TO_LOGINPAGE;
        }

        if (MainControllerServlet.ACTION_UPDATE_PROFILE.equals(action)) {
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
                return ProjectPaths.JSP_EDIT_PROFILEPAGE_PATH;
            }

            loggedUser.setFullName(fullName.trim());
            loggedUser.setEmail(email.trim());
            loggedUser.setPhone(phone.trim());
            loggedUser.setAddress(address.trim());

            boolean updated = userService.updateUser(loggedUser);
            if (updated) {
                session.setAttribute("loggedUser", loggedUser);
                request.setAttribute("successMessage", "Cập nhật thông tin thành công!");
                request.setAttribute("user", loggedUser);
            } else {
                request.setAttribute("errorMessage", "Cập nhật thông tin thất bại!");
                request.setAttribute("user", loggedUser);
            }
            return ProjectPaths.JSP_EDIT_PROFILEPAGE_PATH;
        } else {
            return "redirect:errorAtMainController.jsp";
        }
    }
}
