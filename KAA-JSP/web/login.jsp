<%@page import="org.saleproject.KAA.GetIP"%>
<%@page import="org.saleproject.KAA.RestAPI_consumer"%>
<%@page import="org.json.simple.parser.JSONParser"%>
<%@page import="java.net.HttpURLConnection"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.net.URLConnection"%>
<%@page import="java.net.URL"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <%
        /* Check the request */
        if (request.getParameter("submit") != null) {
            URL obj = null;
            try {
                /* Consuming API using GET method */
                String user = request.getParameter("username");
                String pass = request.getParameter("password");
                String userAgent = request.getHeader("user-agent");
                String userIP = GetIP.getClientIpAddress1(request);
                String urlParameter = "username=" + user + "&password=" + pass +
                        "&user_agent=" + userAgent + "&ip=" + userIP;
                String urlRequest = "http://localhost:8080/IdentService/login?";
                RestAPI_consumer consumer = new RestAPI_consumer(urlRequest, urlParameter);
                consumer.executePost();
                JSONObject responseJSON = consumer.getOutput();

                // REST API for Chat Service
                String chattoken = (String) request.getParameter("chattoken");
                Long uid = (Long) responseJSON.get("user_id");
                String username = (String) responseJSON.get("username");
                String urlParameter2 = "chattoken=" + chattoken + "&username=" + username
                        + "&user_id=" + uid;
                out.println(urlParameter2);
                String urlRequest2 = "http://localhost:8080/ChatService/TokenSaver?";
                RestAPI_consumer consumer2 = new RestAPI_consumer(urlRequest2, urlParameter2);
                consumer2.execute();
                
                /* Checking the response */
                String status = (String) responseJSON.get("status");
                String generatedToken = (String) responseJSON.get("token");
                if (status.equals("OK")) {
                    response.sendRedirect("http://localhost:8080/KAA-JSP/catalog."
                            + "jsp?token=" + generatedToken);
                } else {
                    response.sendRedirect("http://localhost:8080/KAA-JSP/login."
                            + "jsp?message=error");
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    %>
    <link href="css/style.css" rel="stylesheet" type="text/css"/>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Sale Project - Login</title>
        <link href="css/style.css" rel="stylesheet" type="text/css">        
    </head>

    <body>
        <div class="content">
            <div class="logo">
                <span id="red">Sale</span><span id="blue">Project</span>
            </div>
            <div class="title">
                Please login
            </div>
            <hr>
            <div>
                <form method= "GET">
                    <div class="input_field">
                        Email or username<br><input type="text" name="username"><br>
                    </div>
                    <div class="input_field">
                        Password<br><input type="password" name="password"><br>
                    </div>
                    <input type="hidden" name="chattoken" id="chattoken">
                    <div class="submit_button_add">
                        <input type="submit" name ="submit" value="LOGIN">
                    </div>
                </form>
            </div>
            <div>
                <br/>
                <b>Don't have account yet? Register <a href="register.jsp" class="register">here</a></b>
            </div>
            <div>
                <br />
                <%
                    /* Printing the message */
                    if (request.getParameter("message") != null) {
                        String message = request.getParameter("message");
                        if (message.equals("error")) {
                            out.println("Login Failed");
                        } else if (message.equals("logout")) {
                            out.println("Logged out!");
                        } else if (message.equals("expired")) {
                            out.println("Your token has expired!");
                        } else {
                            out.println(request.getParameter("message").toString());
                        }
                    }
                %>
            </div>
        </div>
        <script src="https://www.gstatic.com/firebasejs/3.6.1/firebase.js"></script>
        <script>
            // Initialize Firebase
            // Initialize Firebase
            /*var config = {
             apiKey: "AIzaSyAQ2WIB6GWOxmtwMdGd8eHawL4PWxK8evU",
             authDomain: "tugas-besar-wbd.firebaseapp.com",
             databaseURL: "https://tugas-besar-wbd.firebaseio.com",
             storageBucket: "tugas-besar-wbd.appspot.com",
             messagingSenderId: "1049009619420"
             };
             firebase.initializeApp(config);
             
             const messaging = firebase.messaging();
             messaging.requestPermission()
             .then(function(){
             console.log('Have Permission');
             return messaging.getToken();
             })
             .then(function(token){
             console.log(token);
             })
             .catch(function(err){
             console.log('Errorr');
             })
             */
        </script>
        <!-- Firebase -->
        <script src="https://www.gstatic.com/firebasejs/3.6.1/firebase.js"></script>
        <script>
            var config = {
                apiKey: "AIzaSyAQ2WIB6GWOxmtwMdGd8eHawL4PWxK8evU",
                authDomain: "tugas-besar-wbd.firebaseapp.com",
                databaseURL: "https://tugas-besar-wbd.firebaseio.com",
                storageBucket: "tugas-besar-wbd.appspot.com",
                messagingSenderId: "1049009619420"
            };
            firebase.initializeApp(config);
            
            messaging = firebase.messaging();

            messaging.requestPermission()
                    .then(function () {
                        console.log('Notification permission granted.');
                        return messaging.getToken();
                    })
                    .then(function (token) {
                        document.getElementById("chattoken").value = token;
                        console.log(token);
                    })
                    .catch(function (err) {
                        console.log('Unable to get permission to notify.', err);
                    });

            messaging.onMessage(function(payload) {
                console.log("Message received. ", payload.notification);
               });
            var chattoken= messaging.getToken();              
            var getChatToken=function(){  
                console.log(chattoken); 
                document.getElementById("chattoken").value = chattoken; 
            };
        </script>
    </body>
</html>
