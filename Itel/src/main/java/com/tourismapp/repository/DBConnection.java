package com.tourismapp.repository;

import com.tourismapp.utils.ErrDialog;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DBConnection {

    public static String driverName;
    public static String dbURL;
    public static String userDB;
    public static String passDB;

    static {
        try (java.io.InputStream input = DBConnection.class.getClassLoader().getResourceAsStream("application.properties")) {
            java.util.Properties prop = new java.util.Properties();
            if (input != null) {
                prop.load(input);
                driverName = prop.getProperty("db.driver");
                dbURL = prop.getProperty("db.url");
                userDB = prop.getProperty("db.username");
                passDB = prop.getProperty("db.password");
            } else {
                Logger.getLogger(DBConnection.class.getName()).log(Level.SEVERE, "application.properties not found!");
            }
        } catch (java.io.IOException ex) {
            Logger.getLogger(DBConnection.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

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