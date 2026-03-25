package com.tourismapp.service.user;

import com.tourismapp.entity.Users;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;
import java.util.Optional;

public interface IUserService {

    // KHOA
    List<Users> getAllUsers();

    Optional<Users> findUserByCredentials(String identifier, String password);

    //=============================================== HUY ===============================================
    Users getUserById(int userId);

    boolean createUser(Users user);

    boolean updateUser(Users user);

    boolean deleteUser(int userId);

    List<Users> searchUsers(String username, String status);

    //=============================================== VINH ===============================================
    /**
     * Kiểm tra và nâng cấp hạng mức thành viên dựa trên giá trị đơn hàng mới
     *
     * @param userId ID của người dùng
     * @param orderAmount Giá trị đơn hàng mới
     * @return true nếu hạng mức thành viên được nâng cấp, false nếu không
     */
    boolean checkAndUpgradeMembership(int userId, BigDecimal orderAmount);

    /**
     * Lấy tổng giá trị đơn hàng của người dùng trong 12 tháng gần nhất
     *
     * @param userId ID của người dùng
     * @return Tổng giá trị đơn hàng
     */
    BigDecimal getTotalPurchaseAmount(int userId);

    //=============================================== EXTENSION ===============================================
    /**
     * Tạo người dùng và kiểm tra lỗi nhập liệu theo từng trường
     *
     * @param user Người dùng cần tạo
     * @return Map lỗi với key là tên trường và value là nội dung lỗi
     */
    Map<String, String> createUserWithValidation(Users user);

    /**
     * Kiểm tra username đã tồn tại chưa
     */
    boolean isUsernameExists(String username);

    /**
     * Kiểm tra email đã tồn tại chưa
     */
    boolean isEmailExists(String email);

    /**
     * Kiểm tra số điện thoại đã tồn tại chưa
     */
    boolean isPhoneExists(String phone);

    /**
     * Tạo người dùng trực tiếp không qua validate (insert thuần)
     */
    boolean insertUser(Users user);


    Optional<Users> findUserByUsername(String username);

    Optional<Users> findUserByEmail(String email);

    Optional<Users> findUserByPhone(String phone);

    Map<String, String> validateUserData(Users user, boolean isUpdate);

}
