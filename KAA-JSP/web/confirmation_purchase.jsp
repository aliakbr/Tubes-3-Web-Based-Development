<%-- 
    Document   : confirmation_purchase
    Created on : Nov 6, 2016, 11:48:43 PM
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
         String message = null;
         String user_token = request.getParameter("token");
         
         /* Retrieving basic user data */
        
        String cosignee = "", fulladdress = "", postal_code = "", phone_number = "";
        String product_id = request.getParameter("product_id");
        String Parameter = "?token="+user_token;
        String URLAPI = "http://localhost:8080/IdentService/RetrieveAccount";
        String URLValidate = "http://localhost:8080/IdentService/validate";
        RestAPI_consumer consume1 = new RestAPI_consumer(URLValidate, Parameter);
        consume1.execute();
        JSONObject api_json1 = consume1.getOutput();
        if (api_json1.get("valid_status").equals("valid")){
            RestAPI_consumer consume = new RestAPI_consumer(URLAPI,Parameter);
            consume.execute();
            JSONObject api_json = consume.getOutput();
            if (api_json.get("status").equals("OK")){
                cosignee = api_json.get("fullname").toString();
                fulladdress = api_json.get("address").toString();
                phone_number = api_json.get("phone_number").toString();
                postal_code = api_json.get("postal_code").toString();
            }
            else{
                /* do nothing */
            }
        }
        else{
            response.sendRedirect("http://localhost:8080/KAA-JSP/login."
                            + "jsp?message=expired");
        }
        /* Check the request */
        if (request.getMethod().equals("POST")){
            URL obj = null;
            try{
                /* POST METHOD */
                cosignee = request.getParameter("cosignee");
                String quantity = request.getParameter("quantity");
                fulladdress = request.getParameter("full_address");
                phone_number = request.getParameter("phone_number");
                postal_code = request.getParameter("postal_code");
                String price = request.getParameter("price");
                String image = request.getParameter("img");
                
                out.println(price);
                out.println(image);
                org.kaa.marketplaceservice.service.MarketPlaceService_Service service = new org.kaa.marketplaceservice.service.MarketPlaceService_Service();
                org.kaa.marketplaceservice.service.MarketPlaceService port = service.getMarketPlaceServicePort();        
                ProcedureStatus result = port.buy(user_token, product_id, quantity, cosignee, fulladdress, postal_code, phone_number);
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
	<title>SaleProject - Confirmation Purchase</title>
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
		
		<p class="title">Please confirm your product</p>
		<hr>
		
		<div class="add_product_content">
                    <form name ="confirmation_purchase" method="POST" >
				<div class="flex-text-container">
					<div class="flex-text-box">Quantity</div>
					<div class="flex-text-box">:
						<input class ="quantity" id = "kuantitas" type="text" 
                                                       name="quantity" value="0" style="width:40px" onchange="hitungHarga()">pcs
					</div>
				</div>
				<div class="flex-text-container">
					<div class="flex-text-box">Total Price</div>
					<div class="flex-text-box">: IDR <span id="total_price">0</span></div>
				</div>
				<div class="flex-text-container">
					<div class="flex-text-box">Delivery To</div>
					<div class="flex-text-box">:</div>
				</div>
				<div class="input_field">
					Cosignee<br><input type="text" name="cosignee" value=
						<%
                                                  out.println(cosignee);
                                                %>
					><br>
				</div>
				<div class="input_field_description">
					Full Address<br><input type="text" name="full_address" value=
						<%
                                                  out.println(fulladdress);
                                                %>
					></br>
				</div>
				<div class="postal_code">
					Postal Code<br><input type="text" name="postal_code" value=
						<%
                                                  out.println(postal_code);
                                                %>
					></br>
				</div>
				<div class="phone_number">
					Phone Number<br><input type="text" name="phone_number" value=
						<%
                                                  out.println(phone_number);
                                                %>
					>
				</div>
				<div class="phone_number">
					12 Digit Credit Card Number<br><input type="text" name="credit_card">
				</div>
				<div class="validation_number">
					3 Digit Card Verification Value<br><input type="text" name="validation_number">
				</div>
				<br/>
				<div class="submit_button_add">
					<input type="submit" value="CONFIRM" onclick="return confirmation()">
				</div>
				<div class="submit_button_cancel">
					<input type="reset" value="CANCEL">
				</div>
			</form>
		</div>
	</div>

	<script type="text/javascript">
		function hitungHarga(){
			var harga = Number(document.getElementById("price1").innerHTML);
			var banyak = Number(document.getElementById("kuantitas").value);
			var total = harga * banyak;
			document.getElementById("total_price").innerHTML = total;
		}

		function confirmation(){
                    if (validateForm()){
                                     return confirm("Apakah data yang anda isikan benar?");
                    } else {
                        return false;
                    }
		}

		function validateForm(){
                var bool = true;
			var x = document.forms["purchase_form"]["cosignee"].value;
			if (x == null || x == "") {
				alert("Fullname must be filled out");
				bool = false;
			}
			x = document.forms["purchase_form"]["quantity"].value;
			if (x == null || x == "") {
				alert("Quantity must be filled out");
				bool = false;
			}
			x = document.forms["purchase_form"]["validation_number"].value;
			if (x == null || x == "") {
				alert("Validation number must be filled out");
				bool = false;
			}
			if (x.length != 3){
				alert("Validation number must be 3 digit");
                                bool = false;
			}
			x = document.forms["purchase_form"]["credit_card"].value;
			if (x == null || x == "") {
				alert("Credit card number must be filled out");
				bool = false;
			}
			if (x.length != 12){
				alert("Credit card must be 12 digit");
                                bool = false;
			}
			x = document.forms["purchase_form"]["full_address"].value;
			if (x == null || x == "") {
				alert("Full address must be filled out");
				bool = false;
			}
			pola_angka=/^[0-9]+[0-9]*$/;
			x = document.forms["purchase_form"]["postal_code"].value;
			if (x == null || x == "") {
				alert("Postal code must be filled out");
				bool = false;
			}
			if (!pola_angka.test(x) || x.length != 5) {
				alert("Please insert a valid postal code");
				bool = false;
			}
			x = document.forms["purchase_form"]["phone_number"].value;
			if (x == null || x == "") {
				alert("Phone number must be filled out");
				bool = false;
			}
			if ((!pola_angka.test(x)) || x.length < 6 || x.length > 13) {
				alert("Please insert a valid phone number");
				bool = false;
			}
                        x = document.forms["purchase_form"]["quantity"].value;
			if (x == null || x == "") {
				alert("Quantity must be filled out");
				bool = false;
			}
			if (!pola_angka.test(x)){
				alert("Quantity must be a number");
				bool = false;
			}
            if (x == 0){
                alert("Quantity must be not 0");
                bool = false;
            }
            return bool;
		}	
	</script>	
    </body>
</html>
