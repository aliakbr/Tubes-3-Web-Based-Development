/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.KAA.MarketPlaceService.Service;

/**
 *
 * @author Ali-pc
 */

import java.sql.Timestamp;
import javax.xml.bind.*;
import javax.xml.bind.annotation.*;

@XmlRootElement(name = "Product")
public class Product {
    @XmlElement(name="status_code",required=true)
    private String status_code;
    
    @XmlElement(name="product_id", required=true)
    private int product_id;
    
    @XmlElement(name="name", required=true)
    private String name;
    
    @XmlElement(name="price", required=true)
    private long price;
    
    @XmlElement(name="description", required=true)
    private String description;
    
    @XmlElement(name="image", required=true)
    private String image;
    
    @XmlElement(name="date", required=true)
    private TS date;
    
    @XmlElement(name="user_id", required=true)
    private int user_id;
   
    @XmlElement(name="username", required=true)
    private String username;
    
   public Product(){
       
   }
   
   public Product(String status_code){
       this.status_code = status_code;
   }
    
    public Product(int prod_id, String name, long price, String description, 
            String image, Timestamp date, int user_id, String username){
        this.product_id = prod_id;
        this.name = name;
        this.price = price;
        this.description = description;
        this.image = image;
        this.date = new TS(date);
        this.user_id = user_id;
        this.username = username;
        this.status_code="OK";
    }
}
