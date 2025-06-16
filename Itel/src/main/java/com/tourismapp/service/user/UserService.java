/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.tourismapp.service.user;

import com.tourismapp.dao.user.IUserDAO;
import com.tourismapp.dao.user.UserDAO;
import com.tourismapp.model.Users;
import java.util.List;
import java.util.Optional;

/**
 *
 * @author Admin
 */
public class UserService implements IUserService {

    private final IUserDAO userDAO = new UserDAO();
    
    // KHOA
    @Override
    public List<Users> getAllUsers() {
        return userDAO.getAllUsers();
    }

    @Override
    public Optional<Users> findUserByCredentials(String username, String email, String password) {
        return userDAO.findUserByCredentials(username, email, password);
    }
    
    
    // HUY
    @Override
    public Users getUserById(int userId) {
        return userDAO.getUserById(userId);
    }

    @Override
    public boolean createUser(Users user) {
        if (!isValidMembershipLevel(user.getMembershipLevel().getId())) {
            throw new IllegalArgumentException("Cấp độ thành viên không tồn tại: " + user.getMembershipLevel().getId());
        }
        if (isUsernameExists(user.getUsername())) {
            throw new IllegalArgumentException("Tên đăng nhập đã tồn tại: " + user.getUsername());
        }
        return userDAO.createUser(user);
    }

    @Override
    public boolean updateUser(Users user) {
        if (!isValidMembershipLevel(user.getMembershipLevel().getId())) {
            throw new IllegalArgumentException("Cấp độ thành viên không tồn tại: " + user.getMembershipLevel().getId());
        }
        return userDAO.updateUser(user);
    }

    @Override
    public boolean deleteUser(int userId) {
        return userDAO.deleteUser(userId);
    }

    @Override
    public List<Users> searchUsers(String username, String status) {
        return userDAO.searchUsers(username, status);
    }

    private boolean isValidMembershipLevel(int levelId) {
        return levelId >= 1 && levelId <= 4;
    }

    private boolean isUsernameExists(String username) {
        String sql = "SELECT COUNT(*) FROM Users WHERE username = ?";
        try (java.sql.Connection conn = com.tourismapp.dao.DBConnection.getConnection(); java.sql.PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            try (java.sql.ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (java.sql.SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
