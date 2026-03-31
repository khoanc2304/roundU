package com.tourismapp.controller.userController;

import com.tourismapp.config.ProjectPaths;
import com.tourismapp.entity.Users;
import com.tourismapp.service.user.IUserService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ModelAttribute;
import jakarta.validation.Valid;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import com.tourismapp.dto.ProfileUpdateRequest;

@Controller
public class ProfileController {

    @Autowired
    private IUserService userService;

    @GetMapping("/profilePage")
    public String handleGetProfile(@RequestParam(value = "action", required = false, defaultValue = "viewProfile") String action,
                                   HttpServletRequest request, HttpSession session) {
        Users loggedUser = (Users) request.getAttribute("loggedUser");

        if (loggedUser == null) {
            return "redirect:" + ProjectPaths.HREF_TO_LOGINPAGE.substring(ProjectPaths.PREFIX_WEB_PATH.length());
        }

        switch (action) {
            case "viewProfile":
                request.setAttribute("user", loggedUser);
                return ProjectPaths.JSP_PROFILEPAGE_PATH;
            case "editProfile":
                request.setAttribute("user", loggedUser);
                return ProjectPaths.JSP_EDIT_PROFILEPAGE_PATH;
            case "changePassword":
                request.setAttribute("user", loggedUser);
                return ProjectPaths.JSP_CHANGE_PASSWORD_PATH;
            default:
                return "redirect:errorAtMainController.jsp";
        }
    }

    @PostMapping("/profilePage")
    public String handlePostProfile(@Valid @ModelAttribute ProfileUpdateRequest requestDto,
                                    BindingResult bindingResult,
                                    HttpServletRequest request, HttpSession session) {

        Users loggedUser = (Users) request.getAttribute("loggedUser");

        if (loggedUser == null) {
            return "redirect:" + ProjectPaths.HREF_TO_LOGINPAGE.substring(ProjectPaths.PREFIX_WEB_PATH.length());
        }

        if ("updateProfile".equals(requestDto.getAction())) {
            
            if (bindingResult.hasErrors()) {
                StringBuilder errorMessage = new StringBuilder();
                for (FieldError error : bindingResult.getFieldErrors()) {
                    errorMessage.append(error.getDefaultMessage()).append(" ");
                }
                request.setAttribute("errorMessage", errorMessage.toString().trim());
                request.setAttribute("user", loggedUser);
                return ProjectPaths.JSP_EDIT_PROFILEPAGE_PATH;
            }

            loggedUser.setFullName(requestDto.getFullName() != null ? requestDto.getFullName().trim() : "");
            loggedUser.setEmail(requestDto.getEmail() != null ? requestDto.getEmail().trim() : "");
            loggedUser.setPhone(requestDto.getPhone() != null ? requestDto.getPhone().trim() : "");
            loggedUser.setAddress(requestDto.getAddress() != null ? requestDto.getAddress().trim() : "");

            boolean updated = userService.updateUser(loggedUser);
            if (updated) {
                request.setAttribute("loggedUser", loggedUser);
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
