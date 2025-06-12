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
    
    List< Users> getAllUsers();

    Optional<Users> findUserByCredentials(String username, String email, String password);
}
