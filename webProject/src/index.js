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
import {BrandRankingPreview} from './brand.js';
import {MainRankingPreview} from './ranking_main.js';
import {RankingViewPage} from './ranking_tab.js'
import {ReviewPage} from './review.js'
import {ProductPopup, ReviewPopup} from './productDetail.js'
import {SignUp, SignIn, SignConnect} from './sign.js'
import {DB} from './firebaseInit.js'
import {PopupInfo} from "./manage";



document.addEventListener('DOMContentLoaded', function (event) {
  console.log("Dom content Loaded");

    //db 캐시화
    let db = new DB();
    db.init();
        const signUp = new SignUp(db);
        const signIn = new SignIn(db);
        const signConnect = new SignConnect();

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
    const mainGsBrandProduct = new ProductPopup(db,'#gs-item-wrapper','productSelect');
    const mainCuBrandProduct = new ProductPopup(db,'#cu-item-wrapper','productSelect');
    const mainSevenBrandProduct = new ProductPopup(db,'#seven-item-wrapper','productSelect');
    const carouselProduct = new ProductPopup(db,'#carouselSec','productSelect');
    const mainCategoryProduct = new ProductPopup(db,'.main-rank-content','productSelect');
    const rankTabProduct = new ProductPopup(db,'.ranking-item-list-wrapper','productSelect');
    const reviewTabReview = new ReviewPopup(db, '.review-item-list-wrapper','reviewSelect')

});

export class UpdateData{
    constructor(){
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

        //ranking_main.js
        const documentParams = {
            tab: '.main-rank-tab-wrapper',
            selected: 'main-rank-selectedtab',
            content: '.main-rank-content',
            template: '#card-ranking-template',
            check_key: 'main-rank-tab main-rank-selectedtab'
        };
        new MainRankingPreview(documentParams);

        //ranking_tab.js
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
    }
}

function enterKeyEvent() {
    if (window.event.keyCode === 13) {
        document.getElementsByClassName("fixTab-search-button")[0].click();
    }

}
window.enterKeyEvent = enterKeyEvent;


