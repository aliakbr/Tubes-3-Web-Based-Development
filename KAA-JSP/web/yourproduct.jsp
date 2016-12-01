<%-- 
    Document   : yourproduct
    Created on : Nov 6, 2016, 11:55:17 PM
    Author     : khrs
--%>

<%@page import="org.kaa.marketplaceservice.service.ProcedureStatus"%>
<%@page import="org.saleproject.KAA.RestAPI_consumer"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="org.json.simple.parser.JSONParser"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.net.HttpURLConnection"%>
<%@page import="java.net.URL"%>
<%@page import="org.json.simple.*"%>
<%@page import="java.util.*"%>
<%@page import="java.lang.*"%>
<%@page import="org.kaa.marketplaceservice.service.Product"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>Sale Project - Your Product</title>
	<link href="css/style.css" rel="stylesheet" type="text/css">
    </head>
    <body>
	<div class="catalog_content">
		<div class="logo">
			<span id="red">Sale</span><span id="blue">Project</span>
		</div>
		<div class="information">
			<span>
        <%
            JSONObject responseJSON = new JSONObject();
            JSONObject responseJSON1 = new JSONObject();
            
            String APIURL;
            String ParameterURL;
            org.kaa.marketplaceservice.service.MarketPlaceService_Service service = new org.kaa.marketplaceservice.service.MarketPlaceService_Service();
            org.kaa.marketplaceservice.service.MarketPlaceService port = service.getMarketPlaceServicePort();
             String user_token = request.getParameter("token");
             String product_id = request.getParameter("product_id");
            if (request.getParameter("delete") != null){
                ProcedureStatus result1 = port.deleteProduct(user_token, product_id);
                if (result1.getStatus().equals("OK")){
                    response.sendRedirect("http://localhost:8080/KAA-JSP/yourproduct.jsp?token="+user_token);
                }
                else{
                    response.sendRedirect("http://localhost:8080/KAA-JSP/yourproduct.jsp?token="+user_token
                    +"&message=error");
                }
            }
            /* Showing username of user */
           
            if ((request.getParameter("logout") == null) && 
                    (request.getParameter("token")!= null)){
                /* Consume REST API */
                ParameterURL = "token="+ request.getParameter("token");
                APIURL = "http://localhost:8080/IdentService/validate?";
                RestAPI_consumer consumer = new RestAPI_consumer(APIURL,ParameterURL);
                consumer.execute();
                responseJSON = consumer.getOutput();
                
                /* Checking the response */
                String status = (String)responseJSON.get("status");
                if (status.equals("OK")){
                        String user = (String)responseJSON.get("user_name");
                        out.println("Hello, " + user);
                }
                else{
                        response.sendRedirect("http://localhost:8080/KAA-JSP/catalog."
                                        + "jsp?token="+user_token);
                }
            }
            /* Logout */
            else if ((request.getParameter("logout") != null) && 
                    (request.getParameter("token")!= null)){
                URL obj1 = null;
                try{
                    /* Consume REST API */
                    ParameterURL = "token="+ user_token;
                    APIURL = "http://localhost:8080/IdentService/logout?";
                    RestAPI_consumer consumer1 = new RestAPI_consumer(APIURL,ParameterURL);
                    consumer1.execute();
                    responseJSON1 = consumer1.getOutput();
                    
                    /* Checking the response */
                    String status1 = (String)responseJSON1.get("status");
                    if (status1.equals("OK")){
                        response.sendRedirect("http://localhost:8080/KAA-JSP/login.jsp?"
                                + "message=logout");
                    }
                    else{
                        response.sendRedirect("http://localhost:8080/KAA-JSP/catalog."
                                + "jsp?token="+user_token);
                    }
                }
                catch(Exception e){
                    e.printStackTrace();
                }
            }
        %>
        </span>
        </br>
            <a href="
            <%
                String logoutURL = "http://localhost:8080/KAA-JSP/catalog.jsp?token="+user_token+"&logout=on";
                out.println(logoutURL);
            %>
               " class="logout"><span class="link">Logout</span>
            </a><br/>
        </div>
        <table class="menu">
            <th class="menupart">
                <a href="
                   <%
                    out.println("http://localhost:8080/KAA-JSP/catalog.jsp?token="+user_token);
                   %>
                   ">
                    Catalog
                </a>
            </th>
            <th class="menupart" id="active">
                <a href="
                   <%
                    out.println("http://localhost:8080/KAA-JSP/yourproduct.jsp?token="+user_token);
                   %>
                   ">
                    Your Products
                </a>
            </th>
            <th class="menupart">
                <a href="
                   <%
                    out.println("http://localhost:8080/KAA-JSP/addproduct.jsp?token="+user_token);
                   %>
                   ">
                    Add Product
                </a>
            </th>
            <th class="menupart">
                <a href="
                   <%
                    out.println("http://localhost:8080/KAA-JSP/sales.jsp?token="+user_token);
                   %>
                   ">
                    Sales
                </a>
            </th>
            <th class="menupart">
                <a href="
                   <%
                    out.println("http://localhost:8080/KAA-JSP/purchases.jsp?token="+user_token);
                   %>
                   ">Purchases
                </a>
            </th>
        </table>

		<br/>
		<p class="title">What are you going to sell today?</p>
		<hr/>
		<br/>
                <%
                            

                    List<Product> result = port.getYourProduct(user_token);
                    if (result == null){
                        response.sendRedirect("http://localhost:8080/KAA-JSP/login.jsp?"
                            + "message=expired");
                    } else {
                        if (result.size() == 0){
                            out.print("You haven't put anything to be sold yet!");
                        } else {
                            for (int i = 0; i < result.size(); i++) {
                                out.print("<p><b>" + result.get(i).getDate().getDate() + "</b><br/>");
                                out.print("<hr/>");
                                out.print("<table>");
                                out.print("<tr class = \"container\">");
                                out.print("<td>");
                                out.print("<img \" width=120px height=120px src=\"" + result.get(i).getImage() + "\">");                                                       
                                out.print("</td>");                                                     
                                out.print("<td class=\"product_description\">");                                                             
                                out.print("<p class=\"catalog_title\">" + result.get(i).getName() + " <br/></p>");                                                               
                                out.print("<p class=\"catalog_price\">IDR " + result.get(i).getPrice() + "<br/></p>");                                                               
                                out.print("<p class=\"catalog_desc\">" + result.get(i).getDescription() + "</p>");                                                        
                                out.print("</td>");                                                        
                                out.print("<td class=\"product_misc\">");                                                               
                                out.print("<br/>");                                                               
                                out.print("<p>" + port.getLikes(result.get(i).getProductId()) + " likes </p><br/>");                                                                     
                                out.print("<p>" + port.getPurchases(result.get(i).getProductId()) + " purchases <br/>");
                                out.print("<a href=\"http://localhost:8080/KAA-JSP/editproduct.jsp?token=" + user_token + "&product_id=" + result.get(i).getProductId() + "\"><p id=\"edit\">EDIT<p></a>"
                                        + "<a href=\"http://localhost:8080/KAA-JSP/yourproduct.jsp?token=" + user_token + "&delete=on&product_id=" + result.get(i).getProductId() + "\"><p id=\"delete\">DELETE</p></a>");
                                out.print("</td>");                                                       
                                out.print("</tr>");                                                
                                out.print("</table>");                                                
                                out.print("<hr/>");                                               
                                out.print("<br/>");                                              
                                out.print("<br/>");
                            }
                        }
                    }
                %>	
        </div>
    </body>
</html>
