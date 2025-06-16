/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.tourismapp.service.user;

import com.tourismapp.model.Users;
import java.util.List;
import java.util.Optional;

/**
 *
 * @author Admin
 */
public interface IUserService {
    // KHOA
    List< Users> getAllUsers();

    Optional<Users> findUserByCredentials(String username, String email, String password);
    
    
    // HUY
    Users getUserById(int userId);

    boolean createUser(Users user);

    boolean updateUser(Users user);

    boolean deleteUser(int userId);

    List<Users> searchUsers(String username, String status);
}
