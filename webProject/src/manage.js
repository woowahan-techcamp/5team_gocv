
import {BrandRankingPreview} from './brand.js';
import {MainRankingPreview} from './ranking_main.js';
import {RankingViewPage} from './ranking_tab.js'
import {ReviewPage} from './review.js'


// utils
export class TimeManager {
    constructor() {
        this.now = this.getNowTimeScore();
    }

    getNowTimeScore() {
        const d = new Date();
        const curr_date = d.getDate();
        const curr_month = d.getMonth() + 1; //Months are zero based
        const curr_year = d.getFullYear();
        const curr_hour = d.getHours();
        const curr_minute = d.getMinutes();
        const curr_second = d.getSeconds();

        let dateValue = 0;

        for (let x = 2016; x < curr_year; x++) {
            if (x % 4 == 0) {
                if (x % 100 != 0 || x % 400 == 0) {
                    dateValue += 366;
                }
            } else {
                dateValue += 365;
            }
        }

        for (let x = 1; x < curr_month; x++) {
            switch (x) {
                case 4:
                case 6:
                case 9:
                case 11:
                    dateValue += 31;
                    break;
                case 2:
                    dateValue += 28;
                default:
                    dateValue += 31;
                    break;
            }
        }

        dateValue += curr_date;


        let timeValue = 0;

        timeValue = curr_minute + (curr_hour * 60);
        const result = (dateValue * 24 * 60) + timeValue;

        return [dateValue, timeValue, result];
    }

    getDateTimeScore(param1, param2) {
        const splitDate = param1.split('-');

        const yy = parseInt(splitDate[0]);
        const mm = parseInt(splitDate[1]);
        const dd = parseInt(splitDate[2]);

        let dateValue = 0;

        for (let x = 2016; x < yy; x++) {
            if (x % 4 == 0) {
                if (x % 100 != 0 || x % 400 == 0) {
                    dateValue += 366;
                }
            } else {
                dateValue += 365;
            }
        }

        for (let x = 1; x < mm; x++) {
            switch (x) {
                case 4:
                case 6:
                case 9:
                case 11:
                    dateValue += 31;
                    break;
                case 2:
                    dateValue += 28;
                default:
                    dateValue += 31;
                    break;
            }
        }

        dateValue += dd;

        const splitTime = param2.split(':');

        const thh = parseInt(splitTime[0]);
        const tmm = parseInt(splitTime[1]);

        let timeValue = 0;

        timeValue = tmm + (thh * 60);
        const result = (dateValue * 24 * 60) + timeValue;

        return [dateValue, timeValue, result];
    }

    getDateWord(value) {
        let result;

        if (this.now[0] === value[0]) {
            if (this.now[1] === value[1]) {
                result = '방금 전';
            } else {
                if (this.now[1] - value[1] > 59) {
                    result = parseInt((this.now[1] - value[1]) / 60) + '시간 전';
                } else {
                    result = this.now[1] - value[1] + '분 전';
                }
            }
        } else if (this.now[0] - value[0] < 2) {
            if (this.now[1] < value[1]) {
                const cal = JSON.parse(JSON.stringify(this.now));

                cal[0]--;
                cal[1] += 1440;
                result = (cal[1] - value[1]) + (cal[0] - value[0]) * 1440;

            } else {
                result = (this.now[1] - value[1]) + (this.now[0] - value[0]) * 1440;
            }

            if (result > 1440) {
                result = parseInt(result / 1440) + '일 전';
            } else {
                result = parseInt(result / 60) + '시간 전';
            }
        } else if (this.now[0] - value[0] < 7) {
            result = this.now[0] - value[0] + '일 전';
        } else {
            result = parseInt(this.now[0] - value[0]) + '주일 전';
        }

        return result;
    }

    timestamp() {
        const d = new Date();
        let curr_date = d.getDate();
        let curr_month = d.getMonth() + 1; //Months are zero based
        let curr_year = d.getFullYear();
        let curr_hour = d.getHours();
        let curr_minute = d.getMinutes();
        let curr_second = d.getSeconds();

        if (curr_month < 10) {
            curr_month = "0" + curr_month;
        }

        if (curr_hour < 10) {
            curr_hour = "0" + curr_hour;
        }

        if (curr_minute < 10) {
            curr_minute = "0" + curr_minute;

        }

        if (curr_second < 10) {
            curr_second = "0" + curr_second;

        }

        return curr_year + "-" + curr_month + "-" + curr_date + " " +
            curr_hour + ":" + curr_minute + ":" + curr_second;
    }
}

export class BrandInfo {

    constructor() {

    }

    getBrandImage(value) {
        switch (value) {
            case 'gs25':
            case 'GS25':
                return './image/gs25.jpg';
            case 'cu':
            case 'CU':
                return './image/cu.jpg';
            case 'seven':
            case '7ELEVEN':
            case '7-eleven':
                return './image/seven.png';
            default:
                return './image/all_category.png';
        }
    }

    getBrandName(value) {
        switch (value) {
            case 'gs25':
            case 'GS25':
                return 'GS25';
            case 'cu':
            case 'CU':
                return 'CU';
            case 'seven':
            case '7ELEVEN':
                return '7-eleven';
            default:
                return 'all';
        }
    }
}

export class PopupInfo {
    constructor() {
        this.scrollEvent();
    }

    // My Page
    setMyPageInit() {
        this.myPageInit();
        this.getMyPageEvent();
    }

    // Sign Page 사용하지 않음
    setSignPageInit() {
        this.signPageInit();
        this.getSignPageEvent();
    }

    // Item Page
    setItemPageInit() {
        this.itemPageInit();
        this.getItemPageEvent();
    }


    // Review
    setReviewPageInit() {
        this.reviewPageInit();
        this.getReviewPageEvent();
    }

    myPageInit() {
        this.popupOverlay = document.querySelector('.myPage-overlay');
        this.popupInner = document.querySelector('.myPage-wrapper');

        $("body").css("overflow", "hidden");
    }

    getMyPageEvent() {
        /* item view modal settings */
        this.popupOverlay.addEventListener('click', function () {
            this.closePopup();

        }.bind(this));

        this.popupInner.addEventListener('click', function (e) {
            e.stopPropagation();
        }.bind(this));
    }

    closePopup() {
        $("body").css("overflow", "visible");
        document.getElementsByClassName('popup-close-fake')[0].click();
        this.moveBeforeElement();

    }

    setRefreshOverlay() {
        const itemPopup = document.querySelector('#popup');
        const myPagePopup = document.querySelector('#myPage');
        const fakeClose = document.getElementsByClassName('popup-close-fake')[0];

        itemPopup.addEventListener('click', function () {
            fakeClose.click();
        });

        myPagePopup.addEventListener('click', function () {
            fakeClose.click();
        })
    }


    signPageInit() {
        this.signOverlay = document.querySelector('.sign-overlay');
        this.signInner = document.querySelector('.sign-wrapper');

        $("body").css("overflow", "hidden");
    }

    getSignPageEvent() {
        this.signOverlay.addEventListener('click', function () {

            this.closePopup();

        }.bind(this));

        this.signInner.addEventListener('click', function () {
            e.stopPropagation();
        }.bind(this));


    }

    closeSignPagePopup() {

        this.signOverlay.style.display = "none";
        $("body").css("overflow", "visible");
        this.moveBeforeElement();

    }

    itemPageInit() {
        this.popupOverlay = document.querySelector('.overlay');
        this.popupInner = document.querySelector('.popup-wrapper');

        $("body").css("overflow", "hidden");
    }

    getItemPageEvent() {
        this.popupOverlay.addEventListener('click', function () {
            this.closePopup();

        }.bind(this));

        this.popupInner.addEventListener('click', function (e) {
            e.stopPropagation();
        }.bind(this));
    }

    reviewPageInit() {
        this.popupOverlay = document.querySelector('.overlay');
        this.popupInner = document.querySelector('.popup-review-preview');

        $("body").css("overflow", "hidden");
    }

    getReviewPageEvent() {
        this.popupOverlay.addEventListener('click', function () {
            this.closePopup();

        }.bind(this));

        this.popupInner.addEventListener('click', function (e) {
            e.stopPropagation();
        }.bind(this));
    }

    scrollEvent() {
        const that = this;
        $(window).scroll(function () {
            that.scroll = $(this).scrollTop();
        });
    }

    moveBeforeElement() {
        $(window).scrollTop(this.scroll);
    }
}

export class UpdateData {
    constructor() {
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