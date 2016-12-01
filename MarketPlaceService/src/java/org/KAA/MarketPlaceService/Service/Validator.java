/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.KAA.MarketPlaceService.Service;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

/**
 *
 * @author Ali-pc
 */
public class Validator {
    public static boolean valid;
    public static String user_id_from_token;
    public static String username_from_token;
    public static String fullname_from_token;
    public static boolean IsValid(String token){
        try {
            /* Validate token to the REST API */
            String urlParameter = "token="+token;
            String urlRequest = "http://localhost:8080/IdentService/validate?"+
                    urlParameter.replace(" ","%20");
            URL obj = new URL(urlRequest);
            HttpURLConnection URLConnection = null;
            try {
                URLConnection = (HttpURLConnection) obj.openConnection();
            } catch (IOException ex) {
                Logger.getLogger(MarketPlaceService.class.getName()).log(Level.SEVERE, null, ex);
            }

            /* Parsing */
            BufferedReader br = null;
            try {
                br = new BufferedReader(new InputStreamReader((URLConnection.getInputStream())));
            } catch (IOException ex) {
                Logger.getLogger(MarketPlaceService.class.getName()).log(Level.SEVERE, null, ex);
            }
            StringBuilder sb = new StringBuilder();
            String output;
            try {
                while ((output = br.readLine()) != null) {
                    sb.append(output);
                }
            } catch (IOException ex) {
                Logger.getLogger(MarketPlaceService.class.getName()).log(Level.SEVERE, null, ex);
            }
            JSONParser parser = new JSONParser();
            JSONObject responseJSON = null;
            try {
                responseJSON = (JSONObject)parser.parse(sb.toString());
            } catch (ParseException ex) {
                Logger.getLogger(MarketPlaceService.class.getName()).log(Level.SEVERE, null, ex);
            }
            String status = (String)responseJSON.get("valid_status");
            if (status.equals("valid")){
                valid = true;
            }
            else{
                valid = false;
            }
        } catch (MalformedURLException ex) {
            Logger.getLogger(Validator.class.getName()).log(Level.SEVERE, null, ex);
        }
        return valid;
    }
    
    public static String getUserID(String token){
        try {
            /* Validate token to the REST API */
            String urlParameter = "token="+token;
            String urlRequest = "http://localhost:8080/IdentService/validate?"+
                    urlParameter.replace(" ","%20");
            URL obj = new URL(urlRequest);
            HttpURLConnection URLConnection = null;
            try {
                URLConnection = (HttpURLConnection) obj.openConnection();
            } catch (IOException ex) {
                Logger.getLogger(MarketPlaceService.class.getName()).log(Level.SEVERE, null, ex);
            }

            /* Parsing */
            BufferedReader br = null;
            try {
                br = new BufferedReader(new InputStreamReader((URLConnection.getInputStream())));
            } catch (IOException ex) {
                Logger.getLogger(MarketPlaceService.class.getName()).log(Level.SEVERE, null, ex);
            }
            StringBuilder sb = new StringBuilder();
            String output;
            try {
                while ((output = br.readLine()) != null) {
                    sb.append(output);
                }
            } catch (IOException ex) {
                Logger.getLogger(MarketPlaceService.class.getName()).log(Level.SEVERE, null, ex);
            }
            JSONParser parser = new JSONParser();
            JSONObject responseJSON = null;
            try {
                responseJSON = (JSONObject)parser.parse(sb.toString());
            } catch (ParseException ex) {
                Logger.getLogger(MarketPlaceService.class.getName()).log(Level.SEVERE, null, ex);
            }
            String status = (String)responseJSON.get("valid_status");
            if (status.equals("valid")){
                user_id_from_token = responseJSON.get("user_id").toString();
            }
            else{
                user_id_from_token = null;
            }
        } catch (MalformedURLException ex) {
            Logger.getLogger(Validator.class.getName()).log(Level.SEVERE, null, ex);
        }
        return user_id_from_token;
    }
    
    public static String getUserName(String token){
        try {
            /* Validate token to the REST API */
            String urlParameter = "token="+token;
            String urlRequest = "http://localhost:8080/IdentService/validate?"+
                    urlParameter.replace(" ","%20");
            URL obj = new URL(urlRequest);
            HttpURLConnection URLConnection = null;
            try {
                URLConnection = (HttpURLConnection) obj.openConnection();
            } catch (IOException ex) {
                Logger.getLogger(MarketPlaceService.class.getName()).log(Level.SEVERE, null, ex);
            }

            /* Parsing */
            BufferedReader br = null;
            try {
                br = new BufferedReader(new InputStreamReader((URLConnection.getInputStream())));
            } catch (IOException ex) {
                Logger.getLogger(MarketPlaceService.class.getName()).log(Level.SEVERE, null, ex);
            }
            StringBuilder sb = new StringBuilder();
            String output;
            try {
                while ((output = br.readLine()) != null) {
                    sb.append(output);
                }
            } catch (IOException ex) {
                Logger.getLogger(MarketPlaceService.class.getName()).log(Level.SEVERE, null, ex);
            }
            JSONParser parser = new JSONParser();
            JSONObject responseJSON = null;
            try {
                responseJSON = (JSONObject)parser.parse(sb.toString());
            } catch (ParseException ex) {
                Logger.getLogger(MarketPlaceService.class.getName()).log(Level.SEVERE, null, ex);
            }
            String status = (String)responseJSON.get("valid_status");
            if (status.equals("valid")){
                username_from_token = responseJSON.get("user_name").toString();
            }
            else{
                username_from_token = null;
            }
        } catch (MalformedURLException ex) {
            Logger.getLogger(Validator.class.getName()).log(Level.SEVERE, null, ex);
        }
        return username_from_token;
    }
    
    public static String getFullName(String token){
        try {
            /* Validate token to the REST API */
            String urlParameter = "token="+token;
            String urlRequest = "http://localhost:8080/IdentService/validate?"+
                    urlParameter.replace(" ","%20");
            URL obj = new URL(urlRequest);
            HttpURLConnection URLConnection = null;
            try {
                URLConnection = (HttpURLConnection) obj.openConnection();
            } catch (IOException ex) {
                Logger.getLogger(MarketPlaceService.class.getName()).log(Level.SEVERE, null, ex);
            }

            /* Parsing */
            BufferedReader br = null;
            try {
                br = new BufferedReader(new InputStreamReader((URLConnection.getInputStream())));
            } catch (IOException ex) {
                Logger.getLogger(MarketPlaceService.class.getName()).log(Level.SEVERE, null, ex);
            }
            StringBuilder sb = new StringBuilder();
            String output;
            try {
                while ((output = br.readLine()) != null) {
                    sb.append(output);
                }
            } catch (IOException ex) {
                Logger.getLogger(MarketPlaceService.class.getName()).log(Level.SEVERE, null, ex);
            }
            JSONParser parser = new JSONParser();
            JSONObject responseJSON = null;
            try {
                responseJSON = (JSONObject)parser.parse(sb.toString());
            } catch (ParseException ex) {
                Logger.getLogger(MarketPlaceService.class.getName()).log(Level.SEVERE, null, ex);
            }
            String status = (String)responseJSON.get("valid_status");
            if (status.equals("valid")){
                fullname_from_token = responseJSON.get("fullname").toString();
            }
            else{
                fullname_from_token = null;
            }
        } catch (MalformedURLException ex) {
            Logger.getLogger(Validator.class.getName()).log(Level.SEVERE, null, ex);
        }
        return fullname_from_token;
    }
}
