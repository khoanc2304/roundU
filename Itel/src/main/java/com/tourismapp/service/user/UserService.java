/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.tourismapp.service.user;

import com.tourismapp.common.MembershipLevel;
import com.tourismapp.dao.DBConnection;
import com.tourismapp.dao.user.IUserDAO;
import com.tourismapp.dao.user.UserDAO;
import com.tourismapp.model.Users;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
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
    public Optional<Users> findUserByCredentials(String identifier, String password) {
        return userDAO.findUserByCredentials(identifier, password);
    }
    
    
    //========================================================= HUY====================================================
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
        return levelId >= 1 && levelId <= 5;
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
    
    
    //===============================================VINH===============================================
    @Override
    public BigDecimal getTotalPurchaseAmount(int userId) {
        String sql = "SELECT SUM(total_amount) FROM Orders " +
                     "WHERE user_id = ? AND order_date >= DATEADD(MONTH, -12, GETDATE()) " +
                     "AND status IN ('completed', 'shipped', 'pending')";
        
        System.out.println("Tính tổng giá trị đơn hàng cho userId: " + userId);
        System.out.println("SQL: " + sql);
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    BigDecimal total = rs.getBigDecimal(1);
                    if (total == null) {
                        System.out.println("Không có đơn hàng nào trong 12 tháng qua, trả về 0");
                        return BigDecimal.ZERO;
                    }
                    System.out.println("Tổng giá trị đơn hàng tìm thấy: " + total);
                    return total;
                }
            }
        } catch (SQLException e) {
            System.out.println("Lỗi SQL khi tính tổng giá trị đơn hàng: " + e.getMessage());
            e.printStackTrace();
        }
        
        System.out.println("Không tìm thấy đơn hàng nào, trả về 0");
        return BigDecimal.ZERO;
    }
    
    @Override
    public boolean checkAndUpgradeMembership(int userId, BigDecimal orderAmount) {
        try {
            // Lấy thông tin người dùng hiện tại
            Users user = getUserById(userId);
            if (user == null) {
                System.out.println("Không tìm thấy người dùng với ID: " + userId);
                return false;
            }
            
            // Lấy hạng mức hiện tại
            MembershipLevel currentLevel = user.getMembershipLevel();
            if (currentLevel == null) {
                currentLevel = MembershipLevel.STANDARD;
                System.out.println("Người dùng " + userId + " không có hạng mức, đặt mặc định là STANDARD");
            }
            
            System.out.println("Kiểm tra nâng cấp cho người dùng: " + user.getUsername());
            System.out.println("Hạng mức hiện tại: " + currentLevel.getValue() + " (ID: " + currentLevel.getId() + ")");
            System.out.println("Giá trị đơn hàng mới: " + orderAmount);
            
            // Lấy tổng giá trị đơn hàng (bao gồm đơn hàng mới)
            BigDecimal previousPurchase = getTotalPurchaseAmount(userId);
            BigDecimal totalPurchase = previousPurchase.add(orderAmount);
            
            System.out.println("Tổng giá trị đơn hàng trước đây: " + previousPurchase);
            System.out.println("Tổng giá trị đơn hàng sau khi cộng: " + totalPurchase);
            
            // Ngưỡng nâng cấp (30 triệu cho mỗi cấp)
            BigDecimal silverThreshold = new BigDecimal("30000000");  // 30 triệu
            BigDecimal goldThreshold = new BigDecimal("60000000");    // 60 triệu
            BigDecimal diamondThreshold = new BigDecimal("90000000"); // 90 triệu
            
            // Xác định hạng mức mới dựa trên tổng giá trị đơn hàng
            MembershipLevel newLevel = currentLevel;
            
            if (totalPurchase.compareTo(diamondThreshold) >= 0) {
                newLevel = MembershipLevel.DIAMOND;
            } else if (totalPurchase.compareTo(goldThreshold) >= 0) {
                newLevel = MembershipLevel.GOLD;
            } else if (totalPurchase.compareTo(silverThreshold) >= 0) {
                newLevel = MembershipLevel.SILVER;
            } else {
                newLevel = MembershipLevel.BRONZE;
            }
            
            System.out.println("Hạng mức mới xác định: " + newLevel.getValue() + " (ID: " + newLevel.getId() + ")");
            
            // Nếu hạng mức không thay đổi hoặc bị giảm, không cập nhật
            if (newLevel.getId() <= currentLevel.getId()) {
                System.out.println("Không cần nâng cấp hạng mức thành viên");
                return false;
            }
            
            // Cập nhật hạng mức thành viên mới
            user.setMembershipLevel(newLevel);
            boolean updated = updateUser(user);
            
            if (updated) {
                System.out.println("ĐÃ NÂNG CẤP thành viên " + user.getUsername() + 
                                  " từ " + currentLevel.getValue() + 
                                  " lên " + newLevel.getValue() +
                                  " với tổng giá trị đơn hàng: " + totalPurchase);
            } else {
                System.out.println("LỖI khi cập nhật hạng mức thành viên trong cơ sở dữ liệu");
            }
            
            return updated;
        } catch (Exception e) {
            System.out.println("LỖI trong quá trình nâng cấp hạng mức thành viên: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}
