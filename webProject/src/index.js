//js bundle
import "./firebaseInit.js"
import "./ranking_main.js"
import "./brand.js"
import "./main.js"
import "./ranking_tab.js"
import "./sign.js"
import "./review.js"
import "./manage.js"

//css bundle
import "../style/index.css"
import "../style/productDetail.css"
import "../style/brand.css"
import "../style/ranking.css"
import "../style/main.css"
import "../style/rankingTab.css"
import "../style/sign.css"
import "../style/review-preivew.css"
import "../style/review.css"

//class import
import {SearchTab, Carousel, Counter} from './main.js';
import {ProductPopup, ReviewPopup} from './productDetail.js'
import {SignUp, SignIn, SignConnect} from './sign.js'
import {DB} from './firebaseInit.js'
import {PopupInfo, UpdateData} from "./manage";


document.addEventListener('DOMContentLoaded', function (event) {
    // console.log("Dom content Loaded");

    document.querySelector('#loading').style.display = "block";

    //db 캐시화
    let db = new DB();
    db.init();
    db.dataInit();

    const signUp = new SignUp(db);
    const signIn = new SignIn(db);
    const signConnect = new SignConnect()

    //main.js
    const searchParams = {
        brand: '.fixTab-search-brand',
        brand_dropdown: '.fixTab-search-brand-dropdown',
        category: '.fixTab-search-category',
        category_drowndown: '.fixTab-search-category-dropdown',
        text: '.fixTab-search-word',
        button: '.fixTab-search-button'
    };

    const searchTab = new SearchTab(searchParams);
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

    //
    new PopupInfo().setRefreshOverlay();
    new UpdateData();


    //productDetail.js
    const mainGsBrandProduct = new ProductPopup(db, '#gs-item-wrapper', 'productSelect');
    const mainCuBrandProduct = new ProductPopup(db, '#cu-item-wrapper', 'productSelect');
    const mainSevenBrandProduct = new ProductPopup(db, '#seven-item-wrapper', 'productSelect');
    const carouselProduct = new ProductPopup(db, '#carouselSec', 'productSelect');
    const mainCategoryProduct = new ProductPopup(db, '.main-rank-content', 'productSelect');
    const rankTabProduct = new ProductPopup(db, '.ranking-item-list-wrapper', 'productSelect');
    const reviewTabReview = new ReviewPopup(db, '.review-item-list-wrapper', 'reviewSelect')

});


function enterKeyEvent() {
    if (window.event.keyCode === 13) {
        document.getElementsByClassName("fixTab-search-button")[0].click();
    }

}

window.enterKeyEvent = enterKeyEvent;


