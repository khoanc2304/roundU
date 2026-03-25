package com.tourismapp.repository.user;

import com.tourismapp.common.MembershipLevel;
import com.tourismapp.common.Status;
import com.tourismapp.common.UserRole;
import com.tourismapp.entity.Users;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Repository
public class UserRepository {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    private static final String GET_ALL_USERS = "SELECT * FROM Users;";

    private final RowMapper<Users> userRowMapper = (rs, rowNum) -> mapResultSetToUser(rs);

    public Users mapUser(ResultSet rs) throws SQLException {
        return mapResultSetToUser(rs);
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
            throw new RuntimeException("Vai trò không hợp lệ: " + rs.getString("role"));
        }
        try {
            int membershipLevelId = rs.getInt("membership_level_id");
            user.setMembershipLevel(membershipLevelId != 0 ? MembershipLevel.fromId(membershipLevelId) : null);
        } catch (IllegalArgumentException e) {
            throw new RuntimeException("Cấp độ thành viên không hợp lệ: " + rs.getInt("membership_level_id"));
        }
        try {
            user.setStatus(Status.valueOf(rs.getString("status").toUpperCase()));
        } catch (IllegalArgumentException e) {
            throw new RuntimeException("Trạng thái không hợp lệ: " + rs.getString("status"));
        }
        
        Timestamp created = rs.getTimestamp("created_at");
        if (created != null) user.setCreatedAt(created.toLocalDateTime());
        
        Timestamp updated = rs.getTimestamp("updated_at");
        if (updated != null) user.setUpdatedAt(updated.toLocalDateTime());
        
        return user;
    }

    public Optional<Users> findUserByIdentifier(String identifier) {
        String sql = "SELECT * FROM Users WHERE username = ? OR email = ? OR phone = ?";
        List<Users> users = jdbcTemplate.query(sql, userRowMapper, identifier, identifier, identifier);
        return users.isEmpty() ? Optional.empty() : Optional.of(users.get(0));
    }

    public List<Users> selectAllUsers() {
        return jdbcTemplate.query(GET_ALL_USERS, userRowMapper);
    }

    public List<Users> getAllUsers() {
        return selectAllUsers();
    }

    public Users getUserById(int userId) {
        String sql = "SELECT * FROM Users WHERE user_id = ?";
        List<Users> users = jdbcTemplate.query(sql, userRowMapper, userId);
        return users.isEmpty() ? null : users.get(0);
    }

    public boolean createUser(Users user) {
        String checkSql = "SELECT COUNT(*) FROM Users WHERE username = ? OR email = ?";
        Integer count = jdbcTemplate.queryForObject(checkSql, Integer.class, user.getUsername(), user.getEmail());
        if (count != null && count > 0) {
            return false;
        }

        String sql = "INSERT INTO Users (username, password, fullName, email, phone, address, role, membership_level_id, status, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        int rows = jdbcTemplate.update(sql, 
                user.getUsername(),
                user.getPassword(),
                user.getFullName(),
                user.getEmail(),
                user.getPhone(),
                user.getAddress(),
                user.getRole().getValue(),
                user.getMembershipLevel() != null ? user.getMembershipLevel().getId() : null,
                user.getStatus().getValue(),
                user.getCreatedAt() != null ? Timestamp.valueOf(user.getCreatedAt()) : Timestamp.valueOf(LocalDateTime.now()),
                user.getUpdatedAt() != null ? Timestamp.valueOf(user.getUpdatedAt()) : Timestamp.valueOf(LocalDateTime.now())
        );
        return rows > 0;
    }

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
        // Use CURRENT_TIMESTAMP compatible with SQL Server/MySQL depending on what they use
        updates.add("updated_at=CURRENT_TIMESTAMP");

        if (updates.isEmpty()) {
            return false;
        }

        sql.append(String.join(", ", updates));
        sql.append(" WHERE user_id=?");
        params.add(user.getUserId());

        int rows = jdbcTemplate.update(sql.toString(), params.toArray());
        return rows > 0;
    }

    public Optional<Users> findUserByUsername(String username) {
        String sql = "SELECT * FROM Users WHERE username = ?";
        List<Users> users = jdbcTemplate.query(sql, userRowMapper, username);
        return users.isEmpty() ? Optional.empty() : Optional.of(users.get(0));
    }

    public Optional<Users> findUserByEmail(String email) {
        String sql = "SELECT * FROM Users WHERE email = ?";
        List<Users> users = jdbcTemplate.query(sql, userRowMapper, email);
        return users.isEmpty() ? Optional.empty() : Optional.of(users.get(0));
    }

    public Optional<Users> findUserByPhone(String phone) {
        String sql = "SELECT * FROM Users WHERE phone = ?";
        List<Users> users = jdbcTemplate.query(sql, userRowMapper, phone);
        return users.isEmpty() ? Optional.empty() : Optional.of(users.get(0));
    }

    public boolean usernameExists(String username) {
        String sql = "SELECT COUNT(*) FROM Users WHERE username = ?";
        Integer count = jdbcTemplate.queryForObject(sql, Integer.class, username);
        return count != null && count > 0;
    }

    public boolean emailExists(String email) {
        String sql = "SELECT COUNT(*) FROM Users WHERE email = ?";
        Integer count = jdbcTemplate.queryForObject(sql, Integer.class, email);
        return count != null && count > 0;
    }

    public boolean phoneExists(String phone) {
        String sql = "SELECT COUNT(*) FROM Users WHERE phone = ?";
        Integer count = jdbcTemplate.queryForObject(sql, Integer.class, phone);
        return count != null && count > 0;
    }

    public boolean deleteUser(int userId) {
        String sql = "UPDATE Users SET status = 'inactive', updated_at = CURRENT_TIMESTAMP WHERE user_id = ?";
        int rows = jdbcTemplate.update(sql, userId);
        return rows > 0;
    }

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

        return jdbcTemplate.query(sql.toString(), userRowMapper, params.toArray());
    }
}
