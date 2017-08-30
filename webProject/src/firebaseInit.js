import {SignIn} from './sign.js'


export class DB {
    constructor(user, product, review) {
        this.user = user;
        this.product = product;
        this.review = review;
    }

    init() {
        const config = {
            apiKey: "AIzaSyBA14XngeEDe4DV32NSs07PWdW1LX8sxu8",
            authDomain: "prh-woowa.firebaseapp.com",
            databaseURL: "https://prh-woowa.firebaseio.com",
            projectId: "prh-woowa",
            storageBucket: "prh-woowa.appspot.com",
            messagingSenderId: "947458280146"
        };
        firebase.initializeApp(config);

    }

    dataInit(){
        const value = {
            brand: 'all',
            category: '전체',
            keyword: ''
        };

        this.updateAllDb();

        localStorage['search_keyword'] = JSON.stringify(value);

        this.user = JSON.parse(localStorage['user']);
        this.product = JSON.parse(localStorage['product']);
        this.review = JSON.parse(localStorage['review']);

    }

    updateDb(name) {
        firebase.database().ref(name + '/').once('value').then(function (snapshot) {
            localStorage[name] = JSON.stringify(snapshot.val());
            this.user = JSON.parse(localStorage[name]);
            document.querySelector('#loading').style.display = "none";
            console.log(name + " 캐시 업데이트")
        }.bind(this));
    }

    updateAllDb() {
        this.updateUserDb();
        this.updateReviewDb();
        this.updateProductDb();
    }

    updateUserDb(func) {
        firebase.database().ref('user/').once('value').then(function (snapshot) {
            localStorage['user'] = JSON.stringify(snapshot.val());
            this.user = JSON.parse(localStorage['user']);
            document.querySelector('#loading').style.display = "none";
            console.log("user 캐시 업데이트")

        }.bind(this));
    }

    updateReviewDb() {
        firebase.database().ref('review/').once('value').then(function (snapshot) {
            localStorage['review'] = JSON.stringify(snapshot.val());
            this.review = JSON.parse(localStorage['review']);
            document.querySelector('#loading').style.display = "none";
            console.log("review 캐시 업데이트")

        }.bind(this));
    }

    updateProductDb() {
        firebase.database().ref('product/').once('value').then(function (snapshot) {
            localStorage['product'] = JSON.stringify(snapshot.val());
            this.product = JSON.parse(localStorage['product']);
            document.querySelector('#loading').style.display = "none";
            console.log("product 캐시 업데이트")
        }.bind(this));
    }
}