package com.tourismapp.service.user;

import com.tourismapp.common.MembershipLevel;
import com.tourismapp.repository.DBConnection;
import com.tourismapp.repository.user.UserRepository;
import com.tourismapp.entity.Users;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.*;
import org.springframework.stereotype.Service;
import org.springframework.beans.factory.annotation.Autowired;

/**
 *
 * @author Admin
 */
@Service
public class UserService implements IUserService {

    @Autowired
    private UserRepository UserRepository;

    @Override
    public List<Users> getAllUsers() {
        return UserRepository.getAllUsers();
    }

    @Override
    public Optional<Users> findUserByCredentials(String identifier, String password) {
        Optional<Users> userOpt = UserRepository.findUserByIdentifier(identifier);
        if (userOpt.isPresent()) {
            Users user = userOpt.get();
            String dbPass = user.getPassword();
            if (dbPass != null && dbPass.startsWith("$2a$")) {
                if (org.mindrot.jbcrypt.BCrypt.checkpw(password, dbPass)) {
                    return Optional.of(user);
                }
            } else if (dbPass != null && dbPass.equals(password)) {
                // Auto-migrate plaintext to BCrypt
                String hashed = org.mindrot.jbcrypt.BCrypt.hashpw(password, org.mindrot.jbcrypt.BCrypt.gensalt());
                user.setPassword(hashed);
                UserRepository.updateUser(user);
                return Optional.of(user);
            }
        }
        return Optional.empty();
    }

    @Override
    public Users getUserById(int userId) {
        return UserRepository.getUserById(userId);
    }

    @Override
    public boolean createUser(Users user) {
        // Nếu không validate trước thì vẫn cần check lại membership
        if (!isValidMembershipLevel(user.getMembershipLevel().getId())) {
            throw new IllegalArgumentException("Cấp độ thành viên không tồn tại.");
        }
        if (user.getPassword() != null && !user.getPassword().isEmpty() && !user.getPassword().startsWith("$2a$")) {
            user.setPassword(
                    org.mindrot.jbcrypt.BCrypt.hashpw(user.getPassword(), org.mindrot.jbcrypt.BCrypt.gensalt()));
        }
        return UserRepository.createUser(user);
    }

    // ✅ Hàm validate logic như ở Servlet trước đây
    public Map<String, String> validateUserData(Users user, boolean isUpdate) {
        Map<String, String> errors = new HashMap<>();

        if (user.getUsername() == null || user.getUsername().trim().isEmpty()) {
            errors.put("username", "Tên đăng nhập không được để trống.");
        }

        if (!isUpdate && (user.getPassword() == null || user.getPassword().trim().isEmpty())) {
            errors.put("password", "Mật khẩu không được để trống.");
        }

        if (user.getFullName() == null || user.getFullName().trim().isEmpty()) {
            errors.put("fullName", "Họ tên không được để trống.");
        }

        if (user.getEmail() == null || user.getEmail().trim().isEmpty()) {
            errors.put("email", "Email không được để trống.");
        } else if (!user.getEmail().matches("^[\\w-.]+@([\\w-]+\\.)+[\\w-]{2,4}$")) {
            errors.put("email", "Email không hợp lệ.");
        }

        if (user.getPhone() == null || !user.getPhone().matches("^\\d{10,11}$")) {
            errors.put("phone", "Số điện thoại phải gồm 10 hoặc 11 chữ số.");
        }

        if (user.getAddress() == null || user.getAddress().trim().isEmpty()) {
            errors.put("address", "Địa chỉ không được để trống.");
        }

        if (user.getRole() == null) {
            errors.put("role", "Vai trò là bắt buộc.");
        }

        if (user.getMembershipLevel() == null) {
            user.setMembershipLevel(MembershipLevel.STANDARD);
        }

        return errors;
    }

    @Override
    public Optional<Users> findUserByUsername(String username) {
        return UserRepository.findUserByUsername(username);
    }

    @Override
    public Optional<Users> findUserByEmail(String email) {
        return UserRepository.findUserByEmail(email);
    }

    @Override
    public Optional<Users> findUserByPhone(String phone) {
        return UserRepository.findUserByPhone(phone);
    }

    @Override
    public boolean updateUser(Users user) {
        if (!isValidMembershipLevel(user.getMembershipLevel().getId())) {
            throw new IllegalArgumentException("Cấp độ thành viên không tồn tại: " + user.getMembershipLevel().getId());
        }
        return UserRepository.updateUser(user);
    }

    @Override
    public boolean deleteUser(int userId) {
        return UserRepository.deleteUser(userId);
    }

    @Override
    public List<Users> searchUsers(String username, String status) {
        return UserRepository.searchUsers(username, status);
    }

    @Override
    public BigDecimal getTotalPurchaseAmount(int userId) {
        String sql = "SELECT SUM(total_amount) FROM Orders "
                + "WHERE user_id = ? AND order_date >= DATEADD(MONTH, -12, GETDATE()) "
                + "AND status IN ('completed', 'shipped', 'pending')";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    BigDecimal total = rs.getBigDecimal(1);
                    return total != null ? total : BigDecimal.ZERO;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return BigDecimal.ZERO;
    }

    @Override
    public boolean checkAndUpgradeMembership(int userId, BigDecimal orderAmount) {
        try {
            Users user = getUserById(userId);
            if (user == null) {
                return false;
            }

            MembershipLevel currentLevel = user.getMembershipLevel();
            if (currentLevel == null) {
                currentLevel = MembershipLevel.STANDARD;
            }

            BigDecimal totalPurchase = getTotalPurchaseAmount(userId).add(orderAmount);
            BigDecimal silver = new BigDecimal("30000000");
            BigDecimal gold = new BigDecimal("60000000");
            BigDecimal diamond = new BigDecimal("90000000");

            MembershipLevel newLevel = currentLevel;
            if (totalPurchase.compareTo(diamond) >= 0) {
                newLevel = MembershipLevel.DIAMOND;
            } else if (totalPurchase.compareTo(gold) >= 0) {
                newLevel = MembershipLevel.GOLD;
            } else if (totalPurchase.compareTo(silver) >= 0) {
                newLevel = MembershipLevel.SILVER;
            } else {
                newLevel = MembershipLevel.BRONZE;
            }

            if (newLevel.getId() <= currentLevel.getId()) {
                return false;
            }

            user.setMembershipLevel(newLevel);
            return updateUser(user);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ----------------------
    // ADDITIONAL METHODS
    // ----------------------
    public boolean isUsernameExists(String username) {
        return UserRepository.usernameExists(username);
    }

    public boolean isEmailExists(String email) {
        return UserRepository.emailExists(email);
    }

    public boolean isPhoneExists(String phone) {
        return UserRepository.phoneExists(phone);
    }

    public boolean insertUser(Users user) {
        if (user.getPassword() != null && !user.getPassword().isEmpty() && !user.getPassword().startsWith("$2a$")) {
            user.setPassword(
                    org.mindrot.jbcrypt.BCrypt.hashpw(user.getPassword(), org.mindrot.jbcrypt.BCrypt.gensalt()));
        }
        return UserRepository.createUser(user);
    }

    private boolean isValidMembershipLevel(int levelId) {
        return levelId >= 1 && levelId <= 5;
    }

    // Optional: if still needed
    public Map<String, String> createUserWithValidation(Users user) {
        Map<String, String> errors = new HashMap<>();

        if (user.getUsername() == null || user.getUsername().trim().isEmpty()) {
            errors.put("username", "Tên đăng nhập không được để trống");
        } else if (isUsernameExists(user.getUsername())) {
            errors.put("username", "Tên đăng nhập đã tồn tại");
        }

        if (user.getEmail() == null || user.getEmail().trim().isEmpty()) {
            errors.put("email", "Email không được để trống");
        } else if (isEmailExists(user.getEmail())) {
            errors.put("email", "Email đã tồn tại");
        }

        if (user.getPhone() != null && isPhoneExists(user.getPhone())) {
            errors.put("phone", "Số điện thoại đã tồn tại");
        }

        if (!isValidMembershipLevel(user.getMembershipLevel().getId())) {
            errors.put("membershipLevel", "Cấp độ thành viên không hợp lệ");
        }

        if (errors.isEmpty()) {
            boolean created = insertUser(user);
            if (!created) {
                errors.put("general", "Lỗi hệ thống khi tạo người dùng");
            }
        }

        return errors;
    }
}
