var config = {
    apiKey: "AIzaSyAnDViQ2LyXlNzBWO2kWyGnN-Lr22B9sUI",
    authDomain: "pyeonrehae.firebaseapp.com",
    databaseURL: "https://pyeonrehae.firebaseio.com",
    projectId: "pyeonrehae",
    storageBucket: "pyeonrehae.appspot.com",
    messagingSenderId: "296270517036"
};

firebase.initializeApp(config);

console.log('Firebase Caching');

const storage = localStorage['product'];

if(!storage){
  firebase.database().ref('product/')
  .once('value').then(function(snapshot) {

    localStorage['product'] = JSON.stringify(snapshot.val());

      console.log(storage)
  });
}

