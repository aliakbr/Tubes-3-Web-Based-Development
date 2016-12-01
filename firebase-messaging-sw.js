// Give the service worker access to Firebase Messaging.
// Note that you can only use Firebase Messaging here, other Firebase libraries
// are not available in the service worker.
importScripts('https://www.gstatic.com/firebasejs/3.5.2/firebase-app.js');
importScripts('https://www.gstatic.com/firebasejs/3.5.2/firebase-messaging.js');

var config = {
          apiKey: "AIzaSyAQ2WIB6GWOxmtwMdGd8eHawL4PWxK8evU",
          authDomain: "tugas-besar-wbd.firebaseapp.com",
          databaseURL: "https://tugas-besar-wbd.firebaseio.com",
          storageBucket: "tugas-besar-wbd.appspot.com",
          messagingSenderId: "1049009619420"
};
firebase.initializeApp(config);

// Initialize the Firebase app in the service worker by passing in the
// messagingSenderId.
//firebase.initializeApp({
 // 'messagingSenderId': 'YOUR-SENDER-ID'
//});

// Retrieve an instance of Firebase Messaging so that it can handle background
// messages.
const messaging = firebase.messaging();