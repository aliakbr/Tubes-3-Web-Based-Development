<%-- 
    Document   : catalog
    Created on : Nov 6, 2016, 11:43:13 PM
    Author     : khrs
--%>

<%@page import="org.saleproject.KAA.GetIP"%>
<%@page import="org.saleproject.KAA.tokenParser"%>
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
        <!-- Firebase -->
        <script src="https://www.gstatic.com/firebasejs/3.6.1/firebase.js"></script>
        <!--Angular -->
        <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.4.8/angular.min.js"></script>
        <!--<script src="https://cdn.firebase.com/js/client/2.0.4/firebase.js"></script>--> 
        <!--<script src="https://www.gstatic.com/firebasejs/3.6.1/firebase-app.js"></script>
        <script src="https://www.gstatic.com/firebasejs/3.6.1/firebase-auth.js"></script>
        <script src="https://www.gstatic.com/firebasejs/3.6.1/firebase-database.js"></script>
        <script src="https://www.gstatic.com/firebasejs/3.6.1/firebase-messaging.js"></script>
        <!-- <script src="https://www.gstatic.com/firebasejs/3.6.1/firebase-storage.js"></script> -->
        <!-- AngularFire -->
        <!--        <script src="https://cdn.firebase.com/libs/angularfire/0.9.2/angularfire.min.js"></script>-->


        <!--Application -->
        <script src="scripts/app.js"></script>
        <script type="text/javascript">
            // Fungsi AJAX untuk memproses likes (tambah, kurang, atau tampilkan)
            function getState(username, product_id) {
                var xmlhttp = new XMLHttpRequest();
                xmlhttp.onreadystatechange = function () {
                    if (this.readyState == 4 && this.status == 200) {
                        var obj = JSON.parse(this.responseText);
                        if (obj.status === 'ON') {
                            document.getElementById("status" + username + product_id).innerHTML = "<img style=\"border: none; padding: 0px 10px 0px 0px; float:left\" height=15px width=15px src=\"img/on.png\">";
                        } else {
                            document.getElementById("status" + username + product_id).innerHTML = "<img style=\"border: none; padding: 0px 10px 0px 0px; float:left\" height=15px width=15px src=\"img/off.png\">";
                        }
                    }
                };
                xmlhttp.open("GET", "http://localhost:8080/ChatService/RetrieveStatus?username=" + username, true);
                xmlhttp.send();
            };
        </script>

    </head>
    <body ng-app="chatApp" ng-controller="chatController">
        <div class="catalog_content">
            <div class="logo">
                <span id="red">Sale</span><span id="blue">Project</span>
            </div>
            <div class="information">
                <span>
                    <%
                        /* handler */
                        String user_token = request.getParameter("token");
                        String tokenBrowser =  tokenParser.parseBrowser(user_token);
                        String tokenIP = tokenParser.parseIP(user_token);
                        System.out.println(tokenBrowser+" "+tokenIP);
                        String useragent = request.getHeader("user-agent");
                        String userIP = GetIP.getClientIpAddress(request);
                        System.out.println(useragent+" "+ userIP);
                        if (!tokenBrowser.equals(useragent) || !tokenIP.equals(userIP)){
                            String ParameterURL1 = "token=" + user_token;
                            String APIURL1 = "http://localhost:8080/IdentService/logout?";
                            RestAPI_consumer consumer1 = new RestAPI_consumer(APIURL1, ParameterURL1);
                            consumer1.execute();
                            JSONObject responseJSON1 = consumer1.getOutput();
                            String status1 = (String) responseJSON1.get("status");
                            if (status1.equals("OK")) {
                                response.sendRedirect("http://localhost:8080/KAA-JSP/login.jsp?"
                                        + "message=tokeninvalid");
                            } else {
                                response.sendRedirect("http://localhost:8080/KAA-JSP/catalog."
                                        + "jsp?token=" + user_token);
                            }
                        }
                        JSONObject responseJSON = new JSONObject();
                        JSONObject responseJSON1 = new JSONObject();
                        org.kaa.marketplaceservice.service.MarketPlaceService_Service service = new org.kaa.marketplaceservice.service.MarketPlaceService_Service();
                        org.kaa.marketplaceservice.service.MarketPlaceService port = service.getMarketPlaceServicePort();
                        String query;
                        String APIURL;
                        String ParameterURL;

                        String urlParamChat;
                        String urlRequest2 = "http://localhost:8080/ChatService/RetrieveStatus?";

                        /* Showing username of user */
                        if (request.getParameter("like") != null) {
                            String productId = request.getParameter("product_id");
                            boolean like;
                            if (request.getParameter("like").equals("yes")) {
                                like = true;
                            } else {
                                like = false;
                            }
                            ProcedureStatus result = port.processLike(user_token, productId, like);
                            if (result.getStatus().equals("OK")) {
                                //Do nothing
                            } else if (result.getStatus().equals("EXPIRED")) {
                                response.sendRedirect("http://localhost:8080/KAA-JSP/login.jsp?"
                                        + "message=Expired");
                            } else {
                                response.sendRedirect("http://localhost:8080/KAA-JSP/catalog."
                                        + "jsp?token=" + user_token + "&message=error");
                            }
                        }

                        if ((request.getParameter("logout") == null)
                                && (request.getParameter("token") != null)) {
                            /* Consume REST API */
                            ParameterURL = "token=" + request.getParameter("token");
                            APIURL = "http://localhost:8080/IdentService/validate?";
                            RestAPI_consumer consumer = new RestAPI_consumer(APIURL, ParameterURL);
                            consumer.execute();
                            responseJSON = consumer.getOutput();

                            /* Checking the response */
                            String status = (String) responseJSON.get("status");
                            if (status.equals("OK")) {
                                String user = (String) responseJSON.get("user_name");
                                out.println("Hello, " + user);
                                out.println("<div id=\"usernameangular\" data-user=\""+user+"\"></div>");
                            } else {
                                response.sendRedirect("http://localhost:8080/KAA-JSP/catalog."
                                        + "jsp?token=" + user_token);
                            }
                        } /* Logout */ else if ((request.getParameter("logout") != null)
                                && (request.getParameter("token") != null)) {
                            URL obj1 = null;
                            try {
                                /* Consume REST API */
                                ParameterURL = "token=" + user_token;
                                APIURL = "http://localhost:8080/IdentService/logout?";
                                RestAPI_consumer consumer1 = new RestAPI_consumer(APIURL, ParameterURL);
                                consumer1.execute();
                                responseJSON1 = consumer1.getOutput();

                                /* Checking the response */
                                String status1 = (String) responseJSON1.get("status");
                                if (status1.equals("OK")) {
                                    response.sendRedirect("http://localhost:8080/KAA-JSP/login.jsp?"
                                            + "message=logout");
                                } else {
                                    response.sendRedirect("http://localhost:8080/KAA-JSP/catalog."
                                            + "jsp?token=" + user_token);
                                }
                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                        }


                    %>
                </span>

                </br>
                <a href="
                   <%  String logoutURL = "http://localhost:8080/KAA-JSP/catalog.jsp?token=" + user_token + "&logout=on";
                       out.println(logoutURL);
                   %>
                   " class="logout"><span class="link">Logout</span>
                </a><br/>
            </div>
            <table class="menu">
                <th class="menupart" id="active">
                    <a href="
                       <%
                           out.println("http://localhost:8080/KAA-JSP/catalog.jsp?token=" + user_token);
                       %>
                       ">
                        Catalog
                    </a>
                </th>
                <th class="menupart">
                    <a href="
                       <%
                           out.println("http://localhost:8080/KAA-JSP/yourproduct.jsp?token=" + user_token);
                       %>
                       ">
                        Your Products
                    </a>
                </th>
                <th class="menupart">
                    <a href="
                       <%
                           out.println("http://localhost:8080/KAA-JSP/addproduct.jsp?token=" + user_token);
                       %>
                       ">
                        Add Product
                    </a>
                </th>
                <th class="menupart">
                    <a href="
                       <%
                           out.println("http://localhost:8080/KAA-JSP/sales.jsp?token=" + user_token);
                       %>
                       ">
                        Sales
                    </a>
                </th>
                <th class="menupart">
                    <a href="
                       <%
                           out.println("http://localhost:8080/KAA-JSP/purchases.jsp?token=" + user_token);
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
                if (request.getParameter("search") == null) {
                    // Ketika pertama kali membuka catalog (tidak ada parameter search) 
                    List<Product> result = port.retrieveAllProduct(user_token);

                    // Ketika token sudah expired
                    if (result == null) {
                        response.sendRedirect("http://localhost:8080/KAA-JSP/login.jsp?"
                                + "message=expired");
                    } else {
                        if (result.size() == 0) {
                            out.print("<p>No product to be sold.</p>");
                        } else {
                            for (int i = 0; i < result.size(); i++) {
                                out.print("<script>getState('" + result.get(i).getUsername() + "','" + result.get(i).getProductId() + "');</script>");
                                out.print("<div id=\"status" + result.get(i).getUsername() + result.get(i).getProductId() +"\"></div>");
                                out.print("<a href=\"\"><div ng-click=\"setReceiver('" + result.get(i).getUsername() + "')\"><p><b>" + result.get(i).getUsername() + "</a></b><br/></div>");
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
                    try {
                        int choice_int = 0;
                        if (choice.equals("product")) {
                            choice_int = 0;
                        } else if (choice.equals("store")) {
                            choice_int = 1;
                        }

                        List<Product> result = port.searchProduct(search, user_token, choice_int);

                        /* Jika expired */
                        if (result == null) {
                            response.sendRedirect("http://localhost:8080/KAA-JSP/login.jsp?"
                                    + "message=expired");
                        } else {
                            if (result.size() == 0) {
                                out.print("<p>Nothing matches your search.</p>");
                            } else {
                                for (int i = 0; i < result.size(); i++) {
                                    out.print("<a href=\"\"><div ng-click=\"setReceiver('" + result.get(i).getUsername() + "')\"><b>" + result.get(i).getUsername() + "</a></b></div><br/>");
                                    out.print("added this on " + result.get(i).getDate().getDate() + "</p></div>");
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

            {{user}}
            <br>
            <div class="popup-box chat-popup" id="1" ng-show="isReceiverSet()" style="right: 0px; display: block;">
                <div class="popup-head">
                    <div class="popup-head-left">{{receiver}}</div>
                    <div class="popup-head-right" ng-click="setReceiver('')"><a href="">&#10005;</a></div>
                    <div style="clear: both"></div>
                </div>
                <div class="popup-messages">

                    <li ng-repeat="message in messages" style="list-style-type:none">
                        <div ng-if="(message.name === receiver) && (message.to === user)" class="talk-bubble tri-right left-top">
                            <div class="talktext">
                                <p>{{message.text}}</p>
                            </div>
                        </div>
                        <div ng-if="(message.name === user) && (message.to === receiver)" class="talk-bubble tri-right right-top">
                            <div class="talktext">
                                <p>{{message.text}}</p>
                            </div>
                        </div>
                    </li>
                </div>
                <div class="popup-input">
                    <input type="text" style="height: 100%; width:80%" name="chat" id="chat" hidefocus="hidefocus" ng-enter="sendMessage(newmessage);" ng-model="newmessage"/>
                    <button ng-click="sendMessage(newmessage);">Send</button>
                </div>
            </div>

            <!--        <div ng-app="chatApp" ng-controller="chatController">
                        <p>Name: <input type="text" ng-model="newmessage.user"></p>
                        <p>Message: <input type="text" ng-model="newmessage.text"></p>
                        <button ng-click="insert(newmessage)">Send</button>
                    
                        <ul>
                            <li ng-repeat="message in messages">
                                {{message.user}} send: {{message.text}}
                            </li>
                        </ul>
                    </div> -->


            <!--        <div ng-app="chatApp" ng-controller="chatController">
                        <p>Name: <input type="text" ng-model="newmessage.user"></p>
                        <p>Message: <input type="text" ng-model="newmessage.text"></p>
                        <button ng-click="insert(newmessage)">Send</button>
                    
                        <ul>
                            <li ng-repeat="message in messages">
                                {{message.user}} send: {{message.text}}
                            </li>
                        </ul>
                    </div> -->


            <script>
                document.getElementById("catalog").style.background="#0066ff";
                 document.getElementById("catalog").style.color="#ffffff";
            </script>
    </body>
</html>
