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
const storage2 = localStorage['review'];

firebase.database().ref('product/')
    .once('value').then(function (snapshot) {

    localStorage['product'] = JSON.stringify(snapshot.val());

});



firebase.database().ref('review/')
    .once('value').then(function (snapshot) {

    localStorage['review'] = JSON.stringify(snapshot.val());

});

const value = {
  brand: 'all',
  category: '전체',
  keyword: ''
};

localStorage['search_keyword'] = JSON.stringify(value);
