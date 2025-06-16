/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.tourismapp.dao.user;

import com.tourismapp.common.MembershipLevel;
import com.tourismapp.common.Status;
import com.tourismapp.common.UserRole;
import com.tourismapp.dao.DBConnection;
import com.tourismapp.model.Users;
import com.tourismapp.utils.ErrDialog;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

/**
 *
 * @author Admin
 */
public class UserDAO implements IUserDAO {

    private static final String GET_ALL_USERS = "SELECT * FROM Users;";
    private static final String FIND_USER_BY_CREDENTIALS = "SELECT * FROM Users WHERE (username = ? OR email = ?) AND password = ?;";

    @Override
    public Users mapUser(ResultSet rs) throws SQLException {
        return new Users(
                rs.getInt("user_id"),
                rs.getString("username"),
                rs.getString("password"),
                rs.getString("fullName"),
                rs.getString("email"),
                rs.getString("phone"),
                rs.getString("address"),
                UserRole.valueOf(rs.getString("role").toUpperCase()),
                rs.getInt("membership_level_id") != 0 ? MembershipLevel.fromId(rs.getInt("membership_level_id")) : null,
                rs.getString("image_url"),
                Status.valueOf(rs.getString("status").toUpperCase()),
                rs.getTimestamp("created_at").toLocalDateTime(),
                rs.getTimestamp("updated_at").toLocalDateTime()
        );
    }

    @Override
    public Optional<Users> findUserByCredentials(String username, String email, String password) {
        Users user = null;

        try (Connection connection = DBConnection.getConnection();) {
            try (PreparedStatement stmt = connection.prepareStatement(FIND_USER_BY_CREDENTIALS)) {
                stmt.setString(1, username);
                stmt.setString(2, email);
                stmt.setString(3, password);

                ResultSet rs = stmt.executeQuery();

                if (rs.next()) {
                    user = mapUser(rs);
                }
            }
        } catch (SQLException e) {
            ErrDialog.showError("ex: " + e);
        }

        return Optional.ofNullable(user);
    }

    public List<Users> selectAllUsers() {
        List<Users> users = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(GET_ALL_USERS); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Users user = mapUser(rs);
                users.add(user);
            }
        } catch (SQLException e) {
            ErrDialog.showError("Lỗi khi truy vấn sản phẩm: " + e.getMessage());
        }
        return users;
    }
 
    
/////////////////////////////////////////////////// HUY /////////////////////////////////////////////////////
    @Override
    public List<Users> getAllUsers() {
        List<Users> users = new ArrayList<>();
        String sql = "SELECT * FROM Users";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            System.out.println("SQL: " + sql);
            while (rs.next()) {
                users.add(mapResultSetToUser(rs));
            }
            System.out.println("Users retrieved: " + users.size());
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Lỗi khi lấy danh sách người dùng: " + e.getMessage());
        }
        return users;
    }

    @Override
    public Users getUserById(int userId) {
        String sql = "SELECT * FROM Users WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            System.out.println("SQL: " + sql);
            System.out.println("Parameters: [user_id=" + userId + "]");
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToUser(rs);
                }
            }
            System.out.println("No user found with ID: " + userId);
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Lỗi khi lấy người dùng: " + e.getMessage());
        }
        return null;
    }

    @Override
    public boolean createUser(Users user) {
        // Kiểm tra username hoặc email đã tồn tại
        String checkSql = "SELECT COUNT(*) FROM Users WHERE username = ? OR email = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(checkSql)) {
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getEmail());
            System.out.println("SQL: " + checkSql);
            System.out.println("Parameters: [username=" + user.getUsername() + ", email=" + user.getEmail() + "]");
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) {
                    System.out.println("Username or email already exists: " + user.getUsername() + ", " + user.getEmail());
                    return false;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Lỗi khi kiểm tra username/email: " + e.getMessage());
        }

        String sql = "INSERT INTO Users (username, password, fullName, email, phone, address, role, membership_level_id, status, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            setUserParams(ps, user);
            System.out.println("SQL: " + sql);
            System.out.println("Parameters: [username=" + user.getUsername() + ", password=" + user.getPassword()
                    + ", fullName=" + user.getFullName() + ", email=" + user.getEmail()
                    + ", phone=" + user.getPhone() + ", address=" + user.getAddress()
                    + ", role=" + user.getRole().getValue() + ", membership_level_id=" + user.getMembershipLevel().getId()
                    + ", status=" + user.getStatus().getValue() + ", created_at=" + user.getCreatedAt()
                    + ", updated_at=" + user.getUpdatedAt() + "]");
            int rowsAffected = ps.executeUpdate();
            System.out.println("Rows affected: " + rowsAffected);
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Lỗi khi tạo người dùng: " + e.getMessage());
        }
    }

    @Override
    public boolean updateUser(Users user) {
        StringBuilder sql = new StringBuilder("UPDATE Users SET ");
        List<String> updates = new ArrayList<>();
        List<Object> params = new ArrayList<>();

        if (user.getUsername() != null && !user.getUsername().trim().isEmpty()) {
            updates.add("username=?");
            params.add(user.getUsername());
        }
        if (user.getPassword() != null && !user.getPassword().trim().isEmpty()) {
            updates.add("password=?");
            params.add(user.getPassword());
        }
        if (user.getFullName() != null && !user.getFullName().trim().isEmpty()) {
            updates.add("fullName=?");
            params.add(user.getFullName());
        }
        if (user.getEmail() != null && !user.getEmail().trim().isEmpty()) {
            updates.add("email=?");
            params.add(user.getEmail());
        }
        if (user.getPhone() != null && !user.getPhone().trim().isEmpty()) {
            updates.add("phone=?");
            params.add(user.getPhone());
        }
        if (user.getAddress() != null && !user.getAddress().trim().isEmpty()) {
            updates.add("address=?");
            params.add(user.getAddress());
        }
        if (user.getRole() != null) {
            updates.add("role=?");
            params.add(user.getRole().getValue());
        }
        if (user.getMembershipLevel() != null) {
            updates.add("membership_level_id=?");
            params.add(user.getMembershipLevel().getId());
        }
        if (user.getStatus() != null) {
            updates.add("status=?");
            params.add(user.getStatus().getValue());
        }
        updates.add("updated_at=GETDATE()");

        if (updates.isEmpty()) {
            System.out.println("No fields to update for user ID: " + user.getUserId());
            return false;
        }

        sql.append(String.join(", ", updates));
        sql.append(" WHERE user_id=?");
        params.add(user.getUserId());

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            System.out.println("SQL: " + sql);
            System.out.println("Parameters: " + params);
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            int rowsAffected = ps.executeUpdate();
            System.out.println("Rows affected: " + rowsAffected);
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Lỗi khi cập nhật người dùng: " + e.getMessage());
        }
    }

    @Override
    public boolean deleteUser(int userId) {
        String sql = "UPDATE Users SET status = 'inactive', updated_at = GETDATE() WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            System.out.println("SQL: " + sql);
            System.out.println("Parameters: [user_id=" + userId + "]");
            int rowsAffected = ps.executeUpdate();
            System.out.println("Rows affected: " + rowsAffected);
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Lỗi khi xóa người dùng: " + e.getMessage());
        }
    }

    @Override
    public List<Users> searchUsers(String username, String status) {
        StringBuilder sql = new StringBuilder("SELECT * FROM Users WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (username != null && !username.trim().isEmpty()) {
            sql.append(" AND username LIKE ?");
            params.add("%" + username + "%");
        }
        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND status = ?");
            params.add(status.toLowerCase());
        }

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            System.out.println("SQL: " + sql);
            System.out.println("Parameters: " + params);
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            List<Users> users = new ArrayList<>();
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    users.add(mapResultSetToUser(rs));
                }
            }
            System.out.println("Users found: " + users.size());
            return users;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Lỗi khi tìm kiếm người dùng: " + e.getMessage());
        }
    }

    private Users mapResultSetToUser(ResultSet rs) throws SQLException {
        Users user = new Users();
        user.setUserId(rs.getInt("user_id"));
        user.setUsername(rs.getString("username"));
        user.setPassword(rs.getString("password"));
        user.setFullName(rs.getString("fullName"));
        user.setEmail(rs.getString("email"));
        user.setPhone(rs.getString("phone"));
        user.setAddress(rs.getString("address"));
        try {
            user.setRole(UserRole.valueOf(rs.getString("role").toUpperCase()));
        } catch (IllegalArgumentException e) {
            System.out.println("Invalid role: " + rs.getString("role"));
            throw new RuntimeException("Vai trò không hợp lệ: " + rs.getString("role"));
        }
        try {
            user.setMembershipLevel(MembershipLevel.fromId(rs.getInt("membership_level_id")));
        } catch (IllegalArgumentException e) {
            System.out.println("Invalid membership level: " + rs.getInt("membership_level_id"));
            throw new RuntimeException("Cấp độ thành viên không hợp lệ: " + rs.getInt("membership_level_id"));
        }
        try {
            user.setStatus(Status.valueOf(rs.getString("status").toUpperCase()));
        } catch (IllegalArgumentException e) {
            System.out.println("Invalid status: " + rs.getString("status"));
            throw new RuntimeException("Trạng thái không hợp lệ: " + rs.getString("status"));
        }
        user.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
        user.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());
        return user;
    }

    private void setUserParams(PreparedStatement ps, Users user) throws SQLException {
        ps.setString(1, user.getUsername());
        ps.setString(2, user.getPassword());
        ps.setString(3, user.getFullName());
        ps.setString(4, user.getEmail());
        ps.setString(5, user.getPhone());
        ps.setString(6, user.getAddress());
        ps.setString(7, user.getRole().getValue());
        ps.setInt(8, user.getMembershipLevel().getId());
        ps.setString(9, user.getStatus().getValue());
        ps.setTimestamp(10, Timestamp.valueOf(user.getCreatedAt() != null ? user.getCreatedAt() : LocalDateTime.now()));
        ps.setTimestamp(11, Timestamp.valueOf(user.getUpdatedAt() != null ? user.getUpdatedAt() : LocalDateTime.now()));
    }

    public static void main(String[] args) {
        // Khởi tạo UserService hoặc lớp chứa findUserByCredentials
        UserDAO ud = new UserDAO(); // Thay bằng cách khởi tạo thực tế

        // Dữ liệu kiểm tra
        String username = "";
        String email = "user1@example.com";
        String password = "user1";

        // Gọi phương thức
        Optional<Users> loggedUser = ud.findUserByCredentials(username, email, password);

        // Kiểm tra kết quả
        if (loggedUser.isPresent()) {
            Users user = loggedUser.get();
            System.out.println("User found: " + user.getClass().getName());
            System.out.println("Username: " + (user.getUsername() != null ? user.getUsername() : "N/A"));
            System.out.println("Email: " + (user.getEmail() != null ? user.getEmail() : "N/A"));
            System.out.println("Role: " + (user.getRole() != null ? user.getRole().getValue() : "N/A"));
        } else {
            System.out.println("No user found with the given credentials.");
        }
    }

}
