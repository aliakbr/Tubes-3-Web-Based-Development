/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.KAA.MarketPlaceService.Service;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Setting Database untuk 
 * @author Ali-pc
 */
public class DBMarketPlace {
    private static final String url = "jdbc:mysql://127.0.0.1:3306/marketplacedb";    
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
