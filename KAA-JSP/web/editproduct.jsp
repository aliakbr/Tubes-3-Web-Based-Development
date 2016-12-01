<%-- 
    Document   : editproduct
    Created on : Nov 6, 2016, 11:49:27 PM
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
    <%
        /* Check the request */
        String prodid = request.getParameter("product_id");
         String message = null;
         String user_token = request.getParameter("token");
        if (request.getMethod().equals("POST")){
            URL obj = null;
            try{
                /* POST METHOD */
                String name = request.getParameter("name");
                String description = request.getParameter("description");
                String price = request.getParameter("price");
                String image = request.getParameter("img");
                //String token = request.getParameter("inputName");
                out.println(price);
                out.println(image);
                org.kaa.marketplaceservice.service.MarketPlaceService_Service service = new org.kaa.marketplaceservice.service.MarketPlaceService_Service();
                org.kaa.marketplaceservice.service.MarketPlaceService port = service.getMarketPlaceServicePort();        
                ProcedureStatus result = port.addEditProduct(name, description, price, image, "1", prodid, user_token);
                if (result.getStatus().equals("OK")){
                    response.sendRedirect("http://localhost:8080/KAA-JSP/yourproduct."
                            + "jsp?token="+user_token);
                }
                else if (result.getStatus().equals("EXPIRED")){
                    message = "Expired";
                    response.sendRedirect("http://localhost:8080/KAA-JSP/login.jsp?"
                                         + "message="+message);
                }
                else{
                    response.sendRedirect("http://localhost:8080/KAA-JSP/addproduct."
                            + "jsp?token="+user_token+"&message=error");
                }
            }
            catch(Exception e){
                e.printStackTrace();
            }
        }
    %>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>SaleProject - Edit Product</title>
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
                                 response.sendRedirect("http://localhost:8080/KAA-JSP/editproduct."
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
                    <th class="menupart" id="active">
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
		<p class="title">Please update your product here</p>
		<hr>
		<div class="add_product_content">
			<%
                            String productname = null, 
                            product_id = null, 
                            productdescription = null,
                            productimage = null;
                            long productprice = 0;
                            if (request.getParameter("product_id")!= null){
                                org.kaa.marketplaceservice.service.MarketPlaceService_Service service = new org.kaa.marketplaceservice.service.MarketPlaceService_Service();
                                org.kaa.marketplaceservice.service.MarketPlaceService port = service.getMarketPlaceServicePort();
                                // TODO initialize WS operation arguments here
                                // TODO process result here
                                Product result = port.getProduct(user_token, prodid);
                                productname = result.getName();
                                product_id = prodid;
                                productdescription = result.getDescription();
                                productprice = result.getPrice();
                                productimage = result.getImage();
                            }
			%>
			<form method="POST" name="product_data" onsubmit="return validateForm()">
				<div class="input_field">
					Name<br><input type="text" name="name" value=<%
                                            out.println(productname);
                                        %>><br>
				</div>
				<div class="input_field_description">
					Description (max 200 characters)<br><input type="text" name="description" value=<%
                                            out.println(productdescription);
                                        %>></br>
				</div>
				<div class="input_field">
					Price<br><input type="number" name="price" value=
                                            <%
                                            out.println(productprice);
                                        %>>
                                        </br>
				</div>
				<div class="input_photo">
					Photo<br><input type="file" name="img">
				</div>
				<br/>
				<div class="submit_button_add">
					<input type="submit" value="UPDATE">
				</div>
				<div class="submit_button_cancel">
					<input type="reset" value="CANCEL">
				</div>
			</form>
		</div>
	</div>
	<script>
	function validateForm(){	
		var x = document.forms["product_data"]["name"].value;
		if (x == null || x == "") {
			alert("Product name must be filled out");
			return false;
		}
		x = document.forms["product_data"]["description"].value;
		if (x == null || x == "") {
			alert("Description must be filled out");
			return false;
		}
		if(x.length > 200){
			alert("Description maximum characters is 200 characters");
			return false;			
		}
		x = document.forms["product_data"]["price"].value;
		if (x == null || x == "") {
			alert("Price must be filled out");
			return false;
		}
		var integer = /^\+?(0|[1-9]\d*)$/;
		if(!integer.test(x)){
			alert("Price must be integer");
			return false;
		}
		x = document.forms["product_data"]["img"].value;
		return (true);
	}	
	</script>
    </body>
</html>
