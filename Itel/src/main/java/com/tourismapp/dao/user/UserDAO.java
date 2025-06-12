/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.tourismapp.dao.user;

import com.sun.tools.xjc.reader.xmlschema.bindinfo.BIConversion.User;
import com.tourismapp.common.Status;
import com.tourismapp.common.UserRole;
import com.tourismapp.dao.DBConnection;
import com.tourismapp.model.MembershipLevel;
import com.tourismapp.model.Users;
import com.tourismapp.utils.ErrDialog;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
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
                new MembershipLevel(rs.getInt("membership_level_id")),
                Status.valueOf(rs.getString("status").toUpperCase()),
                rs.getTimestamp("created_at").toLocalDateTime(),
                rs.getTimestamp("updated_at").toLocalDateTime()
        );
    }
    
    @Override
    public List<Users> getAllUsers() {
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
