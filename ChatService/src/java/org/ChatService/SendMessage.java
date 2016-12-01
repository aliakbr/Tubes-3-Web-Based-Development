/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.ChatService;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.json.simple.JSONObject;
/**
 *
 * @author khrs
 */
@WebServlet(name = "SendMessage", urlPatterns = {"/SendMessage"})
public class SendMessage extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Connection conn = DBChatToken.getConnection();
            if (conn != null){
                Statement stmt = conn.createStatement();
                String sql;
                String username = request.getParameter("username");
                String usernamereceiver = request.getParameter("usernamereceiver");
                String message = request.getParameter("text");
                sql = "SELECT * FROM chattoken WHERE username=\""+usernamereceiver+"\";";
                ResultSet rs = stmt.executeQuery(sql);
                if(rs.next()){
                    JSONObject json = new JSONObject();
                    JSONObject json1 = new JSONObject();
                    String chattoken = rs.getString("chattoken");
                    /* Format json
                    {data : {
                        username : xx
                        message : xx
                    },
                    to : xx 
                    }*/
                    json.put("to", chattoken);
                    json1.put("name",username);
                    json1.put("to",usernamereceiver);
                    json1.put("text",message);
                    json.put("data",json1);
                    System.out.println("Masuk sini "+json.toString());
                    String url = "https://fcm.googleapis.com/fcm/send";
                    URL obj = new URL(url);
                    HttpURLConnection con = (HttpURLConnection) obj.openConnection();
                    con.setRequestMethod("POST");
                    con.setDoOutput(true);
                    con.setRequestProperty("Content-Type","application/json");
                    con.setRequestProperty("Authorization","key=AIzaSyBkDljDoMLYg9F-HZOxVdsVryEScwF3DWE");
                    DataOutputStream wr = new DataOutputStream(con.getOutputStream());
                    String urlParameters = json.toString();
                    wr.writeBytes(urlParameters);
                    wr.flush();
                    wr.close();
                    con.setReadTimeout(15*1000);
                    con.connect();
                    BufferedReader br = new BufferedReader(new InputStreamReader((con.getInputStream())));
                    StringBuilder sb = new StringBuilder();
                    String output;
                    while ((output = br.readLine()) != null) {
                        sb.append(output);
                    }
                    PrintWriter out = response.getWriter();
                    out.println(sb);
                }
            }
            else{
                try (PrintWriter out = response.getWriter()) {
                    /* TODO output your page here. You may use following sample code. */
                    out.println("<!DOCTYPE html>");
                    out.println("<html>");
                    out.println("<head>");
                    out.println("<title>Servlet login</title>");            
                    out.println("</head>");
                    out.println("<body>");
                    out.println("<h1>Connection NULL!!</h1>");
                    out.println("</body>");
                    out.println("</html>");
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(TokenSaver.class.getName()).log(Level.SEVERE, null, ex);
        }

    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
