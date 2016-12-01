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
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.json.simple.JSONObject;

/**
 *
 * @author Ali-pc
 */
@WebServlet(name = "RetrieveAccount", urlPatterns = {"/RetrieveAccount"})
public class RetrieveAccount extends HttpServlet {

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
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet RetrieveAccount</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet RetrieveAccount at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
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
                    json.put("valid_status","valid");
                    int user_id = rs.getInt("user_id");
                    Timestamp expire = rs.getTimestamp("expire_time");
                    String fullname = rs.getString("fullname");
                    String username = rs.getString("username");
                    String email = rs.getString("email");
                    String address = rs.getString("address");
                    String postal_code = rs.getString("postal_code");
                    String phone_number = rs.getString("phone_number");
                    json.put("fullname",fullname);
                    json.put("username",username);
                    json.put("address",address);
                    json.put("postal_code",postal_code);
                    json.put("phone_number",phone_number);
                    out.print(json.toString());
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
        doGet(request,response);
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
