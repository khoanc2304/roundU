package com.tourismapp.dao;

import com.tourismapp.utils.ErrDialog;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DBConnection {

    public static String driverName = "com.mysql.cj.jdbc.Driver";
    public static String dbURL = "jdbc:mysql://localhost:3306/Itel_Shop?useSSL=false&serverTimezone=UTC";
    public static String userDB = "root"; // đổi nếu cần
    public static String passDB = "khoa7619";  // đổi theo MySQL của bạn

    public static Connection getConnection() {
        Connection con = null;
        try {
            Class.forName(driverName);
            con = DriverManager.getConnection(dbURL, userDB, passDB);
            return con;
        } catch (Exception ex) {
            Logger.getLogger(DBConnection.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    public static void main(String[] args) {
        try (Connection con = getConnection()) {
            if (con != null) {
                ErrDialog.showError("Connect to MySQL Success");
            } else {
                ErrDialog.showError("Connect failed");
            }
        } catch (SQLException ex) {
            Logger.getLogger(DBConnection.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}