/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.tourismapp.service.user;

import com.tourismapp.dao.user.IUserDAO;
import com.tourismapp.dao.user.UserDAO;
import com.tourismapp.model.Users;
import java.util.List;
import java.util.Optional;

/**
 *
 * @author Admin
 */
public class UserService implements IUserService {

    private final IUserDAO userDAO = new UserDAO();

    @Override
    public List<Users> getAllUsers() {
        return userDAO.getAllUsers();
    }

    @Override
    public Optional<Users> findUserByCredentials(String username, String email, String password) {
        return userDAO.findUserByCredentials(username, email, password);
    }

}
