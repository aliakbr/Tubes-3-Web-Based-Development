<%-- 
    Document   : catalog
    Created on : Nov 6, 2016, 11:43:13 PM
    Author     : khrs
--%>

<%@page import="java.io.FileInputStream"%>
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
	<title>Sale Project - Catalog</title>
	<link href="css/style.css" rel="stylesheet" type="text/css">
         <!--Angular -->
        <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.4.8/angular.min.js"></script>
        <!-- Firebase -->
        <!--<script src="https://cdn.firebase.com/js/client/2.0.4/firebase.js"></script>--> 
        <script src="https://www.gstatic.com/firebasejs/3.6.1/firebase.js"></script>
        <!--<script src="https://www.gstatic.com/firebasejs/3.6.1/firebase-app.js"></script>
        <script src="https://www.gstatic.com/firebasejs/3.6.1/firebase-auth.js"></script>
        <script src="https://www.gstatic.com/firebasejs/3.6.1/firebase-database.js"></script>
        <script src="https://www.gstatic.com/firebasejs/3.6.1/firebase-messaging.js"></script>
        <!-- <script src="https://www.gstatic.com/firebasejs/3.6.1/firebase-storage.js"></script> -->-->
        <!-- AngularFire -->
        <script src="https://cdn.firebase.com/libs/angularfire/0.9.2/angularfire.min.js"></script>
 
        <script>
          // Initialize Firebase
          var config = {
            apiKey: "AIzaSyAN43gCcqFx095nCBy-4abeRGkoZB1-Rok",
            authDomain: "kaa-saleproject.firebaseapp.com",
            databaseURL: "https://kaa-saleproject.firebaseio.com",
            storageBucket: "kaa-saleproject.appspot.com",
            messagingSenderId: "815161898662"
          };
          firebase.initializeApp(config);
          
          messaging = firebase.messaging();
          
          messaging.requestPermission().then(function(){
              console.log('Notification permission granted');
              messaging.getToken().then(function(){
                  if(currentToken){
                      sendTokenToServer(currentToken);
                      updateUIForPushEnabled(currentToken);
                      console.log('Token retrieved, ',currentToken);
                      //abis itu send ke tokensaver chatservice di sini atau di bawah
                  } else {
                      console.log('No Instance ID token available. Request permission to generate one');
                      updateUIForPushPermissionRequired();
                      setTokenToServer(false);
                  }
              }).catch(function(err){
                  console.log('An error occured while retrieving token. ',err);
                  showToken('Error retrieving Instance ID token. ',err);
                  setTokenToServer(false);
              });
                   
          }).catch(function(err){
              console.log('Unable to get permission to notify',err);
          });
          
          messaging.onTokenRefresh(function(){
              mesagging.getToken().then(function(refreshedToken){
                  console.log('Token refreshed.');
                  setTokenSentToServer(false);
                  sendTokenToServer(refreshedToken);
              });
          }).catch(function(err){
              console.log('Unable to retrieve refreshed token. ',err);
              showToken('Unable to retrieve refreshed token. ',err);
          });
          
          messaging.onMessage(function(payload){
              console.log("Message received. ",payload);
          })
        </script>
        <!--Application -->
        <script src="scripts/app.js"></script>

        
    </head>
    <body>
	<div class="catalog_content">
        <div class="logo">
            <span id="red">Sale</span><span id="blue">Project</span>
        </div>
        <div class="information">
       <span>
        <%
/*            FirebaseOptions options = new FirebaseOptions.Builder()
            .setServiceAccount(new FileInputStream("path/to/serviceAccountKey.json"))
            .setDatabaseUrl("https://<DATABASE_NAME>.firebaseio.com/")
            .build();

            FirebaseApp.initializeApp(options);*/
            
            JSONObject responseJSON = new JSONObject();
            JSONObject responseJSON1 = new JSONObject();
            org.kaa.marketplaceservice.service.MarketPlaceService_Service service = new org.kaa.marketplaceservice.service.MarketPlaceService_Service();
            org.kaa.marketplaceservice.service.MarketPlaceService port = service.getMarketPlaceServicePort();        
            String query;
            String APIURL;
            String ParameterURL;
            
            /* Showing username of user */
            Cookie cookie = request.getCookies()[0];
            String user_token = cookie.getValue();
            if (request.getParameter("like") != null){
               String productId = request.getParameter("product_id");
               boolean like;
               if (request.getParameter("like").equals("yes")){
                   like = true;
               } else {
                   like = false;
               }
               ProcedureStatus result = port.processLike(user_token, productId, like);
               if (result.getStatus().equals("OK")){
                   //Do nothing
                } else if (result.getStatus().equals("EXPIRED")) {
                    response.sendRedirect("http://localhost:8080/KAA-JSP/login.jsp?"
                                         + "message=Expired");
                } else {
                    response.sendRedirect("http://localhost:8080/KAA-JSP/catalog."
                            + "jsp?token="+user_token+"&message=error");
                }
            }
            
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
/*          Firebase here  
            String uid = "some-uid";

            FirebaseAuth.getInstance().createCustomToken(uid)
                .addOnSuccessListener(new OnSuccessListener<String>() {
                    @Override
                    public void onSuccess(String customToken) {
                        // Send token back to client
                    }
                });*/
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
        <p class="title">What are you going to buy today?</p>
        <hr/>
        <br/>
        <div class="add_product_content">
                <form method="GET" enctype="multipart/form-data">
                        <div class="input_catalog">
                                <input type="hidden" name="token" value=<%
                                    out.println(user_token);
                                %> >
                                <input type="text" placeholder="Search catalog ..." 
                                    name="search" style="width:90%; height: 35px; border:none;" 
                                    class="auto-style1" hidefocus="hidefocus">
                                <input type="submit" value="GO" style="width: 10%; height: 35px; font-weight: bold"><br/>
                                by
                                <input class="radio" type="radio" name="choice" value="product" checked="checked" />
                                <label><span>product</span></label><br />
                                <input class="radio" type="radio" name="choice" value="store" style="margin-left:25px;" />
                                <label><span>store</span></label>
                        </div>
                </form>
        </div>    
        <%
            if(request.getParameter("search") == null){
                // Ketika pertama kali membuka catalog (tidak ada parameter search) 
                List<Product> result = port.retrieveAllProduct(user_token);
                
                // Ketika token sudah expired
                if (result == null){
                        response.sendRedirect("http://localhost:8080/KAA-JSP/login.jsp?"
                                + "message=expired");
                } else {
                    if (result.size() == 0){
                            out.print("<p>No product to be sold.</p>");
                    } else {
                        for (int i = 0; i < result.size(); i++) {
                            out.print("<p><b>" + result.get(i).getUsername() + "</b><br/>");
                            out.print("added this on " + result.get(i).getDate().getDate() + "</p>");
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
                            out.print(port.isLiked(user_token, result.get(i).getProductId()));                                                                        
                            out.print("<a href=\"http://localhost:8080/KAA-JSP/confirmation_purchase.jsp?token=" + user_token + "&product_id=" + result.get(i).getProductId() + "\"><p id=\"buy\">BUY</a></p>");                                                                
                            out.print("</td>");                                                       
                            out.print("</tr>");                                                
                            out.print("</table>");                                                
                            out.print("<hr/>");                                               
                            out.print("<br/>");                                              
                            out.print("<br/>");
                        }
                    }
                }
           } else {
                // Ketika ada parameter untuk search
                String search = request.getParameter("search");
                String choice = request.getParameter("choice");
                /* Melakukan Searching dengan Method search_product pada MarketService */
                try{
                    int choice_int = 0;
                    if (choice.equals("product")){
                        choice_int = 0;
                    } else if (choice.equals("store")) {
                        choice_int = 1;
                    }
                    
                    List<Product> result = port.searchProduct(search, user_token, choice_int);
                    
                    /* Jika expired */
                    if (result == null){
                        response.sendRedirect("http://localhost:8080/KAA-JSP/login.jsp?"
                                + "message=expired");
                    } else {
                        if (result.size() == 0){
                            out.print("<p>Nothing matches your search.</p>");
                        } else {
                            for (int i = 0; i < result.size(); i++) {
                                out.print("<p><b>" + result.get(i).getUsername() + "</b><br/>");
                                out.print("added this on " + result.get(i).getDate().getDate() + "</p>");
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
                                out.print(port.isLiked(user_token, result.get(i).getProductId()));                                                                        
                                out.print("<a href=\"http://localhost:8080/KAA-JSP/confirmation_purchase.jsp?token=" + user_token + "&product_id=" + result.get(i).getProductId() + "\"><p id=\"buy\">BUY</a></p>");                                                                
                                out.print("</td>");                                                       
                                out.print("</tr>");                                                
                                out.print("</table>");                                                
                                out.print("<hr/>");                                               
                                out.print("<br/>");                                              
                                out.print("<br/>");
                            }
                        }
                    }
                } catch (Exception ex) {
                    // TODO handle custom exceptions here
                }
            }
        %>

        <div ng-app="chatApp" ng-controller="chatController">
            <p>Name: <input type="text" ng-model="newmessage.user"></p>
            <p>Message: <input type="text" ng-model="newmessage.text"></p>
            <button ng-click="insert(newmessage)">Send</button>
        
            <ul>
                <li ng-repeat="message in messages">
                    {{message.user}} send: {{message.text}}
                </li>
            </ul>
	</div>
        

        <script>       
            document.getElementById("catalog").style.background="#0066ff";
            document.getElementById("catalog").style.color="#ffffff";
        </script>
    </body>
</html>
