/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.saleproject.KAA;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import static java.lang.System.out;
import java.nio.file.Paths;
import java.util.Arrays;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import org.kaa.marketplaceservice.service.ProcedureStatus;

/**
 *
 * @author khrs
 */
@WebServlet(name = "UploadProduct", urlPatterns = {"/UploadProduct"})
@MultipartConfig
public class UploadProduct extends HttpServlet {

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
            out.println("<title>Servlet UploadProduct</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet UploadProduct at " + request.getContextPath() + "</h1>");
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

        String user_token = request.getParameter("token");
        
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String price = request.getParameter("price");

        String[] stringArray = name.split(" ");

        String image = Arrays.toString(stringArray); // nama filenya nama produk tapi pake '_' bukan pake spasi

        Part filePart = request.getPart("img");
        String imagename = Paths.get(filePart.getSubmittedFileName()).getFileName().toString(); // MSIE fix.
        
        String imagefile = "C:\\Users\\Frys\\Desktop\\Java\\WBD\\Tubes 2\\KAA-JSP\\web\\product_img\\" + image + imagename;
        
        out.println(imagefile);
        InputStream fileContent;
        fileContent = filePart.getInputStream();

        out.println("tes");
        //untuk masukin gambar
        byte[] bytes = new byte[4096]; 

        ByteArrayOutputStream output = new ByteArrayOutputStream(); 
        byte[] b = new byte[4096]; 
        int n = 0; 
        while ((n = fileContent.read(b)) != -1) { 
            output.write(b, 0, n); 
        } 
        bytes = output.toByteArray(); 
        output.close(); 

        fileContent.close();

        out.println("tes");

        File file;

        FileOutputStream fos = null;
        try {
            file = new File(imagefile);
        out.println("tesbuat");
            if(!file.exists()){
                file.createNewFile();
            }
        out.println("tesx213");
            fos = new FileOutputStream(file);
            fos.write(bytes);
            fos.flush();
            fos.close();
        out.println("tesxx");

        }
        catch (IOException e) {
            out.println("xxgagal");
            e.printStackTrace();
        }
        finally {
            try {
                if(fos!=null){
                    fos.close();
                }
            }
            catch (IOException e){
                e.printStackTrace();
            }
        }
        out.println("tes");

        out.println(price);
//                out.println(image);
        org.kaa.marketplaceservice.service.MarketPlaceService_Service service = new org.kaa.marketplaceservice.service.MarketPlaceService_Service();
        org.kaa.marketplaceservice.service.MarketPlaceService port = service.getMarketPlaceServicePort();        
        image += imagename;
        ProcedureStatus result = port.addEditProduct(name, description, price, image, "0", "0", user_token);

        String message;
        if (result.getStatus().equals("OK")){
            response.sendRedirect("http://localhost:8080/KAA-JSP/yourproduct."
                    + "jsp?token="+user_token);
        out.println("tes");
        }
        else if (result.getStatus().equals("EXPIRED")){
            message = "Expired";
            response.sendRedirect("http://localhost:8080/KAA-JSP/login.jsp?"
                                 + "message="+message);
        out.println("tes");
        }
        else{
            response.sendRedirect("http://localhost:8080/KAA-JSP/addproduct."
                    + "jsp?token="+user_token+"&message=error");
            out.println("tes");
        }

        
        // ... (do your job here)

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
