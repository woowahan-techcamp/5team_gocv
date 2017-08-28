import "./ranking.js"
import "./brand.js"
import "./main.js"
import "./rankingTab.js"
import "./sign.js"
import "./review.js"

import "../style/index.css"
import "../style/productDetail.css"
import "../style/brand.css"
import "../style/ranking.css"
import "../style/main.css"
import "../style/rankingTab.css"
import "../style/sign.css"
import "../style/review-preivew.css"
import "../style/review.css"

import {SearchTab, Carousel, Counter, PopupOverlayClick } from './main.js';
import {BrandRankingPreview} from './brand.js';
import {MainRankingPreview} from './ranking.js';
import {RankingViewPage} from './rankingTab.js'
import {ReviewPage} from './review.js'

document.addEventListener('DOMContentLoaded', function (event) {
  console.log("Dom content Loaded");

    //db 캐시화
    const db = new DB();
    db.init();

    //main.js
    const searchTab = new SearchTab();
    const user = firebase.auth().currentUser;
    const carousel = new Carousel('reviewNavi', 'carousel-leftButton', 'carousel-rightButton', 10,
        'carousel-template', 'carouselSec');
    const counter = new Counter(800);
    const profileDrop = document.querySelector('.fixTab-profile-id');
    profileDrop.addEventListener("mouseover", function () {
        const dropdown = document.querySelector((".fixTab-profile-dropdown"));
        if (dropdown.style.display === "block") {
        } else {
            dropdown.style.display = "block";
        }
    });
    profileDrop.addEventListener("mouseout", function () {
        const dropdown = document.querySelector((".fixTab-profile-dropdown"));

        if (dropdown.style.display === "block") {
            dropdown.style.display = "none";
        }
    });
    // const popupOverlayClick = new PopupOverlayClick();
    setRefreshOverlay();

    //brand.js
    const gsParams = {
        brand: 'gs',
        leftBtn: 'gs-left-scroll',
        rightBtn: 'gs-right-scroll',
        // ul
        wrapper: '.brand-rank-item',
        template: 'brand-ranking-template',
        item_wrapper: 'gs-item-wrapper'
    };
    const cuParams = {
        brand: 'cu',
        leftBtn: 'cu-left-scroll',
        rightBtn: 'cu-right-scroll',
        // ul
        wrapper: '.brand-rank-item',
        template: 'brand-ranking-template',
        item_wrapper: 'cu-item-wrapper'
    };
    const sevenParams = {
        brand: 'seven',
        leftBtn: 'seven-left-scroll',
        rightBtn: 'seven-right-scroll',
        // ul
        wrapper: '.brand-rank-item',
        template: 'brand-ranking-template',
        item_wrapper: 'seven-item-wrapper'
    };

    new BrandRankingPreview(gsParams, 'GS25');
    new BrandRankingPreview(cuParams, 'CU');
    new BrandRankingPreview(sevenParams, '7-eleven');

    //ranking.js
    const documentParams = {
        tab: '.main-rank-tab-wrapper',
        selected: 'main-rank-selectedtab',
        content: '.main-rank-content',
        template: '#card-ranking-template',
        check_key: 'main-rank-tab main-rank-selectedtab'
    };
    new MainRankingPreview(documentParams);

    //rankingTab.js
    const rankingParams = {
        sort_tab: '.rank-query-type-wrapper',
        selected_sort: 'selected-rank-query-tab',
        sort_check_key: 'rank-query-tab selected-rank-query-tab',

        category_tab: '.rank-category-wrapper',
        selected_category: 'selected-rank-category-tab',
        category_check_key: 'rank-category-tab selected-rank-category-tab',

        brand_tab: '.rank-brand-type',
        selected_brand: 'selected-rank-brand-type-tab',
        brand_check_key: 'rank-brand-type-tab selected-rank-brand-type-tab',

        template: '#rank-card-template',
        content: '.ranking-item-list-wrapper'
    };
    new RankingViewPage(rankingParams);

    //review.js
    const reviewParams = {
        sort_tab: '.review-query-type-wrapper',
        selected_sort: 'selected-review-query-tab',
        sort_check_key: 'review-query-tab selected-review-query-tab',
        template: '#card-review-page-template',
        content: '.review-item-list-wrapper',
        readmore: 'review-card-readmore'
    };
    new ReviewPage(reviewParams);


});


function setRefreshOverlay(){
    const popup = document.querySelector('#popup');

    popup.addEventListener('click', function () {
        document.getElementsByClassName('popup-close-fake')[0].click();
    });
}

//DB 를 캐시화 해놓고 업데이트 해주는 클래스
export class DB {
    constructor(user, product, review) {
        this.user = user;
        this.product = product;
        this.review = review;
    }

    init() {
        const config = {
            apiKey: "AIzaSyAnDViQ2LyXlNzBWO2kWyGnN-Lr22B9sUI",
            authDomain: "pyeonrehae.firebaseapp.com",
            databaseURL: "https://pyeonrehae.firebaseio.com",
            projectId: "pyeonrehae",
            storageBucket: "pyeonrehae.appspot.com",
            messagingSenderId: "296270517036"
        };

        firebase.initializeApp(config);

        const value = {
            brand: 'all',
            category: '전체',
            keyword: ''
        };
        localStorage['search_keyword'] = JSON.stringify(value);

        this.updateUserDb();
        this.updateProductDb();
        this.updateReviewDb();

        this.user = JSON.parse(localStorage['user']);
        this.product = JSON.parse(localStorage['product']);
        this.review = JSON.parse(localStorage['review']);
    }

    updateUserDb() {
        firebase.database().ref('user/').once('value').then(function (snapshot) {
            localStorage['user'] = JSON.stringify(snapshot.val());
            this.user = JSON.parse(localStorage['user']);
            document.querySelector('#loading').style.display = "none"
            console.log("user 캐시 업데이트")

        }.bind(this));
    }

    updateReviewDb() {
        firebase.database().ref('review/').once('value').then(function (snapshot) {
            localStorage['review'] = JSON.stringify(snapshot.val());
            this.product = JSON.parse(localStorage['review']);
            document.querySelector('#loading').style.display = "none"
            console.log("review 캐시 업데이트")

        }.bind(this));
    }

    updateProductDb() {
        firebase.database().ref('product/').once('value').then(function (snapshot) {
            localStorage['product'] = JSON.stringify(snapshot.val());
            this.review = JSON.parse(localStorage['product']);
            document.querySelector('#loading').style.display = "none"
            console.log("product 캐시 업데이트")
        }.bind(this));
    }
}
