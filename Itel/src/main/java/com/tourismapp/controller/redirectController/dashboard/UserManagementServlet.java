package com.tourismapp.controller.redirectController.dashboard;

import com.tourismapp.common.MembershipLevel;
import com.tourismapp.common.Status;
import com.tourismapp.common.UserRole;
import com.tourismapp.config.ProjectPaths;
import com.tourismapp.controller.mainController.MainControllerServlet;
import static com.tourismapp.controller.mainController.MainControllerServlet.*;
import com.tourismapp.model.Users;
import com.tourismapp.service.user.UserService;
import com.tourismapp.utils.ErrDialog;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@WebServlet(name = "UserManagementServlet", urlPatterns = {MainControllerServlet.USER_MANAGEMENT_SERVLET})
public class UserManagementServlet extends HttpServlet {

    private static final String ACTION_SEARCH_USERS = "searchUsers";
    private UserService userService;

    @Override
    public void init() throws ServletException {
        userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action == null) {
            action = ACTION_LIST_USER;
        }

        switch (action) {
            case "createForm":
                request.getRequestDispatcher(ProjectPaths.JSP_PATH_DASHBOARD + "userManagement/createUser.jsp").forward(request, response);
                break;
            case "editForm":
                int editId = Integer.parseInt(request.getParameter("id"));
                Users editUser = userService.getUserById(editId);
                if (editUser == null) {
                    request.getSession().setAttribute("toastMessage", "Không tìm thấy người dùng!");
                    response.sendRedirect(ProjectPaths.HREF_TO_USERMANAGEMENT);
                    return;
                }
                request.setAttribute("user", editUser);
                request.getRequestDispatcher(ProjectPaths.JSP_PATH_DASHBOARD + "userManagement/editUser.jsp").forward(request, response);
                break;
            case "viewUser":
                int viewId = Integer.parseInt(request.getParameter("id"));
                Users viewUser = userService.getUserById(viewId);
                if (viewUser == null) {
                    request.getSession().setAttribute("toastMessage", "Không tìm thấy người dùng!");
                    response.sendRedirect(ProjectPaths.HREF_TO_USERMANAGEMENT);
                    return;
                }
                request.setAttribute("user", viewUser);
                request.getRequestDispatcher(ProjectPaths.JSP_PATH_DASHBOARD + "userManagement/viewUser.jsp").forward(request, response);
                break;
            case ACTION_SEARCH_USERS:
                String username = request.getParameter("username");
                String status = request.getParameter("status");
                List<Users> searchResults = userService.searchUsers(username, status);
                request.setAttribute("users", searchResults);
                if (searchResults.isEmpty()) {
                    request.getSession().setAttribute("toastMessage", "Không tìm thấy người dùng nào khớp với tiêu chí.");
                }
                request.getRequestDispatcher(ProjectPaths.JSP_USERMANAGEMENT_PATH).forward(request, response);
                break;
            case ACTION_LIST_USER:
            default:
                List<Users> userList = userService.getAllUsers();
                request.setAttribute("users", userList);
                request.getRequestDispatcher(ProjectPaths.JSP_USERMANAGEMENT_PATH).forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        System.out.println("Action received: " + action);

        try {
            switch (action) {
                case ACTION_CREATE_USER:
                    Users newUser = extractUserFromRequest(request);
                    Map<String, String> errors = userService.validateUserData(newUser, Boolean.FALSE);

                    if (!errors.isEmpty()) {
                        request.setAttribute("errors", errors);
                        // Gửi lại các field đúng
                        request.setAttribute("username", newUser.getUsername());
                        request.setAttribute("fullName", newUser.getFullName());
                        request.setAttribute("email", newUser.getEmail());
                        request.setAttribute("phone", newUser.getPhone());
                        request.setAttribute("address", newUser.getAddress());
                        request.setAttribute("role", newUser.getRole().getValue());
                        request.setAttribute("membershipLevelId", String.valueOf(newUser.getMembershipLevel().getId()));

                        request.getRequestDispatcher(ProjectPaths.JSP_PATH_DASHBOARD + "userManagement/createUser.jsp")
                                .forward(request, response);
                        return;
                    }

                    boolean success = userService.createUser(newUser);

                    if (success) {
                        request.getSession().setAttribute("toastMessage", "Tạo người dùng thành công!");
                        response.sendRedirect(ProjectPaths.HREF_TO_USERMANAGEMENT);
                    } else {
                        request.setAttribute("errorMessage", "Không thể tạo người dùng. Có thể username/email đã tồn tại trong DB.");
                        // Giữ lại dữ liệu
                        request.setAttribute("username", newUser.getUsername());
                        request.setAttribute("fullName", newUser.getFullName());
                        request.setAttribute("email", newUser.getEmail());
                        request.setAttribute("phone", newUser.getPhone());
                        request.setAttribute("address", newUser.getAddress());
                        request.setAttribute("role", newUser.getRole().getValue());
                        request.setAttribute("membershipLevelId", String.valueOf(newUser.getMembershipLevel().getId()));

                        request.getRequestDispatcher(ProjectPaths.JSP_PATH_DASHBOARD + "userManagement/createUser.jsp")
                                .forward(request, response);
                    }
                    return;

                case ACTION_EDIT_USER:
                    int userId = Integer.parseInt(request.getParameter("id"));
                    Users existingUser = userService.getUserById(userId);

                    if (existingUser == null) {
                        request.getSession().setAttribute("toastMessage", "Không tìm thấy người dùng!");
                        response.sendRedirect(ProjectPaths.HREF_TO_USERMANAGEMENT);
                        return;
                    }

                    Users updatedUser = updateUserFromRequest(request, existingUser);

                    // Kiểm tra trùng lặp username, email, phone trong DB (trừ chính user đang sửa)
                    errors = userService.validateUserData(updatedUser, true);

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
                        request.getRequestDispatcher(ProjectPaths.JSP_PATH_DASHBOARD + "userManagement/editUser.jsp").forward(request, response);
                        return;
                    }

                    if (userService.updateUser(updatedUser)) {
                        request.getSession().setAttribute("toastMessage", "Cập nhật người dùng thành công!");
                    } else {
                        request.getSession().setAttribute("toastMessage", "Lỗi khi cập nhật người dùng!");
                    }
                    response.sendRedirect(ProjectPaths.HREF_TO_USERMANAGEMENT);
                    
                    return;

                case ACTION_DELETE_USER:
                    String userIdStr = request.getParameter("userId");
                    System.out.println("Deleting user with ID: " + userIdStr);
                    if (userIdStr == null || userIdStr.trim().isEmpty()) {
                        throw new IllegalArgumentException("ID người dùng không hợp lệ!");
                    }
                    int deleteId = Integer.parseInt(userIdStr);
                    if (userService.deleteUser(deleteId)) {
                        request.getSession().setAttribute("toastMessage", "Xóa người dùng thành công!");
                    } else {
                        request.getSession().setAttribute("toastMessage", "Lỗi khi xóa người dùng: Không tìm thấy ID " + deleteId);
                    }
                    break;
                default:
                    request.getSession().setAttribute("toastMessage", "Hành động không hợp lệ: " + action);
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("toastMessage", "Lỗi: ID người dùng không hợp lệ!");
            e.printStackTrace();
        } catch (IllegalArgumentException e) {
            request.getSession().setAttribute("toastMessage", "Lỗi: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            request.getSession().setAttribute("toastMessage", "Lỗi hệ thống: " + e.getMessage());
            e.printStackTrace();
        }

        response.sendRedirect(ProjectPaths.HREF_TO_USERMANAGEMENT);
    }

    // <editor-fold defaultstate="collapsed" desc=" functional ... ">
    private Users extractUserFromRequest(HttpServletRequest request) {
        Users user = new Users();

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String roleStr = request.getParameter("role");
        String statusStr = request.getParameter("status");
        String membershipLevelIdStr = request.getParameter("membershipLevelId");

        user.setUsername(username);
        user.setPassword(password);
        user.setFullName(fullName);
        user.setEmail(email);
        user.setPhone(phone);
        user.setAddress(address);

        // ✅ Mặc định role là CUSTOMER nếu không có hoặc sai
        UserRole role = UserRole.CUSTOMER;
        if (roleStr != null && !roleStr.trim().isEmpty()) {
            try {
                role = UserRole.fromString(roleStr);
            } catch (IllegalArgumentException e) {
                System.out.println("Role không hợp lệ: " + roleStr + " → fallback CUSTOMER");
            }
        }
        user.setRole(role);

        // ✅ Mặc định status là ACTIVE nếu không có
        Status status = Status.ACTIVE;
        if (statusStr != null && !statusStr.trim().isEmpty()) {
            try {
                status = Status.valueOf(statusStr.toUpperCase());
            } catch (IllegalArgumentException e) {
                System.out.println("Status không hợp lệ: " + statusStr + " → fallback ACTIVE");
            }
        }
        user.setStatus(status);

        // ✅ Mặc định membershipLevel là STANDARD nếu không có hoặc sai
        MembershipLevel membershipLevel = MembershipLevel.STANDARD;
        if (membershipLevelIdStr != null && !membershipLevelIdStr.trim().isEmpty()) {
            try {
                int levelId = Integer.parseInt(membershipLevelIdStr);
                MembershipLevel parsed = MembershipLevel.fromId(levelId);
                if (parsed != null) {
                    membershipLevel = parsed;
                }
            } catch (NumberFormatException e) {
                System.out.println("Membership level không hợp lệ: " + membershipLevelIdStr + " → fallback STANDARD");
            }
        }
        user.setMembershipLevel(membershipLevel);

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
        System.out.println("Role from form: " + role);
        try {
            user.setRole(role != null && !role.trim().isEmpty() ? UserRole.valueOf(role.toUpperCase()) : existingUser.getRole());
            System.out.println("Assigned role: " + user.getRole());
        } catch (IllegalArgumentException e) {
            throw new IllegalArgumentException("Vai trò không hợp lệ: " + role);
        }

        String status = request.getParameter("status");
        System.out.println("Status from form: " + status);
        try {
            user.setStatus(status != null && !status.trim().isEmpty() ? Status.valueOf(status.toUpperCase()) : existingUser.getStatus());
            System.out.println("Assigned status: " + user.getStatus());
        } catch (IllegalArgumentException e) {
            throw new IllegalArgumentException("Trạng thái không hợp lệ: " + status);
        }

        String membershipLevelId = request.getParameter("membershipLevelId");
        ErrDialog.showError("Membership Level ID from form: " + membershipLevelId);
        try {
            if (membershipLevelId != null && !membershipLevelId.trim().isEmpty()) {
                int id = Integer.parseInt(membershipLevelId);
                MembershipLevel level = MembershipLevel.fromId(id);
                if (level != null) {
                    user.setMembershipLevel(level);
                } else {
                    throw new IllegalArgumentException("Cấp độ thành viên không hợp lệ: " + id);
                }
                System.out.println("Assigned membership level: " + level);
            } else {
                user.setMembershipLevel(existingUser.getMembershipLevel());
                System.out.println("Assigned existing membership level: " + existingUser.getMembershipLevel());
            }
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("Membership Level ID không hợp lệ: " + membershipLevelId);
        }

        return user;
    }
    // </editor-fold>
}
