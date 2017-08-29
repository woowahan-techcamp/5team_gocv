import {TimeManager} from "./manage";

//드롭다운 만드는 클래스
export class Dropdown {

    constructor(event, button, drop) {
        this.event = event;
        this.button = button;
        this.drop = drop;
        this.init();
    }

    init() {
        this.button = document.querySelector(this.button);
        this.drop = document.querySelector(this.drop);
        this.setEvent();
    }

    setEvent() {
        this.button.addEventListener(this.event, function () {

            if (this.drop.style.display === "block") {
                this.drop.style.display = "none";
            } else {
                this.drop.style.display = "block";
            }
        }.bind(this), true);
    }
}

//ajax , handbar.js template 관련 기능
export class Util {

    ajax(func) {
        const oReq = new XMLHttpRequest();
        oReq.addEventListener('load', function (e) {
            const data = JSON.parse(oReq.responseText);
            func.setData(data);
        });

        oReq.open('GET', func.url);
        oReq.send();
    }

    template(data, template, section) {
        const context = data;
        const tmpl = Handlebars.compile(template);
        section.innerHTML = tmpl(context);
    }

    setHandlebars(value) {
        let i = 0;
        for (const x of value) {
            $("#carousel-review-star" + i).rateYo({
                rating: x.grade,
                readOnly: true,
                spacing: "10px",
                starWidth: "20px",
                normalFill: "#e2dbd6",
                ratedFill: "#ffcf4d"
            });
            i++;
        }
    }
}

//main 상단 리뷰 캐러셀
export class Carousel {

    constructor(reviewNavi, leftButton, rightButton, count, template, sec) {
        this.reviewNavi = reviewNavi;
        this.leftButton = leftButton;
        this.rightButton = rightButton;
        this.count = count;
        this.template = template;
        this.sec = sec;
        this.data = [];
        this.index = 0;

        this.manager = new TimeManager();

        this.now = this.manager.getNowTimeScore();
        this.init();
    }

    init() {
        this.leftButton = document.getElementById(this.leftButton);
        this.rightButton = document.getElementById(this.rightButton);
        this.template = document.getElementById(this.template).innerHTML;
        this.sec = document.getElementById(this.sec);
        this.leftButton.addEventListener("click", function () {
            this.beforePage();
        }.bind(this));
        this.rightButton.addEventListener("click", function () {
            this.nextPage();
        }.bind(this));
        this.setData();
    }

    changeIndex(value) {
        this.index += value;
    }

    setDurationZero() {
        this.reviewNavi.style.transition = "none";
    }

    setDurationfull() {
        this.reviewNavi.style.transition = "";
        this.reviewNavi.style.transitionDuration = "1s";
    }

    nextPage() {
        this.setDurationfull();
        this.changeIndex(1);
        const left = (this.index + 1) * 100;
        this.reviewNavi.style.left = "-" + left + "%";
        if (this.index === this.count) {

            this.index = 0;
            this.rightButton.disabled = true;

            setTimeout(function () {
                this.setDurationZero();
                this.reviewNavi.style.left = "-100%";
                this.rightButton.disabled = false;
            }.bind(this), 1000);

        }

        this.changeCircle();
    }

    beforePage() {
        this.setDurationfull();
        this.changeIndex(-1);
        const left = (this.index + 1) * 100;
        this.reviewNavi.style.left = "-" + left + "%";


        if (this.index === -1) {
            this.index = 9;
            this.leftButton.disabled = true;

            setTimeout(function () {
                this.setDurationZero();
                this.reviewNavi.style.left = "-1000%";
                this.leftButton.disabled = false;
            }.bind(this), 1000);
        }

        this.changeCircle();

    }

    changeCircle() {
        const beforeCircle = document.querySelector(".carousel-circle-selected");
        beforeCircle.setAttribute("class", "carousel-circle");

        const arr = Array.from(document.querySelectorAll(".carousel-circle"));
        arr[this.index].setAttribute("class", "carousel-circle carousel-circle-selected");
    }


    setData() {
        const review = localStorage['review'];
        this.data = JSON.parse(review);

        const fakeArr = [];
        const queryObj = [];

        for (const key in this.data) {
            const value = this.data[key];

            const time = value.timestamp;

            const splitTimeStamp = time.split(' ');

            value['time_score'] = this.manager.getDateTimeScore(splitTimeStamp[0], splitTimeStamp[1]);

            const dateValue = this.manager.getDateWord(value.time_score);

            value['date'] = (!!dateValue) ? dateValue : splitTimeStamp[0];

            queryObj.push(value);
        }

        queryObj.sort(function (a, b) {
            const beforeUseful = parseFloat(a.useful);
            const afterUseful = parseFloat(b.useful);

            if (beforeUseful < afterUseful) {
                return 1;
            } else if (beforeUseful > afterUseful) {
                return -1;
            } else {
                return 0;
            }
        });

        const fakeBeforeValue = this.clone(queryObj[9]);
        fakeBeforeValue["rating"] = "carousel-rank-rating" + '0';

        const fakeAfterValue = this.clone(queryObj[0]);
        fakeAfterValue["rating"] = "carousel-rank-rating" + '11';

        const arr = [];

        arr.push(fakeBeforeValue);
        for (let i = 0; i <= 9; i++) {
            const value = queryObj[i];

            value["rating"] = "carousel-rank-rating" + (i + 1);

            arr.push(value);
        }
        arr.push(fakeAfterValue);

        const util = new Util();

        util.template(arr, this.template, this.sec);
        this.reviewNavi = document.getElementById(this.reviewNavi);

        this.setRatingHandler(arr);
    }

    clone(obj) {
        if (obj === null || typeof(obj) !== 'object')
            return obj;
        const copy = obj.constructor();
        for (const attr in obj) {
            if (obj.hasOwnProperty(attr)) {
                copy[attr] = obj[attr];
            }
        }
        return copy;
    }

    setRatingHandler(value) {
        let i = 0;
        for (const x of value) {
            $('#carousel-rank-rating' + i).rateYo({
                rating: x.grade,
                readOnly: true,
                spacing: "10px",
                starWidth: "20px",
                normalFill: "#e2dbd6",
                ratedFill: "#ffcf4d"
            });
            i++;
        }
    }

}

// 메시지 토스트 기능
export class Toast {
    constructor(message) {
        this.message = message;
        this.setEvent();
    }

    setEvent() {

        const element = document.querySelector('#toast-msg')
        element.innerHTML = this.message;
        // element.style.display = 'block'
        element.style.display = "block";
        setTimeout(function () {
            // element.style.display = 'none'
            element.style.display = "none";

        }, 1000)
    }
}

//메인 상단 고정 탭
export class SearchTab {
    constructor(searchParams) {
        this.brandDrop = document.querySelector(searchParams.brand);
        this.brandNavi = document.querySelector(searchParams.brand_dropdown);
        this.categoryDrop = document.querySelector(searchParams.category);
        this.categoryNavi = document.querySelector(searchParams.category_drowndown);
        this.inputText = document.querySelector(searchParams.text);
        this.searchButton = document.querySelector(searchParams.button);
        this.fixTabNavi = document.querySelector("#fixTabNavi");
        this.searchParams = searchParams;
        this.init();
    }

    init() {
        this.dropdownEvent();
        this.setTabClickEvent();
    }

    dropdownEvent() {
        const brandDrop = new Dropdown("click", this.searchParams.brand, this.searchParams.brand_dropdown);
        const categoryDrop = new Dropdown("click", this.searchParams.category, this.searchParams.category_drowndown);


        this.brandNavi.addEventListener("click", function (event) {
            this.brandDrop.firstChild.innerText = event.toElement.innerText;
        }.bind(this));

        this.categoryNavi.addEventListener("click", function (event) {
            this.categoryDrop.firstChild.innerText = event.toElement.innerText;
        }.bind(this));

        this.searchButton.addEventListener("click", function () {
            this.setQuery();
            new Toast("검색 결과입니다.")
            document.querySelector(".main-wrapper").style.display = "none";
            document.querySelector(".review-container").style.display = "none";
            document.querySelector(".rank-container").style.display = "";
        }.bind(this));
    }


    setQuery() {
        const queryBrand = this.brandDrop.firstChild.innerText;
        const queryCategory = this.categoryDrop.firstChild.innerText;

        const brand = (queryBrand === '브랜드') ? 'all' : queryBrand;
        const category = (queryCategory === '카테고리') ? '전체' : queryCategory;
        const text = this.inputText.value;

        const value = {
            brand: brand,
            category: category,
            keyword: text
        };

        localStorage['search_keyword'] = JSON.stringify(value);
    }

    setTabClickEvent() {
        this.fixTabNavi.addEventListener('click', function (e) {

            const selectedTab = document.getElementsByClassName("fixTab-select")[0];

            selectedTab.classList.remove("fixTab-select");
            e.target.classList.add("fixTab-select");

            const text = document.getElementsByClassName("fixTab-select")[0].innerHTML;

            const value = {
                brand: 'all',
                category: '전체',
                keyword: ''
            };

            localStorage['search_keyword'] = JSON.stringify(value);

            if (text === "편리해") {
                document.querySelector(".main-wrapper").style.display = "";
                document.querySelector(".rank-container").style.display = "none";
                document.querySelector(".review-container").style.display = "none";
            } else if (text === "랭킹") {
                document.querySelector(".main-wrapper").style.display = "none";
                document.querySelector(".rank-container").style.display = "";
                document.querySelector(".review-container").style.display = "none";
            } else if (text === "리뷰") {
                document.querySelector(".main-wrapper").style.display = "none";
                document.querySelector(".rank-container").style.display = "none";
                document.querySelector(".review-container").style.display = "";
            }

        }.bind(this));
    }

}

//메인 하단 jquery plugin 을 이용한 counter, 매개변수는 스크롤 위치를 의미
export class Counter {
    constructor(max) {
        this.max = max;
        this.c1 = 0;
        this.c2 = 0;
        this.c3 = 0;

        const manager = new TimeManager();
        this.timestamp = manager.timestamp();

        this.setData();
        this.setAnimation();
    }

    setAnimation() {
        window.addEventListener('scroll', function (e) {
            let val = $(window).scrollTop();
            let max = this.max;
            const cover = $('.cover');

            if (max < val) {
                $('#counter1').animateNumber({number: this.c1}, 2000);
                $('#counter2').animateNumber({number: this.c2}, 2000);
                $('#counter3').animateNumber({number: this.c3}, 2000);
                this.max = 99999;
            }
        }.bind(this));
    }

    setData() {
        const productStorage = localStorage['product'];
        const productData = JSON.parse(productStorage);

        const reviewStorage = localStorage['review'];
        const reviewData = JSON.parse(reviewStorage);

        const productCount = Object.keys(productData).length;
        const reviewCount = Object.keys(reviewData).length;
        let todayReviewCount = 0;

        Object.keys(reviewData).forEach(function (e) {
            if (this.timestamp.split(" ")[0] === reviewData[e].timestamp.split(" ")[0]) {
                todayReviewCount += 1;
            }
        }.bind(this));

        this.c1 = parseInt(productCount);
        this.c2 = parseInt(reviewCount);
        this.c3 = parseInt(todayReviewCount);


    }
}
