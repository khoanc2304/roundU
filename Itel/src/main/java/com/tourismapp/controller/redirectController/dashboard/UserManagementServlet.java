package com.tourismapp.controller.redirectController.dashboard;

import com.tourismapp.common.MembershipLevel;
import com.tourismapp.common.Status;
import com.tourismapp.common.UserRole;
import com.tourismapp.config.ProjectPaths;
import com.tourismapp.controller.mainController.MainControllerServlet;
import static com.tourismapp.controller.mainController.MainControllerServlet.*;
import com.tourismapp.model.Users;
import com.tourismapp.service.user.IUserService;
import com.tourismapp.service.user.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet(name = "UserManagementServlet", urlPatterns = {MainControllerServlet.USER_MANAGEMENT_SERVLET})
public class UserManagementServlet extends HttpServlet {

    private static final String ACTION_SEARCH_USERS = "searchUsers";
    private IUserService userService;

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
                    System.out.println("User to create: " + newUser);
                    if (userService.createUser(newUser)) {
                        request.getSession().setAttribute("toastMessage", "Tạo người dùng thành công!");
                    } else {
                        request.getSession().setAttribute("toastMessage", "Lỗi khi tạo người dùng!");
                    }
                    break;
                case ACTION_EDIT_USER:
                    int userId = Integer.parseInt(request.getParameter("id"));
                    Users existingUser = userService.getUserById(userId);
                    if (existingUser == null) {
                        request.getSession().setAttribute("toastMessage", "Không tìm thấy người dùng!");
                        response.sendRedirect(ProjectPaths.HREF_TO_USERMANAGEMENT);
                        return;
                    }
                    Users updatedUser = updateUserFromRequest(request, existingUser);
                    System.out.println("User to update: " + updatedUser);
                    if (userService.updateUser(updatedUser)) {
                        request.getSession().setAttribute("toastMessage", "Cập nhật người dùng thành công!");
                    } else {
                        request.getSession().setAttribute("toastMessage", "Lỗi khi cập nhật người dùng!");
                    }
                    break;
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

        try {
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String roleStr = request.getParameter("role");
            String statusStr = request.getParameter("status");
            String membershipLevelIdStr = request.getParameter("membershipLevelId");

            System.out.println("DEBUG: username=" + username);
            System.out.println("DEBUG: password=" + password);
            System.out.println("DEBUG: fullName=" + fullName);
            System.out.println("DEBUG: email=" + email);
            System.out.println("DEBUG: phone=" + phone);
            System.out.println("DEBUG: address=" + address);
            System.out.println("DEBUG: role=" + roleStr);
            System.out.println("DEBUG: status=" + statusStr);
            System.out.println("DEBUG: membershipLevelId=" + membershipLevelIdStr);

            user.setUsername(username);
            user.setPassword(password);
            user.setFullName(fullName);
            user.setEmail(email);
            user.setPhone(phone);
            user.setAddress(address);

            if (roleStr != null && !roleStr.trim().isEmpty()) {
                try {
                    user.setRole(UserRole.valueOf(roleStr.toUpperCase()));
                } catch (IllegalArgumentException e) {
                    throw new IllegalArgumentException("Vai trò không hợp lệ: " + roleStr);
                }
            } else {
                throw new IllegalArgumentException("Vai trò là bắt buộc.");
            }

            if (statusStr != null && !statusStr.trim().isEmpty()) {
                try {
                    user.setStatus(Status.valueOf(statusStr.toUpperCase()));
                } catch (IllegalArgumentException e) {
                    throw new IllegalArgumentException("Trạng thái không hợp lệ: " + statusStr);
                }
            } else {
                user.setStatus(Status.ACTIVE);
            }

            if (membershipLevelIdStr != null && !membershipLevelIdStr.trim().isEmpty()) {
                try {
                    int levelId = Integer.parseInt(membershipLevelIdStr);
                    MembershipLevel level = MembershipLevel.fromId(levelId);
                    if (level != null) {
                        user.setMembershipLevel(level);
                    } else {
                        throw new IllegalArgumentException("Cấp độ thành viên không hợp lệ: " + levelId);
                    }
                } catch (NumberFormatException e) {
                    throw new IllegalArgumentException("ID cấp độ thành viên phải là số.");
                }
            } else {
                throw new IllegalArgumentException("Cấp độ thành viên là bắt buộc.");
            }

            LocalDateTime now = LocalDateTime.now();
            user.setCreatedAt(now);
            user.setUpdatedAt(now);

        } catch (Exception e) {
            System.out.println("LỖI khi tạo user: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }

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
        System.out.println("Membership Level ID from form: " + membershipLevelId);
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
