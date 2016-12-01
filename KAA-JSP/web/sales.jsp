<%-- 
    Document   : sales
    Created on : Nov 6, 2016, 11:51:05 PM
    Author     : khrs
--%>

<%@page import="org.saleproject.KAA.RestAPI_consumer"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="org.json.simple.parser.JSONParser"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.net.HttpURLConnection"%>
<%@page import="java.net.URL"%>
<%@page import="org.json.simple.*"%>
<%@page import="java.util.*"%>
<%@page import="java.lang.*"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="org.kaa.marketplaceservice.service.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>Sale Project - Sales</title>
	<link href="css/style.css" rel="stylesheet" type="text/css">
    </head>
    <body>
<html>
<head>
	<title>Sale Project - Sales</title>
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
                     String APIURL;
                     String ParameterURL;
                     /* Showing username of user */
                     String user_token = request.getParameter("token");
                     if ((request.getParameter("logout") == null) && 
                             (request.getParameter("token")!= null)){
                         /* Consume REST API */
                         ParameterURL = "token="+ request.getParameter("token");
                         APIURL = "http://localhost:8080/IdentService/validate?";
                         RestAPI_consumer consumer = new RestAPI_consumer(APIURL,ParameterURL);
                         consumer.execute();
                         JSONObject responseJSON = consumer.getOutput();

                         /* Checking the response */
                         String status = (String)responseJSON.get("status");
                         if (status.equals("OK")){
                                 String user = (String)responseJSON.get("user_name");
                                 out.println("Hello, "+user);
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
                             JSONObject responseJSON1 = consumer1.getOutput();

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
			<th class="menupart">
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
			<th class="menupart" id="active">
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
		<p class="title">Here are your sales<p>
		<hr/>
		<br/>


        <%
            org.kaa.marketplaceservice.service.MarketPlaceService_Service service = new org.kaa.marketplaceservice.service.MarketPlaceService_Service();
            org.kaa.marketplaceservice.service.MarketPlaceService port = service.getMarketPlaceServicePort();        
            String query;

            List<Purchase> result = port.getSalesPurchases(user_token,0);
            if (result == null){
                response.sendRedirect("http://localhost:8080/KAA-JSP/login.jsp?"
                    + "message=expired");
            } else {
                if (result.size() == 0){
                    out.print("You haven't sold anything yet!");
                } else {
                    for (int i = 0; i < result.size(); i++) {

                                out.print("<p><b>" + "</b><br/>");
                                out.print("at "+ result.get(i).getDate().getDate() +" </p>");
                                out.print("<hr/>");
                                out.print("<table>");
                                    out.print("<tr class = \"container\">");
                                        out.print("<td>");
                                            out.print("<img width=120px height=120px src=\"" + result.get(i).getProductImage()  + "\">");
                                        out.print("</td>");
                                        out.print("<td class=\"product_description\">");
                                            out.print("<p class=\"catalog_title\">"+result.get(i).getProductName()+" <br/></p>");
                                            out.print("<p class=\"catalog_price\">IDR "+result.get(i).getProductPrice() * result.get(i).getQuantity()+" <br/></p>");
                                            out.print("<p class=\"catalog_desc\">"+result.get(i).getQuantity()+" pcs</p>");
                                            out.print("<p class=\"catalog_price\">@IDR "+result.get(i).getProductPrice()+" <br/></p>");
                                            out.print("<br/>");
                                            out.print("<p class=\"catalog_buyusername\">bought by <b>"+"</b></p>"); 
                                        out.print("<td class=\"product_misc\">");
                                            out.print("<p class=\"catalog_details\">Delivery to <b>"+ result.get(i).getBuyerName()+"</b> <br/>");
                                            out.print("" + result.get(i).getBuyerAddress() + "<br/>");
                                            out.print(result.get(i).getPostalCode() +"<br/>");
                                            out.print(result.get(i).getPhonenumber() + "<br/>");
                                            out.print("</p>");
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
