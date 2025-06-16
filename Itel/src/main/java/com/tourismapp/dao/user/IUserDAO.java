/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.tourismapp.dao.user;

import com.sun.tools.xjc.reader.xmlschema.bindinfo.BIConversion.User;
import com.tourismapp.model.Users;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

/**
 *
 * @author Admin
 */
public interface IUserDAO {
    
    Users mapUser(ResultSet rs) throws SQLException;

    List< Users> getAllUsers();

    Optional<Users> findUserByCredentials(String username, String email, String password);
    
    
    // HUY
    Users getUserById(int userId);

    boolean createUser(Users user);

    boolean updateUser(Users user);

    boolean deleteUser(int userId);

    List<Users> searchUsers(String username, String status);

}
