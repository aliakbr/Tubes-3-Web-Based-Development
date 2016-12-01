<%-- 
    Document   : register
    Created on : Nov 6, 2016, 11:35:02 PM
    Author     : khrs
--%>

<%@page import="org.saleproject.KAA.GetIP"%>
<%@page import="java.io.OutputStreamWriter"%>
<%@page import="java.io.DataOutputStream"%>
<%@page import="java.nio.charset.StandardCharsets"%>
<%@page import="org.json.simple.parser.JSONParser"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.net.HttpURLConnection"%>
<%@page import="java.net.URL"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
     <%
        /* Check the request */
         String message = null;
        if (request.getMethod().equals("POST")){
            URL obj = null;
            try{
                /* POST METHOD */
                String fullname = request.getParameter("fullname");
                String username = request.getParameter("username");
                String email = request.getParameter("email");
                String password = request.getParameter("password");
                String fulladdress = request.getParameter("fulladdress");
                String postalcode = request.getParameter("postalcode");
                String phonenumber = request.getParameter("phonenumber");
                String userAgent = request.getHeader("user-agent");
                String userIP = GetIP.getClientIpAddress(request);
                

                String urlParameters  = 
                        "fullname="+fullname+
                        "&username="+username+ 
                        "&password=" +password+
                        "&email="+email+
                        "&fulladdress=" +fulladdress+
                        "&postalcode=" + postalcode + 
                        "&phonenumber=" + phonenumber+
                        "&user_agent=" + userAgent + "&ip=" + userIP;

                String urlRequest = "http://localhost:8080/IdentService/register";       
                obj = new URL(urlRequest);
                HttpURLConnection con = (HttpURLConnection) obj.openConnection();
                 con.setDoOutput( true );
                con.setRequestMethod( "POST" );
                DataOutputStream wr = new DataOutputStream(con.getOutputStream());
                wr.writeBytes(urlParameters);
                wr.flush();
                wr.close();
                con.setReadTimeout(15*1000);
                con.connect();
                BufferedReader br = new BufferedReader(new InputStreamReader((con.getInputStream())));
                StringBuilder sb = new StringBuilder();
                String output;
                while ((output = br.readLine()) != null) {
                    sb.append(output);
                }
                
                 /* Parsing */
                JSONParser parser = new JSONParser();
                JSONObject responseJSON = (JSONObject)parser.parse(sb.toString());
                
                /* Checking the response */
                String status = (String)responseJSON.get("status");
                if (status.equals("OK")){
                    String generatedToken = (String)responseJSON.get("token");
                    response.sendRedirect("http://localhost:8080/KAA-JSP/catalog."
                            + "jsp?token="+generatedToken);
                }
                else{
                    message = (String) responseJSON.get("message");
                }
            }
            catch(Exception e){
                e.printStackTrace();
            }
        }
        
        /* POST METHOD */
        /* String urlRequest = "http://localhost:8080/IdentService/login";
        URL obj = new URL(urlRequest);
        HttpURLConnection con = (HttpURLConnection) obj.openConnection();
        String urlParameters  = "username=a&password=a";
        byte[] postData       = urlParameters.getBytes( StandardCharsets.UTF_8 );
        int    postDataLength = postData.length;        
        con.setDoOutput( true );
        con.setInstanceFollowRedirects( false );
        con.setRequestMethod( "POST" );
        con.setRequestProperty( "Content-Type", "application/x-www-form-urlencoded"); 
        con.setRequestProperty( "charset", "utf-8");
        con.setRequestProperty( "Content-Length", Integer.toString( postDataLength ));
        con.setUseCaches( false );
        try( DataOutputStream wr = new DataOutputStream( con.getOutputStream())) {
           wr.write( postData );
        } */
    %>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>Sale Project - Register</title>
	<link href="css/style.css" rel="stylesheet" type="text/css">
    </head>
    <body>
	<div class="catalog_content">
            <div>
                <%
                    if (request.getParameter("submit") != null){
                        out.println(message);
                    }
                %>
            </div>
            <div class="logo">
                <span id="red">Sale</span><span id="blue">Project</span>
            </div>
            <div class="title">
                Please register
            </div>
            <hr>
            <div>
            <form name="user_data" method="POST" onsubmit="return validateForm()" id="user_data_input">
                <div class="input_field">
                    Full name<br><input type="text" name="fullname"><br>
                </div>
                <div class="input_field">
                    Username<br><input type="text" name="username"><br>
                </div>
                <div class="input_field">
                    Email<br><input type="text" name="email" autocomplete="off"><br>
                </div>
                <div class="input_field">
                    Password<br><input type="password" name="password"><br>
                </div>
                <div class="input_field">
                    Confirm Password<br><input type="password" name="confirmpassword"><br>
                </div>
                <div class="input_field">
                    Full Address<br><textarea type="text" name="fulladdress" rows="3"></textarea><br>
                </div>
                <div class="input_field">
                    Postal Code<br><input type="text" name="postalcode"><br>
                </div>
                <div class="input_field">
                    Phone Number<br><input type="text" name="phonenumber"><br>
                </div>
                <div style="padding-left: 91%;">
                    <input type="submit" value="REGISTER">
                </div>
                <input type="hidden" name="chattoken" id="chattoken">
            </form>
            </div>
            <div>
                <br/>
                <b>Already registered? Login <a href="http://localhost:8080/login.jsp" class="register">here</a></b>
            </div>
	</div>
	</div>
	<script>
	function validateForm(){
            var x = document.forms["user_data"]["fullname"].value;
            if (x == null || x == "") {
                alert("Fullname must be filled out");
                return false;
            }
            x = document.forms["user_data"]["username"].value;
            if (x == null || x == "") {
                alert("Username must be filled out");
                return false;
            }
            x = document.forms["user_data"]["email"].value;
            if (x == null || x == "") {
                alert("Email must be filled out");
                return false;
            }
            pola_email=/^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/;
            if (!pola_email.test(x)){
                alert("Email not in the correct form");
                return false;
            }
            x = document.forms["user_data"]["password"].value;
            if (x == null || x == "") {
                alert("Password must be filled out");
                return false;
            }
            x = document.forms["user_data"]["confirmpassword"].value;
            if (x == null || x == "") {
                alert("Confirmed password must be filled out");
                return false;
            } else if (x != document.forms["user_data"]["password"].value){
                alert("Confirmed password must be same with password");
                return false;
            }
            x = document.forms["user_data"]["fulladdress"].value;
            if (x == null || x == "") {
                alert("Full address must be filled out");
                return false;
            }
            pola_angka=/^[0-9]+[0-9]*$/;
            x = document.forms["user_data"]["postalcode"].value;
            if (x == null || x == "") {
                alert("Postal code must be filled out");
                return false;
            }
            if (!pola_angka.test(x) || x.length != 5) {
                alert("Please insert a valid postal code");
                return false;
            }
            x = document.forms["user_data"]["phonenumber"].value;
            if (x == null || x == "") {
                alert("Phone number must be filled out");
                return false;
            }		
            if ((!pola_angka.test(x)) || x.length < 6 || x.length > 13) {
                alert("Please insert a valid phone number");
                return false;
            }
            return (true);
	}
	</script
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
                        // TODO(developer): Retrieve an Instance ID token for use with FCM.
                        // ...

                    })
                    .then(function (token) {
                        document.getElementById("chattoken").value = token;
                        console.log(token);
                    })
                    .catch(function (err) {
                        console.log('Unable to get permission to notify.', err);
                    });

            
              var chattoken= messaging.getToken();
              
                console.log(chattoken);
              
              var getChatToken=function(){  
                console.log(chattoken); 
                document.getElementById("chattoken").value = chattoken; 
               };
        </script>
    </body>
</html>
