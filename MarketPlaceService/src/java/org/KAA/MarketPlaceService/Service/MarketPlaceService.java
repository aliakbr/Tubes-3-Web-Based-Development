/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.KAA.MarketPlaceService.Service;

import java.io.FileOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.jws.WebService;
import javax.jws.WebMethod;
import javax.jws.WebParam;
import javax.jws.WebResult;
import org.json.simple.*;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import java.util.Date;
import java.util.Calendar;
import java.sql.Timestamp;
import javax.jws.Oneway;

/**
 *
 * @author Ali-pc
 */
@WebService(serviceName = "MarketPlaceService")
public class MarketPlaceService {
    /* Connecting to database */
    Connection conn = DBMarketPlace.getConnection();

    /**
     * Web service operation
     */
    @WebMethod(operationName = "search_product")
    @WebResult(name = "Product")
    public ArrayList<Product> search_product(@WebParam(name = "query") String query, 
            @WebParam(name = "token") String token, 
            @WebParam(name = "choice") int choice) {
        
        ArrayList<Product> responseObject = null;
        boolean valid = Validator.IsValid(token);
        if (valid){
            try{
                Statement stmt = conn.createStatement();
                String sql;
                if (choice == 0){
                    sql = "select distinct * from product where "
                            + "product.name like \"%"+query+"%\" order by date desc";
                }
                else{
                    sql = "select distinct * from product where "
                            + "product.username like \"%"+query+"%\" OR  product.fullname like \"%"+query+"%\" order by date desc";
                }
                ResultSet rs = stmt.executeQuery(sql);
                responseObject = new ArrayList<Product>();
                while (rs.next()){
                    responseObject.add(new Product(
                            rs.getInt("product_id"),
                            rs.getString("name"),
                            rs.getLong("price"),
                            rs.getString("description"),
                            rs.getString("image"),
                            rs.getTimestamp("date"),
                            rs.getInt("user_id"),
                            rs.getString("username")
                    ));
                }
            }
            catch(SQLException ex){
            }
            return responseObject;
        }
        return responseObject;
    }

    /**
     * Web service operation
     */
    @WebMethod(operationName = "retrieve_all_product")
    @WebResult(name = "Product")
    public ArrayList<Product> retrieve_all_product(@WebParam(name = "token") String token) {
        ArrayList<Product> responseObject = new ArrayList<Product>();
        if (Validator.IsValid(token)){
            try {
                String query = "select distinct * from product order by date desc";
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(query);
                while (rs.next()){
                    responseObject.add(new Product(
                            rs.getInt("product_id"),
                            rs.getString("name"),
                            rs.getLong("price"),
                            rs.getString("description"),
                            rs.getString("image"),
                            rs.getTimestamp("date"),
                            rs.getInt("user_id"),
                            rs.getString("username")
                    ));
                }
            } catch (SQLException ex) {
                Logger.getLogger(MarketPlaceService.class.getName()).log(Level.SEVERE, null, ex);
            }
            return responseObject;
        } else {
            return null;
        }
    }

    /**
     * Web service operation
     */
    @WebMethod(operationName = "get_product")
    public Product get_product(@WebParam(name = "token") String token, 
            @WebParam(name = "product_id") String product_id) {
        //TODO write your implementation code here:
        Product responseObject = new Product();
        String user_id = Validator.getUserID(token);
        try {
            String query = "select * from product where product_id="+product_id
                    + " and user_id="+user_id;
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(query);
            if (rs.next()){
                responseObject = new Product(
                        rs.getInt("product_id"),
                        rs.getString("name"),
                        rs.getLong("price"),
                        rs.getString("description"),
                        rs.getString("image"),
                        rs.getTimestamp("date"),
                        rs.getInt("user_id"),
                        rs.getString("username")
                );
            }
        } catch (SQLException ex) {
            Logger.getLogger(MarketPlaceService.class.getName()).log(Level.SEVERE, null, ex);
        }
        return responseObject;
    }
    
    /**
     * Web service operation
     */

    @WebMethod(operationName = "add_edit_product")
    @WebResult(name = "ProcedureStatus")
    public ProcedureStatus add_edit_product(@WebParam(name = "name") String name, 
            @WebParam(name = "description") String description,
            @WebParam(name = "price") String price,
            @WebParam(name = "image") String image,
            @WebParam(name = "option") String option,
            @WebParam(name = "product_id") String product_id,
            @WebParam(name = "token") String token) {
        //TODO write your implementation code here:
        ProcedureStatus output = new ProcedureStatus();
        if (Validator.IsValid(token)){
            String user_id = Validator.getUserID(token);
            String username = Validator.getUserName(token);
            String fullname = Validator.getFullName(token);
            
            try {
                String query = "";
                if(option.equals("0")){//add product
                    Calendar cal = Calendar.getInstance();
                    Date dt = cal.getTime();
                    Timestamp ts = new Timestamp(dt.getTime());
                    image = "product_img/"+ image;
                    query = "insert into product (name,price,description,image,date,"
                            + "user_id,username,fullname)values (\""+name
                            +"\",\""+price+"\",\""+description+"\",\""+image
                            +"\",\""+ts+"\",\""+user_id+"\",\""+username
                            +"\",\""+fullname+"\")";
                }
                else if(option.equals("1")){ //edit product
                    query = "update product set name=\""+name+"\",price=\""+price
                            +"\",description=\""+description
                            +"\" WHERE product_id="+product_id
                            + " and user_id="+user_id;
                }
                Statement stmt = conn.createStatement();
                stmt.executeUpdate(query);
                output  = new ProcedureStatus("OK");
            } catch (SQLException ex) {
                Logger.getLogger(MarketPlaceService.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        else{
            output = new ProcedureStatus("EXPIRED");
        }
        return output;
    }

    /**
     * Web service operation
     */
    @WebMethod(operationName = "getLikes")
    public int getLikes(@WebParam(name = "pid") int pid) {
        //TODO write your implementation code here:
        int res = 0;
        try {
            String query = "select count(likes.user_id) as countlike from likes where likes.product_id = " + pid;
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(query);
            
            rs.next();
            res = rs.getInt("countlike");
        } catch (SQLException ex) {
            Logger.getLogger(MarketPlaceService.class.getName()).log(Level.SEVERE, null, ex);
        }
        return res;
    }

    /**
     * Web service operation
     */
    @WebMethod(operationName = "get_sales_purchases")
    @WebResult(name = "Purchase")
    public ArrayList<Purchase> get_sales_purchases(
            @WebParam(name = "token") String token, 
            @WebParam(name = "option") int option) { //0 untuk sales, 1 untuk purchases
        
        if (Validator.IsValid(token)){
            String query = "";
            ArrayList<Purchase> responseObject = new ArrayList<Purchase>();
            try{
                Statement stmt = conn.createStatement();

                //cari user id dari REST API
                int user_id = Integer.parseInt(Validator.getUserID(token));

                if (option == 0){ //sales
                    query += "select distinct * from purchase where seller_id= "+user_id
                        + " order by date desc";
                }
                else{
                    query += "select distinct * from purchase where buyer_id= "+user_id
                        + " order by date desc";
                }
                ResultSet rs = stmt.executeQuery(query);
                while (rs.next()){
                    responseObject.add(new Purchase(
                            rs.getInt("purchase_id"),
                            rs.getString("product_name"),
                            rs.getLong("product_price"),
                            rs.getInt("quantity"),
                            rs.getString("product_image"),
                            rs.getInt("seller_id"),
                            rs.getInt("buyer_id"),
                            rs.getString("buyer_name"),
                            rs.getInt("product_id"),                          
                            rs.getString("buyer_address"),
                            rs.getInt("postal_code"),
                            rs.getString("phone_number"),
                            rs.getTimestamp("date")
                    ));
                }
            }
            catch(SQLException ex){
                Logger.getLogger(MarketPlaceService.class.getName()).log(Level.SEVERE, null, ex);
            }
            return responseObject;
        } else {
            return null;
        }
    }

    @WebMethod(operationName = "getPurchases")
    public int getPurchases(@WebParam(name = "pid") int pid) {
        //TODO write your implementation code here:
        int res = 0;
        try {
            String query = "select count(purchase_id) as purchases from purchase where product_id = " + pid;
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(query);
            
            rs.next();
            res = rs.getInt("purchases");
        } catch (SQLException ex) {
            Logger.getLogger(MarketPlaceService.class.getName()).log(Level.SEVERE, null, ex);
        }
        return res;
    }

    /**
     * Web service operation
     */
    @WebMethod(operationName = "isLiked")
    public java.lang.String isLiked(@WebParam(name = "token") String token, @WebParam(name = "pid") int pid) {
        //TODO write your implementation code here:
        int res = 0;
        try {
            String uid = Validator.getUserID(token);
            String query = "SELECT * FROM likes WHERE user_id = " + uid + " AND product_id = " + pid;
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(query);
            
            if (rs.next()){
                return "<a href=\"http://localhost:8080/KAA-JSP/catalog.jsp?token=" + token + "&like=no&product_id=" + pid + "\"><p id=\"liked\">LIKED   </p></a>";
            } else {
                return "<a href=\"http://localhost:8080/KAA-JSP/catalog.jsp?token=" + token + "&like=yes&product_id=" + pid + "\"><p id=\"like\">LIKE   </p></a>";
            }
        } catch (SQLException ex) {
            Logger.getLogger(MarketPlaceService.class.getName()).log(Level.SEVERE, null, ex);
        }
        return "";
    }

    /**
     * Web service operation
     */
    @WebMethod(operationName = "buy")
    public ProcedureStatus buy(@WebParam(name = "token") String token, 
            @WebParam(name = "product_id") String product_id, 
            @WebParam(name = "quantity") String quantity, 
            @WebParam(name = "cosignee") String cosignee, 
            @WebParam(name = "fulladdress") String fulladdress, 
            @WebParam(name = "postalcode") String postalcode, 
            @WebParam(name = "phone_number") String phone_number) {
        //TODO write your implementation code here:
        ProcedureStatus output = new ProcedureStatus();
        if (Validator.IsValid(token)){
            String user_id = Validator.getUserID(token);
            try {
                String query = "select * from product where product_id="+product_id;
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(query);
                String product_price="";
                String product_name="";
                String description="";
                String image="";
                String seller_id="";
                if (rs.next()){
                        product_name = rs.getString("name");
                        product_price= rs.getString("price");
                        description = rs.getString("description");
                        image = rs.getString("image");
                        seller_id = rs.getString("user_id");
                }
                query =  "INSERT INTO purchase(product_name, product_price, "
                    + "quantity, product_image, seller_id, buyer_id, "
                    + "product_id, buyer_name, buyer_address, "
                    + "postal_code, phone_number)"
                    + "VALUES (\""+product_name+"\",\""+product_price+"\",\""+quantity
                    + "\",\""+image+"\",\""+seller_id+"\",\""+user_id
                    + "\",\""+product_id+"\",\""+cosignee+"\",\""+ fulladdress
                    +"\",\""+postalcode+"\",\""+phone_number+"\")";
                stmt = conn.createStatement();
                stmt.executeUpdate(query);
                output  = new ProcedureStatus("OK");
            } catch (SQLException ex) {
                Logger.getLogger(MarketPlaceService.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        else{
            output = new ProcedureStatus("EXPIRED");
        }
        return output;
    }

    /**
     * Web service operation
     */
    @WebMethod(operationName = "getYourProduct")
    public ArrayList<Product> getYourProduct(@WebParam(name = "token") String token) {
        //TODO write your implementation code here:
        ArrayList<Product> responseObject = new ArrayList<Product>();
        if (Validator.IsValid(token)){
            String user_id = Validator.getUserID(token);
            try {
                String query = "select distinct * from product where user_id = " + user_id + " order by date desc";
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(query);
                while (rs.next()){
                    responseObject.add( new Product(
                            rs.getInt("product_id"),
                            rs.getString("name"),
                            rs.getLong("price"),
                            rs.getString("description"),
                            rs.getString("image"),
                            rs.getTimestamp("date"),
                            rs.getInt("user_id"),
                            rs.getString("username")
                        )
                    );
                }
            } catch (SQLException ex) {
                Logger.getLogger(MarketPlaceService.class.getName()).log(Level.SEVERE, null, ex);
            }
            return responseObject;
        } else {
            return null;
        }
    }

    /**
     * Web service operation
     */
    @WebMethod(operationName = "delete_product")
    public ProcedureStatus delete_product(@WebParam(name = "token") String token, 
            @WebParam(name = "product_id") String product_id) {
        //TODO write your implementation code here:
       ProcedureStatus output = new ProcedureStatus();
        if (Validator.IsValid(token)){
            String user_id = Validator.getUserID(token);
            try {
                String query = "delete from product where product_id="+product_id;
                Statement stmt = conn.createStatement();
                stmt = conn.createStatement();
                stmt.executeUpdate(query);
                output  = new ProcedureStatus("OK");
            } catch (SQLException ex) {
                Logger.getLogger(MarketPlaceService.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        else{
            output = new ProcedureStatus("EXPIRED");
        }
        return output;
    }

    /**
     * Web service operation
     */
    @WebMethod(operationName = "processLike")
    public ProcedureStatus processLike(@WebParam(name = "token") String token, @WebParam(name = "product_id") String product_id, @WebParam(name = "like") boolean like) {
        ProcedureStatus output = new ProcedureStatus();
        if (Validator.IsValid(token)){
            String user_id = Validator.getUserID(token);
            try {
                String query = "";
                if (like){
                    query = "INSERT INTO `likes`(`user_id`, `product_id`) VALUES ('" + user_id + "', '" + product_id + "')";
                } else {
                    query = "DELETE FROM `likes` WHERE user_id = " + user_id + " AND product_id = " + product_id + "";
                }    
                Statement stmt = conn.createStatement();
                stmt.executeUpdate(query);
                output  = new ProcedureStatus("OK");
            } catch (SQLException ex) {
                Logger.getLogger(MarketPlaceService.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        else{
            output = new ProcedureStatus("EXPIRED");
        }
        return output;
    }
}
