/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.KAA.MarketPlaceService.Service;

import java.sql.Timestamp;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

/**
 *
 * @author Ali-pc
 */
@XmlRootElement(name = "Purchase")
public class Purchase {
    @XmlElement(name = "purchase_id",required=true)
    private int purchase_id;
    
    @XmlElement(name = "product_name",required=true)
    private String product_name;
    
    @XmlElement(name = "product_price",required=true)
    private long product_price;
    
    @XmlElement(name = "quantity",required=true)
    private int quantity;
    
    @XmlElement(name = "product_image",required=true)
    private String product_image;
    
    @XmlElement(name = "seller_id", required=true)
    private int seller_id;
    
    @XmlElement(name = "buyer_id", required=true)
    private int buyer_id;
    
    @XmlElement(name = "product_id", required=true)
    private int product_id;
    
    @XmlElement(name = "buyer_name", required=true)
    private String buyer_name;
    
    @XmlElement(name = "buyer_address", required=true)
    private String buyer_address;
    
    @XmlElement(name = "postal_code", required=true)
    private int postal_code;
    
    @XmlElement(name = "phonenumber", required=true)
    private String phonenumber;
    
    @XmlElement(name = "date", required=true)
    private TS date;
    
    public Purchase(){
        
    }
    
    public Purchase(int purchase_id, String product_name, long product_price, int quantity, String product_image, int seller_id, int buyer_id, String buyer_name, int product_id, String buyer_address, int postal_code, String phonenumber, Timestamp date) {
        this.purchase_id = purchase_id;
        this.product_name = product_name;
        this.product_price = product_price;
        this.quantity = quantity;
        this.product_image = product_image;
        this.seller_id = seller_id;
        this.buyer_id = buyer_id;
        this.buyer_name = buyer_name;
        this.product_id = product_id;
        this.buyer_address = buyer_address;
        this.postal_code = postal_code;
        this.phonenumber = phonenumber;
        this.date = new TS(date);
    }

    public int getPurchaseId (){
        return purchase_id;
    }

    public String getProductName(){
        return product_name;
    }

    public long getProductPrice(){
        return product_price;
    }

    public int getQuantity(){
        return quantity;
    }
    
    public String getProductImage(){
        return product_image;
    }

    public int getSellerId(){
        return seller_id;
    }

    public int getBuyerId(){
        return buyer_id;
    }

    public int getProductId(){
        return product_id;
    }

    public String getBuyerName(){
        return buyer_name;
    }


    public String getBuyerAddress(){
        return buyer_address;
    }

    public int getPostalCode(){
        return postal_code;
    }

    public String getPhoneNumber(){
        return phonenumber;
    }

    public TS getDate(){
        return date;
    }
    
}
