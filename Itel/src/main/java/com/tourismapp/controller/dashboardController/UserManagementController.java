package com.tourismapp.controller.dashboardController;

import com.tourismapp.common.MembershipLevel;
import com.tourismapp.common.Status;
import com.tourismapp.common.UserRole;
import com.tourismapp.config.ProjectPaths;
import com.tourismapp.entity.Users;
import com.tourismapp.service.user.IUserService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import com.tourismapp.annotation.RequiresRole;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestParam;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@RequiresRole({UserRole.ADMIN, UserRole.STAFF})
@Controller
@RequestMapping("/admin/users")
public class UserManagementController {

    @Autowired
    private IUserService userService;

    @GetMapping
    public String listUser(@RequestParam(value = "username", required = false) String username,
                           @RequestParam(value = "status", required = false) String status,
                           HttpServletRequest request, HttpSession session) {
        
        if ((username != null && !username.isEmpty()) || (status != null && !status.isEmpty())) {
            List<Users> searchResults = userService.searchUsers(username, status);
            request.setAttribute("users", searchResults);
            if (searchResults.isEmpty()) {
                session.setAttribute("toastMessage", "Không tìm thấy người dùng nào khớp với tiêu chí.");
            }
        } else {
            request.setAttribute("users", userService.getAllUsers());
        }
        return ProjectPaths.JSP_USERMANAGEMENT_PATH;
    }

    @GetMapping("/create")
    public String createForm() {
        return ProjectPaths.JSP_PATH_DASHBOARD + "userManagement/createUser.jsp";
    }

    @GetMapping("/{id}/edit")
    public String editForm(@PathVariable("id") Integer id, HttpServletRequest request, HttpSession session) {
        if (id == null) {
            session.setAttribute("toastMessage", "ID không hợp lệ!");
            return "redirect:/admin/users";
        }
        Users editUser = userService.getUserById(id);
        if (editUser == null) {
            session.setAttribute("toastMessage", "Không tìm thấy người dùng!");
            return "redirect:/admin/users";
        }
        request.setAttribute("user", editUser);
        return ProjectPaths.JSP_PATH_DASHBOARD + "userManagement/editUser.jsp";
    }

    @GetMapping("/{id}")
    public String viewUser(@PathVariable("id") Integer id, HttpServletRequest request, HttpSession session) {
        if (id == null) {
            session.setAttribute("toastMessage", "ID không hợp lệ!");
            return "redirect:/admin/users";
        }
        Users viewUser = userService.getUserById(id);
        if (viewUser == null) {
            session.setAttribute("toastMessage", "Không tìm thấy người dùng!");
            return "redirect:/admin/users";
        }
        request.setAttribute("user", viewUser);
        return ProjectPaths.JSP_PATH_DASHBOARD + "userManagement/viewUser.jsp";
    }

    @PostMapping("/create")
    public String createUser(HttpServletRequest request, HttpSession session) {
        try {
            Users newUser = extractUserFromRequest(request);
            Map<String, String> errors = userService.validateUserData(newUser, Boolean.FALSE);

            if (!errors.isEmpty()) {
                request.setAttribute("errors", errors);
                preserveInput(request, newUser);
                return ProjectPaths.JSP_PATH_DASHBOARD + "userManagement/createUser.jsp";
            }

            boolean success = userService.createUser(newUser);
            if (success) {
                session.setAttribute("toastMessage", "Tạo người dùng thành công!");
                return "redirect:/admin/users";
            } else {
                request.setAttribute("errorMessage", "Không thể tạo người dùng. Có thể username/email đã tồn tại trong DB.");
                preserveInput(request, newUser);
                return ProjectPaths.JSP_PATH_DASHBOARD + "userManagement/createUser.jsp";
            }
        } catch (Exception e) {
            session.setAttribute("toastMessage", "Lỗi hệ thống: " + e.getMessage());
            e.printStackTrace();
            return "redirect:/admin/users";
        }
    }

    @PostMapping("/{id}/edit")
    public String editUser(@PathVariable("id") Integer id, HttpServletRequest request, HttpSession session) {
        try {
            Users existingUser = userService.getUserById(id);

            if (existingUser == null) {
                session.setAttribute("toastMessage", "Không tìm thấy người dùng!");
                return "redirect:/admin/users";
            }

            Users updatedUser = updateUserFromRequest(request, existingUser);
            Map<String, String> errors = userService.validateUserData(updatedUser, true);

            Optional<Users> userByUsername = userService.findUserByUsername(updatedUser.getUsername());
            if (userByUsername.isPresent() && userByUsername.get().getUserId() != updatedUser.getUserId()) {
                errors.put("username", "Tên đăng nhập đã tồn tại.");
            }

            Optional<Users> userByEmail = userService.findUserByEmail(updatedUser.getEmail());
            if (userByEmail.isPresent() && userByEmail.get().getUserId() != updatedUser.getUserId()) {
                errors.put("email", "Email đã tồn tại.");
            }

            Optional<Users> userByPhone = userService.findUserByPhone(updatedUser.getPhone());
            if (userByPhone.isPresent() && userByPhone.get().getUserId() != updatedUser.getUserId()) {
                errors.put("phone", "Số điện thoại đã tồn tại.");
            }

            if (!errors.isEmpty()) {
                request.setAttribute("errors", errors);
                request.setAttribute("user", updatedUser);
                return ProjectPaths.JSP_PATH_DASHBOARD + "userManagement/editUser.jsp";
            }

            if (userService.updateUser(updatedUser)) {
                session.setAttribute("toastMessage", "Cập nhật người dùng thành công!");
            } else {
                session.setAttribute("toastMessage", "Lỗi khi cập nhật người dùng!");
            }
            return "redirect:/admin/users";
        } catch (Exception e) {
            session.setAttribute("toastMessage", "Lỗi hệ thống: " + e.getMessage());
            e.printStackTrace();
            return "redirect:/admin/users";
        }
    }

    @PostMapping("/{id}/delete")
    public String deleteUser(@PathVariable("id") Integer id, HttpServletRequest request, HttpSession session) {
        try {
            if (userService.deleteUser(id)) {
                session.setAttribute("toastMessage", "Xóa người dùng thành công!");
            } else {
                session.setAttribute("toastMessage", "Lỗi khi xóa người dùng: Không tìm thấy ID " + id);
            }
        } catch (Exception e) {
            session.setAttribute("toastMessage", "Lỗi hệ thống: " + e.getMessage());
            e.printStackTrace();
        }
        return "redirect:/admin/users";
    }

    private void preserveInput(HttpServletRequest request, Users newUser) {
        request.setAttribute("username", newUser.getUsername());
        request.setAttribute("fullName", newUser.getFullName());
        request.setAttribute("email", newUser.getEmail());
        request.setAttribute("phone", newUser.getPhone());
        request.setAttribute("address", newUser.getAddress());
        request.setAttribute("role", newUser.getRole().getValue());
        request.setAttribute("membershipLevelId", String.valueOf(newUser.getMembershipLevel().getId()));
    }

    private Users extractUserFromRequest(HttpServletRequest request) {
        Users user = new Users();
        user.setUsername(request.getParameter("username"));
        user.setPassword(request.getParameter("password"));
        user.setFullName(request.getParameter("fullName"));
        user.setEmail(request.getParameter("email"));
        user.setPhone(request.getParameter("phone"));
        user.setAddress(request.getParameter("address"));

        String roleStr = request.getParameter("role");
        UserRole role = UserRole.CUSTOMER;
        if (roleStr != null && !roleStr.trim().isEmpty()) {
            try { role = UserRole.fromString(roleStr); } catch (Exception ignored) {}
        }
        user.setRole(role);

        String statusStr = request.getParameter("status");
        Status status = Status.ACTIVE;
        if (statusStr != null && !statusStr.trim().isEmpty()) {
            try { status = Status.valueOf(statusStr.toUpperCase()); } catch (Exception ignored) {}
        }
        user.setStatus(status);

        String levelStr = request.getParameter("membershipLevelId");
        MembershipLevel level = MembershipLevel.STANDARD;
        if (levelStr != null && !levelStr.trim().isEmpty()) {
            try {
                MembershipLevel parsed = MembershipLevel.fromId(Integer.parseInt(levelStr));
                if (parsed != null) level = parsed;
            } catch (Exception ignored) {}
        }
        user.setMembershipLevel(level);

        user.setCreatedAt(LocalDateTime.now());
        user.setUpdatedAt(LocalDateTime.now());
        return user;
    }

    private Users updateUserFromRequest(HttpServletRequest request, Users existingUser) {
        Users user = new Users();
        user.setUserId(existingUser.getUserId());
        user.setCreatedAt(existingUser.getCreatedAt());
        user.setUpdatedAt(LocalDateTime.now());

        String username = request.getParameter("username");
        user.setUsername(username != null && !username.trim().isEmpty() ? username : existingUser.getUsername());

        String password = request.getParameter("password");
        user.setPassword(password != null && !password.trim().isEmpty() ? password : null);

        String fullName = request.getParameter("fullName");
        user.setFullName(fullName != null && !fullName.trim().isEmpty() ? fullName : existingUser.getFullName());

        String email = request.getParameter("email");
        user.setEmail(email != null && !email.trim().isEmpty() ? email : existingUser.getEmail());

        String phone = request.getParameter("phone");
        user.setPhone(phone != null && !phone.trim().isEmpty() ? phone : existingUser.getPhone());

        String address = request.getParameter("address");
        user.setAddress(address != null && !address.trim().isEmpty() ? address : existingUser.getAddress());

        String role = request.getParameter("role");
        try {
            user.setRole(role != null && !role.trim().isEmpty() ? UserRole.valueOf(role.toUpperCase()) : existingUser.getRole());
        } catch (IllegalArgumentException e) {
            throw new IllegalArgumentException("Vai trò không hợp lệ: " + role);
        }

        String status = request.getParameter("status");
        try {
            user.setStatus(status != null && !status.trim().isEmpty() ? Status.valueOf(status.toUpperCase()) : existingUser.getStatus());
        } catch (IllegalArgumentException e) {
            throw new IllegalArgumentException("Trạng thái không hợp lệ: " + status);
        }

        String membershipLevelId = request.getParameter("membershipLevelId");
        try {
            if (membershipLevelId != null && !membershipLevelId.trim().isEmpty()) {
                MembershipLevel level = MembershipLevel.fromId(Integer.parseInt(membershipLevelId));
                if (level != null) user.setMembershipLevel(level);
                else throw new IllegalArgumentException("Cấp độ thành viên không hợp lệ");
            } else {
                user.setMembershipLevel(existingUser.getMembershipLevel());
            }
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("Membership Level ID không hợp lệ: " + membershipLevelId);
        }

        return user;
    }
}
