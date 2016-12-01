/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.KAA.MarketPlaceService.Service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

/**
 *
 * @author Ali-pc
 */
public class RestAPI_consumer {
    private JSONObject output;
    private String APIURL;
    private String URLParameter;
    
    public RestAPI_consumer(String URL, String URLParameter){
        output = null;
        this.APIURL = URL;
        this.URLParameter = URLParameter;
    }
    
    public void execute(){
        try{
            /* Consuming API using GET method */
            String urlRequest = APIURL + URLParameter;
            URL obj = new URL(urlRequest);
            HttpURLConnection con = (HttpURLConnection) obj.openConnection();
            BufferedReader br = new BufferedReader(new InputStreamReader((con.getInputStream())));
            StringBuilder sb = new StringBuilder();
            String output1;
            while ((output1 = br.readLine()) != null) {
                sb.append(output1);
            }

             /* Parsing */
            JSONParser parser = new JSONParser();
            output = (JSONObject)parser.parse(sb.toString());
        }
        catch(Exception e){
            e.printStackTrace();
        }
    }
    
    public JSONObject getOutput(){
        return output;
    }
}
