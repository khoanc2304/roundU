/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.tourismapp.dao.user;

import com.tourismapp.model.Users;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

/**
 *
 * @author Admin
 */
public interface IUserDAO {
    
    Users mapUser(ResultSet rs) throws SQLException;

    List< Users> getAllUsers();
    
}
