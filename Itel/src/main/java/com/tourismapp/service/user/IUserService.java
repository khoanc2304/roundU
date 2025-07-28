/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.tourismapp.service.user;

import com.tourismapp.model.Users;
import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

/**
 *
 * @author Admin
 */
public interface IUserService {
    // KHOA
    List< Users> getAllUsers();

    Optional<Users> findUserByCredentials(String identifier, String password);
    
    
    //=============================================== HUY==============================================
    Users getUserById(int userId);

    boolean createUser(Users user);

    boolean updateUser(Users user);

    boolean deleteUser(int userId);

    List<Users> searchUsers(String username, String status);
    
    
    //===============================================VINH===============================================
    /**
     * Kiểm tra và nâng cấp hạng mức thành viên dựa trên giá trị đơn hàng mới
     * @param userId ID của người dùng
     * @param orderAmount Giá trị đơn hàng mới
     * @return true nếu hạng mức thành viên được nâng cấp, false nếu không
     */
    boolean checkAndUpgradeMembership(int userId, BigDecimal orderAmount);
    
    /**
     * Lấy tổng giá trị đơn hàng của người dùng trong 12 tháng gần nhất
     * @param userId ID của người dùng
     * @return Tổng giá trị đơn hàng
     */
    BigDecimal getTotalPurchaseAmount(int userId);
}
