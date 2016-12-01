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
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.Date;
import java.util.Calendar;
import java.sql.Timestamp;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.json.simple.JSONObject;


/**
 *
 * @author Ali-pc
 */
public class login extends HttpServlet {
    
    RandomString tokenGenerator = new RandomString(5);
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
            out.println("<title>Servlet login</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet login at " + request.getContextPath() + "</h1>");
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
        response.setContentType("application/json");
        response.setCharacterEncoding("utf-8");
        JSONObject json = new JSONObject();
        try {
            Connection conn = DBAccount.getConnection();
            if (conn != null){
                Statement stmt = conn.createStatement();
                String sql;
                String username = request.getParameter("username");
                String password = request.getParameter("password");
                sql = "select * from account where (username=\""+username+"\" or email=\""
                        +username+"\") and password=\""+password+"\"";
                ResultSet rs = stmt.executeQuery(sql);
                if (rs.next()){
                   int user_id = rs.getInt("user_id");
                   String user = rs.getString("username");
                   //String generatedToken = generateToken(request);
                   Calendar cal = Calendar.getInstance();
                   int hours = cal.get(Calendar.HOUR_OF_DAY);
                   int tanggal = cal.get(Calendar.DATE);
                   if(hours != 23){
                       cal.set(Calendar.HOUR_OF_DAY, hours+1);
                   }
                   else{
                       cal.set(Calendar.DATE, tanggal+1);
                       cal.set(Calendar.HOUR_OF_DAY, 0);
                   }
                   Date dt = cal.getTime();
                   //token akan expire dalam 60 menit
                   Timestamp ts = new Timestamp(dt.getTime());
                   String generatedToken = generateToken(request);
                   sql = "insert into token values (\""+ user_id+ "\",\""+generatedToken+"\",\""+ts+"\")";
                   stmt.executeUpdate(sql);

                   PrintWriter out = response.getWriter();
                   
                   json.put("status","OK");
                   json.put("token",generatedToken);
                   json.put("user_id",user_id);
                   json.put("username",user);
                   out.print(json.toString());
                }
                else{
                    PrintWriter out = response.getWriter(); 
                    json.put("status","FAILED");
                    out.print(json.toString());
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
            Logger.getLogger(login.class.getName()).log(Level.SEVERE, null, ex);
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
        //processRequest(request, response);
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
    
    public String generateToken(HttpServletRequest request){
        String token;
        String user_agent = request.getParameter("user_agent");
        String ip = request.getParameter("ip");
        token = tokenGenerator.nextString() + "|" + user_agent + '|' + ip;
        return token;
    }
}
