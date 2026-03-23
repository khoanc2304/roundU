package com.tourismapp.dao.user;

import com.tourismapp.model.Users;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

public interface IUserDAO {

    Users mapUser(ResultSet rs) throws SQLException;

    List<Users> getAllUsers();

    Optional<Users> findUserByCredentials(String identifier, String password);

    // HUY
    Users getUserById(int userId);

    boolean createUser(Users user);

    boolean updateUser(Users user);

    boolean deleteUser(int userId);

    List<Users> searchUsers(String username, String status);

    // EXTENSION - bổ sung để kiểm tra từng field trùng lặp
    boolean usernameExists(String username);

    boolean emailExists(String email);

    boolean phoneExists(String phone);

    Optional<Users> findUserByUsername(String username);

    Optional<Users> findUserByEmail(String email);

    Optional<Users> findUserByPhone(String phone);

}
