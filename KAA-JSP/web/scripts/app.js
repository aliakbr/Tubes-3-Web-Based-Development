/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


var app =  angular.module('chatApp', []);

app.directive('ngEnter', function () {
    return function (scope, element, attrs) {
        element.bind("keydown keypress", function (event) {
            if(event.which === 13) {
                scope.$apply(function (){
                    scope.$eval(attrs.ngEnter);
                });
 
                event.preventDefault();
            }
        });
    };
});

app.controller('chatController', ['$scope','$http','Message', function($scope,$http,Message){
    name = document.getElementById("usernameangular").dataset.user;
    console.log(name);
    $scope.user = name;
    
    $scope.receiver = "";
    
    $scope.messages= Message.all;
    
    $scope.insert = function(message){
        Message.create(message);
    };  
    
    $scope.setUser = function(username){
        $scope.user = username;
    };
    
    $scope.setReceiver = function(username){
        $scope.receiver = username;
    };
    
    $scope.isReceiverSet = function(){
        return !($scope.receiver === "");
    };
    
    $scope.sendMessage = function(newmessage){
        //kirim post/get request ke sendmessage
        var newmessage1 = {'name':$scope.user,'to':$scope.receiver, 'text':newmessage};
        Message.all.push(newmessage1); //masukin ke data message lokal
        document.getElementById("chat").value = "";
        
        var paramSend = {
            username: $scope.user,
            usernamereceiver: $scope.receiver,
            text: newmessage
        };
        
       console.log("mau ngirim");
       console.log(paramSend);
       
        $http({method: "GET", url: "http://localhost:8080/ChatService/SendMessage", params: paramSend}).
        then(function(response) {
          console.log("harusnya berhasil");

          $scope.status = response.status;
          $scope.data = response.data;
        }, function(response) {
          $scope.data = response.data || 'Request failed';
          $scope.status = response.status;
        });
          console.log("berhasil keluar");
        
    };
    
    var config = {
        apiKey: "AIzaSyAQ2WIB6GWOxmtwMdGd8eHawL4PWxK8evU",
        authDomain: "tugas-besar-wbd.firebaseapp.com",
        databaseURL: "https://tugas-besar-wbd.firebaseio.com",
        storageBucket: "tugas-besar-wbd.appspot.com",
        messagingSenderId: "1049009619420"
    };
    firebase.initializeApp(config);
          
    const messaging = firebase.messaging();
    
    
    messaging.requestPermission()
      .then(function() {
        console.log('Notification permission granted.');
        return messaging.getToken();
        // TODO(developer): Retrieve an Instance ID token for use with FCM.
        // ...
      })
      .then(function(token){
          console.log(token); 
      })
      .catch(function(err) {
        console.log('Unable to get permission to notify.', err);

      });
      
    messaging.onMessage(function(payload) {
        console.log("Message received. ", payload.data);
        Message.create(payload.data);
        // ...
    });
}]);


app.factory('Message', function() {
    var messages = [{'name':'Pippo','text':'Hello'},
        {'name':'a','to':'azkaimtiyaz', 'text':'Hello'},
        {'name':'azkaimtiyaz','to':'a', 'text':'how are you ?'},
        {'name':'a','to':'azkaimtiyaz','text':'fine thanks'},
        {'name':'a','to':'azkaimtiyaz','text':'Bye'},
        {'name':'azkaimtiyaz','to':'a','text':'Bye'},
        {'name':'Pippo','text':'Hello'},
        {'name':'a','to':'azkaimtiyaz','text':'Hello'},
        {'name':'azkaimtiyaz','to':'a','text':'how are you ?'}];

    var Message = {
        all : messages,
        create: function(newmessage){
            return messages.push(newmessage);
        },
        delete: function(message){
            return messages.remove(message);
        },
        empty: function(){
            return messages = [];
        }
    };
        
    return Message;

});

/*app.factory('Message', function() {
//    var ref= new Firebase('https://kaa-saleproject.firebaseio.com');
 
/*    var messages = $firebase(ref.child('messages')).$asArray();
/*   var messages = [{'name':'Pippo','text':'Hello'},
        {'name':'Pluto','text':'Hello'},
        {'name':'Pippo','text':'how are you ?'},
        {'name':'Pluto','text':'fine thanks'},
        {'name':'Pippo','text':'Bye'},
        {'name':'Pluto','text':'Bye'}];*/

/*    var Message = {
        all : messages,
        create: function(message){
//            return messages.$add(message);
        },
/*        get: function(messageId){
            return $firebase(ref.child('messages').child(messageId)).$asObject();
        },*/
/*        delete: function(message){
            return messages.$remove(message);
        }
    };
/*    var Message = {
        all: messages
    };*/

//    return Message;

//});
