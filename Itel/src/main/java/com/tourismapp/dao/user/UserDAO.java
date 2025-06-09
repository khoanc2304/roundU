/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.tourismapp.dao.user;

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

/**
 *
 * @author Admin
 */
public class UserDAO implements IUserDAO {

    private static final String GET_ALL_USERS = "SELECT * FROM Users;";

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
//            ErrDialog.showError("size active products: " + activeProducts.size());
        } catch (SQLException e) {
            ErrDialog.showError("Lỗi khi truy vấn sản phẩm: " + e.getMessage());
//            e.printStackTrace(); 
        }
        return users;
    }

    public static void main(String[] args) {
        UserDAO cDAO = new UserDAO();
        List<Users> us = cDAO.getAllUsers();
        System.out.println("=== ALL User ===");
        for (Users u : us) {
            System.out.println(u);
        }
    }
}
