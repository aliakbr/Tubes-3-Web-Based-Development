/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.IdentService;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.Calendar;
import java.util.Date;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.json.simple.*;

/**
 * Memvalidasi token dengan menggunakan GET METHOD
 * Memberikan status OK jika token ada
 * Memberikan status FAILED jika token tidak ada
 * Memberikan valid_status OK jika valid
 * Memberikan valid_status EXPIRED jika expired
 * Memberikan valid_status INVALID jika tidak ada token yang sesuai
 * @author Ali-pc
 */
public class validate extends HttpServlet {

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
        JSONObject json = new JSONObject();
        PrintWriter out = response.getWriter();
        if (request.getParameter("token") != null){
            json.put("status","OK");
            String token = request.getParameter("token");
            
            /* Checking the retrieved token */
            Connection conn = DBAccount.getConnection();
            try {
                Statement stmt = conn.createStatement();
                String sql = "SELECT * FROM token NATURAL JOIN account "
                        + "WHERE token=\""+token+"\"";
                ResultSet rs = stmt.executeQuery(sql);
                /* Validating the token */
                if (rs.next()){
                    int user_id = rs.getInt("user_id");
                    Calendar cal = Calendar.getInstance();
                    Date dt = cal.getTime();
                    Timestamp expire = rs.getTimestamp("expire_time");
                    Timestamp ts = new Timestamp(dt.getTime());
                    String user_name = rs.getString("username");
                    String fullname = rs.getString("fullname");
                    /* Check wether the token is expired or not */
                    if (!ts.after(expire)){
                        Calendar cal1 = Calendar.getInstance();
                        int hours = cal1.get(Calendar.HOUR_OF_DAY);
                        int tanggal = cal1.get(Calendar.DATE);
                        if(hours != 23){
                            cal.set(Calendar.HOUR_OF_DAY, hours+1);
                        }
                        else{
                            cal.set(Calendar.DATE, tanggal+1);
                            cal.set(Calendar.HOUR_OF_DAY, 0);
                        }
                        Date dt1 = cal.getTime();
                        //token akan expire dalam 60 menit
                        Timestamp ts1 = new Timestamp(dt1.getTime());
                        String sql2 = "UPDATE token SET expire_time=\"" + ts1 + "\" WHERE token=\"" + token + "\"";
                        Statement stmt2 = conn.createStatement();
                        stmt2.executeUpdate(sql2);
                        json.put("status","OK");
                        json.put("valid_status","valid");
                        json.put("user_id",user_id);
                        json.put("user_name",user_name);
                        json.put("fullname",fullname);
                        out.print(json.toString());
                    }
                    else{
                        String sql1 = "DELETE FROM token WHERE token=" + token;
                        Statement stmt1 = conn.createStatement();
                        stmt1.executeUpdate(sql1);
                        json.put("status","OK");
                        json.put("valid_status","expired");
                        out.print(json.toString());
                    }
                }
                else{
                    json.put("status","OK");
                    json.put("valid_status","invalid");
                    out.print(json.toString());
                }
                conn.close();
            } catch (SQLException ex) {
                Logger.getLogger(validate.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        else{
            json.put("status","FAILED");
            out.print(json.toString());
        }
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
        doGet(request, response);
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
