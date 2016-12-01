/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.saleproject.KAA;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.logging.Level;
import java.util.logging.Logger;
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
            String urlRequest = APIURL + URLParameter.replace(" ", "%20");
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
    
    public void executePost(){
        try {
            URL obj = new URL(APIURL);
            HttpURLConnection con = (HttpURLConnection) obj.openConnection();
            con.setDoOutput( true );
            con.setRequestMethod( "POST" );
            DataOutputStream wr = new DataOutputStream(con.getOutputStream());
            wr.writeBytes(URLParameter);
            wr.flush();
            wr.close();
            con.setReadTimeout(15*1000);
            con.connect();
            BufferedReader br = new BufferedReader(new InputStreamReader((con.getInputStream())));
            StringBuilder sb = new StringBuilder();
            String output1;
            while ((output1 = br.readLine()) != null) {
                sb.append(output1);
            }
            
            /* Parsing */
            JSONParser parser = new JSONParser();
            output = (JSONObject)parser.parse(sb.toString());
        } catch(Exception e){
            e.printStackTrace();
        }
}
    
    public JSONObject getOutput(){
        return output;
    }
}
