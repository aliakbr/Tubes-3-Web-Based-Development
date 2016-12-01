/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.IdentService;

import java.sql.*;

/**
 *
 * @author Ali-pc
 */
public class DBAccount {
    private static final String url = "jdbc:mysql://localhost:3306/accountdb";    
    private static final String driverName = "com.mysql.jdbc.Driver";   
    private static final String username = "root";   
    private static final String password = "";
    private static Connection con;

    public static Connection getConnection() {
        try {
            Class.forName(driverName);
            try {
                con = DriverManager.getConnection(url, username, password);
            } catch (SQLException ex) {
                // log an exception. fro example:
                System.out.println("Failed to create the database connection."); 
            }
        } catch (ClassNotFoundException ex) {
            // log an exception. for example:
            System.out.println("Driver not found."); 
        }
        return con;
    }
}
