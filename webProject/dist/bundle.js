/******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};
/******/
/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {
/******/
/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId]) {
/******/ 			return installedModules[moduleId].exports;
/******/ 		}
/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			i: moduleId,
/******/ 			l: false,
/******/ 			exports: {}
/******/ 		};
/******/
/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);
/******/
/******/ 		// Flag the module as loaded
/******/ 		module.l = true;
/******/
/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}
/******/
/******/
/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;
/******/
/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;
/******/
/******/ 	// define getter function for harmony exports
/******/ 	__webpack_require__.d = function(exports, name, getter) {
/******/ 		if(!__webpack_require__.o(exports, name)) {
/******/ 			Object.defineProperty(exports, name, {
/******/ 				configurable: false,
/******/ 				enumerable: true,
/******/ 				get: getter
/******/ 			});
/******/ 		}
/******/ 	};
/******/
/******/ 	// getDefaultExport function for compatibility with non-harmony modules
/******/ 	__webpack_require__.n = function(module) {
/******/ 		var getter = module && module.__esModule ?
/******/ 			function getDefault() { return module['default']; } :
/******/ 			function getModuleExports() { return module; };
/******/ 		__webpack_require__.d(getter, 'a', getter);
/******/ 		return getter;
/******/ 	};
/******/
/******/ 	// Object.prototype.hasOwnProperty.call
/******/ 	__webpack_require__.o = function(object, property) { return Object.prototype.hasOwnProperty.call(object, property); };
/******/
/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "/dist";
/******/
/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(__webpack_require__.s = 0);
/******/ })
/************************************************************************/
/******/ ([
/* 0 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


__webpack_require__(1);

__webpack_require__(2);

__webpack_require__(3);

__webpack_require__(4);

__webpack_require__(5);

__webpack_require__(6);

__webpack_require__(7);

__webpack_require__(8);

__webpack_require__(9);

__webpack_require__(10);

__webpack_require__(11);

__webpack_require__(12);

/***/ }),
/* 1 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


var config = {
    apiKey: "AIzaSyAnDViQ2LyXlNzBWO2kWyGnN-Lr22B9sUI",
    authDomain: "pyeonrehae.firebaseapp.com",
    databaseURL: "https://pyeonrehae.firebaseio.com",
    projectId: "pyeonrehae",
    storageBucket: "pyeonrehae.appspot.com",
    messagingSenderId: "296270517036"
};

firebase.initializeApp(config);

var storage = localStorage['product'];
var storage2 = localStorage['review'];

firebase.database().ref('product/').once('value').then(function (snapshot) {

    localStorage['product'] = JSON.stringify(snapshot.val());
});

firebase.database().ref('review/').once('value').then(function (snapshot) {

    localStorage['review'] = JSON.stringify(snapshot.val());
});

var value = {
    brand: 'all',
    category: '전체',
    keyword: ''
};

localStorage['search_keyword'] = JSON.stringify(value);

/***/ }),
/* 2 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

document.addEventListener('DOMContentLoaded', function (event) {
    var documentParams = {
        tab: '.main-rank-tab-wrapper',
        selected: 'main-rank-selectedtab',
        content: '.main-rank-content',
        template: '#card-ranking-template',
        check_key: 'main-rank-tab main-rank-selectedtab'
    };

    new MainRankingPreview(documentParams);
});

// main 인기 있는 리뷰 설정

var MainRankingPreview = function () {
    function MainRankingPreview(documentParams) {
        _classCallCheck(this, MainRankingPreview);

        this.rank_tab = document.querySelector(documentParams.tab);
        this.template = document.querySelector(documentParams.template).innerHTML;
        this.rank_content = document.querySelector(documentParams.content);
        this.selected = documentParams.selected;
        this.check_key = documentParams.check_key;
        var product = localStorage['product'];
        this.obj = JSON.parse(product);

        this.init();
    }

    _createClass(MainRankingPreview, [{
        key: 'init',
        value: function init() {
            this.tabClickEvent(this.selected, this.check_key);
            document.getElementsByClassName(this.selected)[0].click();
        }
    }, {
        key: 'tabClickEvent',
        value: function tabClickEvent(selectedClassName, key) {
            this.rank_tab.addEventListener('click', function (e) {
                var selectedTab = document.getElementsByClassName(selectedClassName)[0];

                selectedTab.classList.remove(selectedClassName);
                e.target.classList.add(selectedClassName);

                var changeSelectedTab = document.getElementsByClassName(selectedClassName)[0];

                if (changeSelectedTab.getAttribute('class') == key) {
                    var requestParam = changeSelectedTab.getAttribute('name');
                    this.queryData(requestParam);
                } else {
                    e.target.classList.remove(selectedClassName);
                    selectedTab.classList.add(selectedClassName);
                }
            }.bind(this));
        }
    }, {
        key: 'queryData',
        value: function queryData(value) {
            var queryObj = [];

            for (var key in this.obj) {
                if (this.obj[key].category === value) {
                    queryObj.push(this.obj[key]);
                }
            }

            var sortObj = this.setGradeSort(queryObj);

            var data = sortObj.slice(0, 3);
            this.setRankingData(data);
        }
    }, {
        key: 'setGradeSort',
        value: function setGradeSort(array) {
            array.sort(function (a, b) {
                var beforeGrade = parseFloat(a.grade_avg);
                var afterGrade = parseFloat(b.grade_avg);

                if (beforeGrade < afterGrade) {
                    return 1;
                } else if (beforeGrade > afterGrade) {
                    return -1;
                } else {
                    return 0;
                }
            });

            return array;
        }
    }, {
        key: 'setRankingData',
        value: function setRankingData(data) {
            var value = [];
            var i = 1;
            for (var x in data) {
                var val = data[x];
                val["rank"] = i;
                val["style"] = "card-main-badge-area" + i;
                val["rating"] = "card-main-rank-rating" + i;

                value.push(val);
                i++;
            }

            var template = Handlebars.compile(this.template);
            this.rank_content.innerHTML = template({ ranking: value });
            this.setRatingHandler(value);
        }
    }, {
        key: 'setRatingHandler',
        value: function setRatingHandler(value) {
            var i = 1;
            var _iteratorNormalCompletion = true;
            var _didIteratorError = false;
            var _iteratorError = undefined;

            try {
                for (var _iterator = value[Symbol.iterator](), _step; !(_iteratorNormalCompletion = (_step = _iterator.next()).done); _iteratorNormalCompletion = true) {
                    var x = _step.value;

                    $("#card-main-rank-rating" + i).rateYo({
                        rating: x.grade_avg,
                        readOnly: true,
                        spacing: "10px",
                        normalFill: "#e2dbd6",
                        ratedFill: "#ffcf4d"
                    });
                    i++;
                }
            } catch (err) {
                _didIteratorError = true;
                _iteratorError = err;
            } finally {
                try {
                    if (!_iteratorNormalCompletion && _iterator.return) {
                        _iterator.return();
                    }
                } finally {
                    if (_didIteratorError) {
                        throw _iteratorError;
                    }
                }
            }
        }
    }]);

    return MainRankingPreview;
}();

/***/ }),
/* 3 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

document.addEventListener('DOMContentLoaded', function () {
    var product = localStorage['product'];
    var obj = JSON.parse(product);

    var gsParams = {
        brand: 'gs',
        leftBtn: 'gs-left-scroll',
        rightBtn: 'gs-right-scroll',
        // ul
        wrapper: '.brand-rank-item',
        template: 'brand-ranking-template',
        item_wrapper: 'gs-item-wrapper'
    };

    var cuParams = {
        brand: 'cu',
        leftBtn: 'cu-left-scroll',
        rightBtn: 'cu-right-scroll',
        // ul
        wrapper: '.brand-rank-item',
        template: 'brand-ranking-template',
        item_wrapper: 'cu-item-wrapper'
    };

    var sevenParams = {
        brand: 'seven',
        leftBtn: 'seven-left-scroll',
        rightBtn: 'seven-right-scroll',
        // ul
        wrapper: '.brand-rank-item',
        template: 'brand-ranking-template',
        item_wrapper: 'seven-item-wrapper'
    };

    var gsObj = brandFilter(obj, 'gs25');
    var cuObj = brandFilter(obj, 'CU');
    var sevObj = brandFilter(obj, '7-eleven');

    new BrandRankingPreview(gsParams, gsObj);
    new BrandRankingPreview(cuParams, cuObj);
    new BrandRankingPreview(sevenParams, sevObj);
});

var category = ['도시락', '김밥', '베이커리', '라면', '스낵', '유제품', '음료', '즉석식품'];

var defaultParam = {
    brand: "",
    category: "",
    event: [],
    id: "",
    img: "",
    name: "",
    price: ""
};

function brandFilter(obj, param) {
    var value = [];
    var finValue = [];

    for (var key in obj) {
        if (obj[key].brand === param) {
            value.push(obj[key]);
        }
    }

    for (var x in category) {
        finValue.push(defaultParam);
    }

    for (var _key in value) {
        for (var _x in category) {
            if (value[_key].category === category[_x]) {
                if (!!!finValue[_x].price || finValue[_x].grade_avg < value[_key].grade_avg) {
                    finValue[_x] = value[_key];
                }
            }
        }
    }

    return finValue;
}

var BrandRankingPreview = function () {
    function BrandRankingPreview(documentParams, obj) {
        _classCallCheck(this, BrandRankingPreview);

        this.item_template = documentParams.item_wrapper;
        // this.wrapper = documentParams.wrapper;
        // btn
        this.leftBtn = document.getElementById(documentParams.leftBtn);
        this.rightBtn = document.getElementById(documentParams.rightBtn);
        // template
        this.template = document.getElementById(documentParams.template).innerHTML;
        this.brand = documentParams.brand;
        this.translateValue = 0;

        // dummy data
        this.rankingData = obj;
        this.rankingDataKey = Object.keys(obj);
        this.rankingDataSize = Object.keys(this.rankingData).length;
        // start
        this.index = 0;
        // view page
        this.query = 4;

        this.init();
    }

    _createClass(BrandRankingPreview, [{
        key: 'init',
        value: function init() {
            this.setNode(this.rankingData[this.rankingDataKey[0]], 1, 0);
            this.setNode(this.rankingData[this.rankingDataKey[1]], 1, 1);
            this.setNode(this.rankingData[this.rankingDataKey[2]], 1, 2);
            this.setNode(this.rankingData[this.rankingDataKey[3]], 1, 3);

            var array = Array.from(document.querySelectorAll('#' + this.item_template + '> .brand-item-wrapper'));

            array.forEach(function (element) {
                element.setAttribute('class', 'brand-item-wrapper brand-item-selected');
            });

            this.setLeftScroll();
            this.setRightScroll();
        }
    }, {
        key: 'setNode',
        value: function setNode(object, value, params) {
            var element = document.createElement('li');
            element.setAttribute('class', 'brand-item-wrapper');
            element.setAttribute('name', object.id);

            var template = Handlebars.compile(this.template);

            Handlebars.registerHelper('event_tag', function () {
                var event_tag = Handlebars.escapeExpression(this);
                return new Handlebars.SafeString(event_tag);
            });
            var id = "brand-item-rating-" + this.brand + params;
            object['rating'] = id;

            element.innerHTML = template(object);

            if (value === -1) {
                var nextElement = document.getElementById(this.item_template).firstChild;
                document.getElementById(this.item_template).insertBefore(element, nextElement);
            } else {
                document.getElementById(this.item_template).appendChild(element);
            }

            this.setRatingHandler(id, object.grade_avg);
        }
    }, {
        key: 'setRatingHandler',
        value: function setRatingHandler(id, value) {
            $("#" + id).rateYo({
                rating: value,
                readOnly: true,
                spacing: "10px",
                normalFill: "#e2dbd6",
                ratedFill: "#ffcf4d"
            });
        }
    }, {
        key: 'removeNode',
        value: function removeNode() {
            var array = Array.from(document.querySelectorAll('#' + this.item_template + '> .brand-item-selected'));

            array.forEach(function (element) {
                document.getElementById(this.item_template).removeChild(element);
            }.bind(this));
        }
    }, {
        key: 'setLeftScroll',
        value: function setLeftScroll() {

            this.leftBtn.addEventListener('click', function () {

                //화면 크기변화에 따른 값 조절
                var mq = window.matchMedia("(min-width: 780px)");

                if (mq.matches) {
                    this.translateValue = '1200px';
                } else {
                    this.translateValue = '300px';
                }

                var that = this;
                this.leftBtn.disabled = true;
                var template = document.getElementById(this.item_template).parentNode;

                this.query = this.query - 4;
                for (var x = this.query - 1; x > this.query - 5; x--) {
                    var nextQuery = void 0;
                    if (x < 0) {
                        nextQuery = this.rankingDataSize + x;
                    } else if (x >= this.rankingDataSize) {
                        nextQuery = x - this.rankingDataSize;
                    } else {
                        nextQuery = x;
                    }
                    this.setNode(this.rankingData[this.rankingDataKey[nextQuery]], -1, nextQuery);
                }

                if (this.query < 0) {
                    this.query += this.rankingDataSize;
                }

                this.index++;

                template.style.transitionDuration = '0.4s';
                template.style.marginLeft = '-' + this.translateValue;
                template.style.transform = 'translateX(' + this.translateValue + ')';

                setTimeout(function () {
                    that.removeNode();
                    template.style.transitionDuration = '0s';
                    template.style.margin = 'auto';
                    template.style.transform = 'translateX(0px)';

                    var array = Array.from(document.querySelectorAll('#' + this.item_template + ' > .brand-item-wrapper'));
                    array.forEach(function (element) {
                        element.setAttribute('class', 'brand-item-wrapper brand-item-selected');
                    });

                    that.leftBtn.disabled = false;
                }, 400);
            }.bind(this));
        }
    }, {
        key: 'setRightScroll',
        value: function setRightScroll() {

            this.rightBtn.addEventListener('click', function () {

                //화면 크기변화에 따른 값 조절
                var mq = window.matchMedia("(min-width: 780px)");

                if (mq.matches) {
                    this.translateValue = '1200px';
                } else {
                    this.translateValue = '300px';
                }

                var that = this;
                this.rightBtn.disabled = true;
                var template = document.getElementById(this.item_template).parentNode;

                for (var x = 0; x < 4; x++) {
                    this.setNode(this.rankingData[this.rankingDataKey[this.query]], 1, this.query);
                    this.query++;
                    if (this.query === this.rankingDataSize) {
                        this.query = 0;
                    }
                }

                this.index++;

                template.style.transitionDuration = '0.4s';
                template.style.transform = 'translateX(-' + this.translateValue + ')';

                setTimeout(function () {
                    that.removeNode();
                    template.style.transitionDuration = '0s';
                    template.style.transform = 'none';

                    var array = Array.from(document.querySelectorAll('#' + this.item_template + ' > .brand-item-wrapper'));
                    array.forEach(function (element) {
                        element.setAttribute('class', 'brand-item-wrapper brand-item-selected');
                    });

                    that.rightBtn.disabled = false;
                }.bind(that), 400);
            }.bind(this));
        }
    }]);

    return BrandRankingPreview;
}();

/***/ }),
/* 4 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

document.addEventListener('DOMContentLoaded', function (event) {
    var searchParams = {
        brand: '.fixTab-search-brand',
        brand_dropdown: '.fixTab-search-brand-dropdown',
        category: '.fixTab-search-category',
        category_drowndown: '.fixTab-search-category-dropdown',
        text: '.fixTab-search-word',
        button: '.fixTab-search-button'
    };

    new SearchTab(searchParams);

    var profileDrop = document.querySelector('.fixTab-profile-id');

    profileDrop.addEventListener("mouseover", function () {
        var dropdown = document.querySelector(".fixTab-profile-dropdown");
        if (dropdown.style.display === "block") {} else {
            dropdown.style.display = "block";
        }
    });

    profileDrop.addEventListener("mouseout", function () {
        var dropdown = document.querySelector(".fixTab-profile-dropdown");

        if (dropdown.style.display === "block") {
            dropdown.style.display = "none";
        }
    });

    var carousel = new Carousel('reviewNavi', 'carousel-leftButton', 'carousel-rightButton', 10, 'carousel-template', 'carouselSec');
    var counter = new Counter(3000);
    counter.setCounter();
});

var Dropdown = function () {
    function Dropdown(event, button, drop) {
        _classCallCheck(this, Dropdown);

        this.event = event;
        this.button = button;
        this.drop = drop;
        this.init();
    }

    _createClass(Dropdown, [{
        key: 'init',
        value: function init() {
            this.button = document.querySelector(this.button);
            this.drop = document.querySelector(this.drop);
            this.setEvent();
        }
    }, {
        key: 'setEvent',
        value: function setEvent() {
            this.button.addEventListener(this.event, function () {

                if (this.drop.style.display === "block") {
                    this.drop.style.display = "none";
                } else {
                    this.drop.style.display = "block";
                }
            }.bind(this), true);
        }
    }]);

    return Dropdown;
}();

var Util = function () {
    function Util() {
        _classCallCheck(this, Util);
    }

    _createClass(Util, [{
        key: 'ajax',
        value: function ajax(func) {
            var oReq = new XMLHttpRequest();
            oReq.addEventListener('load', function (e) {
                var data = JSON.parse(oReq.responseText);
                func.setData(data);
            });

            oReq.open('GET', func.url);
            oReq.send();
        }
    }, {
        key: 'template',
        value: function template(data, _template, section) {
            var context = data;
            var tmpl = Handlebars.compile(_template);
            section.innerHTML = tmpl(context);
        }
    }]);

    return Util;
}();

//main 상단 리뷰 캐러셀


var Carousel = function () {
    function Carousel(reviewNavi, leftButton, rightButton, count, template, sec) {
        _classCallCheck(this, Carousel);

        this.reviewNavi = reviewNavi;
        this.leftButton = leftButton;
        this.rightButton = rightButton;
        this.count = count;
        this.template = template;
        this.sec = sec;
        this.data = [];
        this.index = 0;
        this.init();
    }

    _createClass(Carousel, [{
        key: 'init',
        value: function init() {
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
            this.getData();
        }
    }, {
        key: 'changeIndex',
        value: function changeIndex(value) {
            this.index += value;
        }
    }, {
        key: 'setDurationZero',
        value: function setDurationZero() {
            this.reviewNavi.style.transition = "none";
        }
    }, {
        key: 'setDurationfull',
        value: function setDurationfull() {
            this.reviewNavi.style.transition = "";
            this.reviewNavi.style.transitionDuration = "1s";
        }
    }, {
        key: 'nextPage',
        value: function nextPage() {
            this.setDurationfull();
            this.changeIndex(1);
            var left = (this.index + 1) * 100;
            this.reviewNavi.style.left = "-" + left + "%";

            if (this.index === this.count) {

                this.index = 0;
                setTimeout(function () {
                    this.setDurationZero();
                    this.reviewNavi.style.left = "-100%";
                }.bind(this), 1000);
            }

            this.changeCircle();
        }
    }, {
        key: 'beforePage',
        value: function beforePage() {
            this.setDurationfull();
            this.changeIndex(-1);
            var left = (this.index + 1) * 100;
            this.reviewNavi.style.left = "-" + left + "%";

            if (this.index === -1) {
                this.index = 9;
                setTimeout(function () {
                    this.setDurationZero();
                    this.reviewNavi.style.left = "-1000%";
                }.bind(this), 1000);
            }

            this.changeCircle();
        }
    }, {
        key: 'changeCircle',
        value: function changeCircle() {
            var beforeCircle = document.querySelector(".carousel-circle-selected");
            beforeCircle.setAttribute("class", "carousel-circle");

            var arr = Array.from(document.querySelectorAll(".carousel-circle"));
            arr[this.index].setAttribute("class", "carousel-circle carousel-circle-selected");
        }
    }, {
        key: 'getData',
        value: function getData() {
            firebase.database().ref('/review').once('value').then(function (snapshot) {
                this.setData(snapshot.val());
            }.bind(this));
        }
    }, {
        key: 'setData',
        value: function setData(data) {
            this.data = data;

            var fakeArr = [];

            Object.keys(this.data).forEach(function (e) {
                fakeArr.push(this.data[e]);
            }.bind(this));

            var arr = [];
            arr.push(fakeArr[9]);

            for (var i = 0; i <= 9; i++) {
                arr.push(fakeArr[i]);
            }
            arr.push(fakeArr[0]);

            var util = new Util();

            util.template(arr, this.template, this.sec);
            this.reviewNavi = document.getElementById(this.reviewNavi);
        }
    }]);

    return Carousel;
}();

//메인 상단 고정 탭


var SearchTab = function () {
    function SearchTab(searchParams) {
        _classCallCheck(this, SearchTab);

        this.searchParams = searchParams;

        this.brandDrop = document.querySelector(searchParams.brand);
        this.brandNavi = document.querySelector(searchParams.brand_dropdown);
        this.categoryDrop = document.querySelector(searchParams.category);
        this.categoryNavi = document.querySelector(searchParams.category_drowndown);
        this.inputText = document.querySelector(searchParams.text);
        this.searchButton = document.querySelector(searchParams.button);
        this.fixTabNavi = document.querySelector("#fixTabNavi");
        this.init();
    }

    _createClass(SearchTab, [{
        key: 'init',
        value: function init() {
            this.dropdownEvent();
            this.setTabClickEvent();
        }
    }, {
        key: 'dropdownEvent',
        value: function dropdownEvent() {
            var brandDrop = new Dropdown("click", this.searchParams.brand, this.searchParams.brand_dropdown);
            var categoryDrop = new Dropdown("click", this.searchParams.category, this.searchParams.category_drowndown);

            this.brandNavi.addEventListener("click", function (event) {
                this.brandDrop.firstChild.innerText = event.toElement.innerText;
            }.bind(this));

            this.categoryNavi.addEventListener("click", function (event) {
                this.categoryDrop.firstChild.innerText = event.toElement.innerText;
            }.bind(this));

            this.searchButton.addEventListener("click", function () {
                this.setQuery();

                document.querySelector(".main-wrapper").style.display = "none";
                document.querySelector(".rank-container").style.display = "";
            }.bind(this));
        }
    }, {
        key: 'setQuery',
        value: function setQuery() {
            var queryBrand = this.brandDrop.firstChild.innerText;
            var queryCategory = this.categoryDrop.firstChild.innerText;

            var brand = queryBrand === '브랜드' ? 'all' : queryBrand;
            var category = queryCategory === '카테고리' ? '전체' : queryCategory;
            var text = this.inputText.value;

            var value = {
                brand: brand,
                category: category,
                keyword: text
            };

            localStorage['search_keyword'] = JSON.stringify(value);
        }
    }, {
        key: 'setTabClickEvent',
        value: function setTabClickEvent() {
            this.fixTabNavi.addEventListener('click', function (e) {
                var selectedTab = document.getElementsByClassName("fixTab-select")[0];

                selectedTab.classList.remove("fixTab-select");
                e.target.classList.add("fixTab-select");

                var text = document.getElementsByClassName("fixTab-select")[0].innerHTML;

                if (text === "편리해") {
                    document.querySelector(".main-wrapper").style.display = "";
                    document.querySelector(".rank-container").style.display = "none";
                } else if (text === "랭킹") {
                    document.querySelector(".main-wrapper").style.display = "none";
                    document.querySelector(".rank-container").style.display = "";

                    var value = {
                        brand: 'all',
                        category: '전체',
                        keyword: ''
                    };

                    localStorage['search_keyword'] = JSON.stringify(value);
                } else if (text === "리뷰") {
                    document.querySelector(".main-wrapper").style.display = "none";
                    document.querySelector(".rank-container").style.display = "none";
                }
            }.bind(this));
        }
    }]);

    return SearchTab;
}();

//메인 하단 jquery plugin 을 이용한 counter, 매개변수는 스크롤 위치를 의미


var Counter = function () {
    function Counter(max) {
        _classCallCheck(this, Counter);

        this.max = max;
    }

    _createClass(Counter, [{
        key: 'setCounter',
        value: function setCounter() {
            var max = this.max;
            $(window).scroll(function () {
                var val = $(this).scrollTop();
                var cover = $('.cover');
                if (max < val) {
                    $('#counter1').animateNumber({ number: 4200 }, 2000);
                    $('#counter2').animateNumber({ number: 3203 }, 2000);
                    $('#counter3').animateNumber({ number: 23 }, 2000);
                    max = 99999;
                }
            });
        }
    }]);

    return Counter;
}();

//chart.js를 이용하여 차트를 만드는 클래스


var MakeChart = function () {
    function MakeChart(feature, label, data, id, color, hoverColor) {
        _classCallCheck(this, MakeChart);

        this.feature = feature;
        this.label = label;
        this.data = data;
        this.id = id;
        this.color = color;
        this.hoverColor = hoverColor;
        this.setChart();
    }

    _createClass(MakeChart, [{
        key: 'setChart',
        value: function setChart() {
            var ctx = document.getElementById(this.id).getContext('2d');
            new Chart(ctx, {
                type: this.feature,
                data: {
                    labels: this.label,
                    datasets: [{
                        label: "",
                        backgroundColor: this.color,
                        borderColor: 'white',
                        borderSkipped: "left",
                        hoverBackgroundColor: this.hoverColor,
                        data: this.data
                    }]
                },
                options: {
                    responsive: true,
                    legend: {
                        display: false
                    },
                    scales: {
                        xAxes: [{
                            gridLines: {
                                display: false
                            }
                        }],
                        yAxes: [{
                            gridLines: {
                                display: false
                            }
                        }]
                    }
                }
            });
        }
    }]);

    return MakeChart;
}();

//review의 이벤트를 만들고 리뷰를 생성하는 클래스


var Review = function () {
    function Review(id, navi, product) {
        _classCallCheck(this, Review);

        this.id = id;
        this.value = 0;
        this.product = product;
        this.comment = "";
        this.data = [0, 0, 0, 0, ""];
        this.navi = navi;
        this.init();
    }

    _createClass(Review, [{
        key: 'init',
        value: function init() {
            this.setStar();
            this.setNavi();
            var makeBtn = document.querySelector(".popup-newReview-completeBtn");
            makeBtn.addEventListener("click", function () {
                this.setMakeReview();
            }.bind(this));

            var cancelBtn = document.querySelector(".popup-newReview-cancel");
            cancelBtn.addEventListener("click", function () {
                this.setOnOff();
                this.setInit();
            }.bind(this));

            var writeBtn = document.querySelector(".popup-reviewWrite");
            writeBtn.addEventListener("click", function () {
                this.setOnOff();
            }.bind(this));
        }

        //초기화 함수

    }, {
        key: 'setInit',
        value: function setInit() {
            var removeArr = document.getElementsByClassName("newReview-element-price-select");
            Array.from(removeArr).forEach(function (e) {
                e.className = "newReview-element";
            });
            var removeArr2 = document.getElementsByClassName("newReview-element-flavor-select");
            Array.from(removeArr2).forEach(function (e) {
                e.className = "newReview-element";
            });
            var removeArr3 = document.getElementsByClassName("newReview-element-quantity-select");
            Array.from(removeArr3).forEach(function (e) {
                e.className = "newReview-element";
            });
            this.setStar();
        }
    }, {
        key: 'setOnOff',
        value: function setOnOff() {

            var newReview = document.querySelector(".popup-newReviewWrapper");
            if (newReview.style.display === "none") {
                newReview.style.display = "";
            } else {
                newReview.style.display = "none";
            }
        }
    }, {
        key: 'setNavi',
        value: function setNavi() {
            var naviArr = Array.from(document.querySelectorAll(this.navi));

            //price 레이팅
            naviArr[0].addEventListener("click", function (e) {
                if (e.srcElement.nodeName === "LI") {
                    var removeArr = document.getElementsByClassName("newReview-element-price-select");
                    if (removeArr.length !== 0) {
                        removeArr[0].className = "newReview-element";
                    }
                    e.target.className += " newReview-element-price-select";

                    this.data[1] = parseInt(e.target.getAttribute("name"));
                }
            }.bind(this));

            //flavor 레이팅
            naviArr[1].addEventListener("click", function (e) {
                if (e.srcElement.nodeName === "LI") {
                    var removeArr = document.getElementsByClassName("newReview-element-flavor-select");
                    if (removeArr.length !== 0) {
                        removeArr[0].className = "newReview-element";
                    }
                    e.target.className += " newReview-element-flavor-select";
                    this.data[2] = parseInt(e.target.getAttribute("name"));
                }
            }.bind(this));

            //quantity 레이팅
            naviArr[2].addEventListener("click", function (e) {
                if (e.srcElement.nodeName === "LI") {
                    var removeArr = document.getElementsByClassName("newReview-element-quantity-select");
                    if (removeArr.length !== 0) {
                        removeArr[0].className = "newReview-element";
                    }
                    e.target.className += " newReview-element-quantity-select";
                    this.data[3] = parseInt(e.target.getAttribute("name"));
                }
            }.bind(this));
        }
    }, {
        key: 'setStar',
        value: function setStar() {
            $("#" + this.id).rateYo({
                fullStar: true, // 정수단위로
                spacing: "15px" // margin

            }).on("rateyo.change", function (e, data) {
                this.value = data.rating;
                this.setText();
            }.bind(this));
        }
    }, {
        key: 'setText',
        value: function setText() {
            var ele = document.querySelector(".popup-newReview-star");
            ele.style.background = "";
            this.data[0] = this.value;
            ele.innerHTML = this.value + "점 ";
        }
    }, {
        key: 'setMakeReview',
        value: function setMakeReview() {
            this.data[4] = document.querySelector('.popup-newReview-comment').value;
            this.setOnOff();
            var database = firebase.database();

            var reviewId = database.ref().child('review').push().key;

            database.ref('review/' + reviewId).set({
                "bad": 0,
                "brand": this.product.brand,
                "category": this.product.category,
                "comment": this.data[4],
                "flavor": this.data[2],
                "grade": this.data[0],
                "id": reviewId,
                "p_id": this.product.id,
                "p_image": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTEWH62itb0PDp85-GO1o97E4dUlfKijz368Na6TRKAWePkraUID3x1qyFZ",
                "p_name": this.product.name,
                "p_price": this.product.price,
                "price": this.data[1],
                "quantity": this.data[3],
                "timestamp": timestamp(),
                "useful": 0,
                "user": "tongtong",
                "user_image": "http://item.kakaocdn.net/dw/4407092.title.png"
            });

            //상품 리뷰리스트에 리뷰 번호 추가
            if (!!this.product.reviewList) {
                this.product.reviewList.push(reviewId);
            } else {
                this.product.reviewList = [];
                this.product.reviewList.push(reviewId);
            }

            this.product.grade_count += 1;
            this.product.review_count += 1;
            this.product.grade_total += this.data[0];
            this.product.grade_avg = this.product.grade_total / this.product.grade_count;
            this.product.grade_data["g" + this.data[0]] += 1;
            this.product.price_level["p" + this.data[1]] += 1;
            this.product.flavor_level["f" + this.data[2]] += 1;
            this.product.quantity_level["q" + this.data[3]] += 1;

            //업데이트 반영된 product 삽입
            database.ref('product/' + this.product.id).set(this.product);

            firebase.database().ref('product/').once('value').then(function (snapshot) {
                localStorage['product'] = JSON.stringify(snapshot.val());
            });

            firebase.database().ref('review/').once('value').then(function (snapshot) {
                localStorage['review'] = JSON.stringify(snapshot.val());

                var util = new Util();
                var product = localStorage['product'];
                var obj = JSON.parse(product);

                var review = localStorage['review'];
                var obj2 = JSON.parse(review);

                var reviewArr = [];
                obj[this.product.id].reviewList.forEach(function (e) {
                    reviewArr.push(obj2[e]);
                });

                var template2 = document.querySelector("#review-template").innerHTML;
                var sec2 = document.querySelector("#popupReview");
                util.template(reviewArr, template2, sec2);
            }.bind(this));
        }
    }]);

    return Review;
}();

//image 업로드하고 미리보기 만드는 클래스


var UpLoadImage = function () {
    function UpLoadImage(inputId, imgPreviewId) {
        _classCallCheck(this, UpLoadImage);

        this.inputId = inputId;
        this.imgPreviewId = imgPreviewId;

        this.init();
    }

    _createClass(UpLoadImage, [{
        key: 'init',
        value: function init() {
            document.querySelector("#" + this.inputId).addEventListener("change", function () {
                this.previewFile();
            }.bind(this));
        }
    }, {
        key: 'previewFile',
        value: function previewFile() {
            var preview = document.querySelector('#' + this.imgPreviewId);
            var file = document.querySelector('#' + this.inputId).files[0];
            var reader = new FileReader();

            reader.addEventListener("load", function () {
                preview.src = reader.result;
            }, false);

            if (file) {
                reader.readAsDataURL(file);
            }
        }
    }]);

    return UpLoadImage;
}();

function loadDetailProduct(event) {

    $("body").css("overflow", "hidden");

    //데이터 받아오기
    var product = localStorage['product'];
    var obj = JSON.parse(product);
    var review = localStorage['review'];
    var obj2 = JSON.parse(review);

    //상품의 id 값받기 각종 초기 설정
    var id = event.getAttribute("name");
    var template = document.querySelector("#popup-template").innerHTML;
    var sec = document.querySelector("#popup");
    var util = new Util();

    // const value = obj[grade_total]/obj[grade_count];

    //grade_avg 평점이 소수점 둘째자리까지만 표시
    obj[id].grade_avg = obj[id].grade_avg.toFixed(1);

    util.template(obj[id], template, sec);

    var gradeData = [];
    Object.keys(obj[id].grade_data).forEach(function (e) {
        gradeData.push(obj[id].grade_data[e]);
    });

    var priceData = [];
    Object.keys(obj[id].price_level).forEach(function (e) {
        priceData.push(obj[id].price_level[e]);
    });

    var flavorData = [];
    Object.keys(obj[id].flavor_level).forEach(function (e) {
        flavorData.push(obj[id].flavor_level[e]);
    });

    var quantityData = [];
    Object.keys(obj[id].quantity_level).forEach(function (e) {
        quantityData.push(obj[id].quantity_level[e]);
    });

    var ratingChart = new MakeChart('line', ["1🌟", "2🌟", "3🌟", "4🌟", "5🌟"], gradeData, 'ratingChart', '#ffc225', '#eeb225');
    var priceChart = new MakeChart('bar', ["비쌈", "", "적당", "", "저렴"], priceData, 'priceChart', '#ee5563', '#9c3740');
    var flavorChart = new MakeChart('bar', ["노맛", "", "적당", "", "존맛"], flavorData, 'flavorChart', '#ee5563', '#9c3740');
    var quantityChart = new MakeChart('bar', ["창렬", "", "적당", "", "헤자"], quantityData, 'quantityChart', '#ee5563', '#9c3740');

    var reviewArr = [];

    if (!!obj[id].reviewList) {
        obj[id].reviewList.forEach(function (e) {
            reviewArr.push(obj2[e]);
        });
        var template2 = document.querySelector("#review-template").innerHTML;
        var sec2 = document.querySelector("#popupReview");

        util.template(reviewArr, template2, sec2);
    }

    //rateyo.js를 사용하기 위한 별이 들어갈 DOM의 id, 전체 리뷰 Wrapper 클래스명
    var makeReview = new Review("popupStar", ".newReview-list", obj[id]);
    var reviewImageUpLoad = new UpLoadImage('reviewImageInput', 'imagePreview');

    //모달 리뷰 필터 드롭다운
    var reviewFilterDrop = new Dropdown("click", ".popup-reviewFilter", ".popup-reviewFilter-dropdown");

    document.querySelector(".popup-close").addEventListener("click", function () {
        $("body").css("overflow", "visible");
    });
}

function timestamp() {
    var d = new Date();
    var curr_date = d.getDate();
    var curr_month = d.getMonth() + 1; //Months are zero based
    var curr_year = d.getFullYear();
    var curr_hour = d.getHours();
    var curr_minute = d.getMinutes();
    var curr_second = d.getSeconds();

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

    return curr_year + "-" + curr_month + "-" + curr_date + " " + curr_hour + ":" + curr_minute + ":" + curr_second;
}

//이런식으로 해야 웹팩에서 function을 html onclick으로 사용가
window.loadDetailProduct = loadDetailProduct;

/***/ }),
/* 5 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


/***/ }),
/* 6 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

document.addEventListener('DOMContentLoaded', function () {

  var rankingParams = {
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

  var searchParams = getSearchParams();

  new RankingViewPage(rankingParams, searchParams);
});

function getSearchParams() {
  var getObject = JSON.parse(localStorage['search_keyword']);

  var searchParams = {};

  searchParams.brand = getObject.brand;
  searchParams.category = getObject.category;
  searchParams.sort = 'grade';
  searchParams.keyword = getObject.keyword;

  return searchParams;
}

var RankingViewPage = function () {
  function RankingViewPage(rankingParams, searchParams) {
    _classCallCheck(this, RankingViewPage);

    // sort
    this.sort_rank_tab = document.querySelector(rankingParams.sort_tab);
    this.selected_sort_rank_tab = rankingParams.selected_sort;
    this.sort_key = rankingParams.sort_check_key;

    // brand
    this.brand_rank_tab = document.querySelector(rankingParams.brand_tab);
    this.selected_brand_rank_tab = rankingParams.selected_brand;
    this.brand_key = rankingParams.brand_check_key;

    // category
    this.category_rank_tab = document.querySelector(rankingParams.category_tab);
    this.selected_category_rank_tab = rankingParams.selected_category;
    this.category_key = rankingParams.category_check_key;

    this.searchObject = searchParams;
    this.arrayObj = this.getArrayObject();

    this.flag = true;

    this.template = document.querySelector(rankingParams.template).innerHTML;
    this.rank_content = document.querySelector(rankingParams.content);

    this.init();
  }

  _createClass(RankingViewPage, [{
    key: 'init',
    value: function init() {
      this.setDefaultRankingData();
      this.setClickEvent();
      this.sortEvent(this.selected_sort_rank_tab, this.sort_key);
      this.brandEvent(this.selected_brand_rank_tab, this.brand_key);
      this.categoryEvent(this.selected_category_rank_tab, this.category_key);
      this.reloadEvent();
    }
  }, {
    key: 'setClickEvent',
    value: function setClickEvent() {
      document.querySelector('.fixTab-search-button').addEventListener('click', function () {
        var storage = localStorage['search_keyword'];
        var value = JSON.parse(storage);

        var brand = this.getBrandName(value.brand);
        value['brand'] = brand;
        console.log(value);

        this.flag = true;
        this.searchObject = value;
        this.setDefaultRankingData();
      }.bind(this));

      document.querySelector("#fixTabNavi").addEventListener('click', function () {
        var selectedTab = document.getElementsByClassName("fixTab-select")[0];

        var text = document.getElementsByClassName("fixTab-select")[0].innerHTML;

        if (text === "랭킹") {
          var value = {
            brand: 'all',
            category: '전체',
            sort: 'grade',
            keyword: ''
          };

          this.flag = true;
          this.searchObject = value;
          this.setDefaultRankingData();
        }
      }.bind(this));
    }
  }, {
    key: 'getArrayObject',
    value: function getArrayObject() {
      var product = localStorage['product'];
      var obj = JSON.parse(product);
      var queryObj = [];

      for (var key in obj) {
        queryObj.push(obj[key]);
      }

      return queryObj;
    }
  }, {
    key: 'sortEvent',
    value: function sortEvent(selectedClassName, key) {
      this.sort_rank_tab.addEventListener('click', function (e) {
        var selectedTab = document.getElementsByClassName(selectedClassName)[0];

        selectedTab.classList.remove(selectedClassName);
        e.target.classList.add(selectedClassName);

        var changeSelectedTab = document.getElementsByClassName(selectedClassName)[0];

        if (changeSelectedTab.getAttribute('class') == key) {
          this.flag = true;
          var requestParam = changeSelectedTab.getAttribute('name');
          this.setSorting(requestParam);
        } else {
          e.target.classList.remove(selectedClassName);
          selectedTab.classList.add(selectedClassName);
        }
      }.bind(this));
    }
  }, {
    key: 'brandEvent',
    value: function brandEvent(selectedClassName, key) {
      this.brand_rank_tab.addEventListener('click', function (e) {
        var selectedTab = document.getElementsByClassName(selectedClassName)[0];

        selectedTab.classList.remove(selectedClassName);
        e.target.classList.add(selectedClassName);

        var changeSelectedTab = document.getElementsByClassName(selectedClassName)[0];

        if (changeSelectedTab.getAttribute('class') == key) {
          this.flag = true;
          var requestParam = changeSelectedTab.getAttribute('name');
          this.setBrandSort(requestParam);
        } else {
          e.target.classList.remove(selectedClassName);
          selectedTab.classList.add(selectedClassName);
        }
      }.bind(this));
    }
  }, {
    key: 'categoryEvent',
    value: function categoryEvent(selectedClassName, key) {
      this.category_rank_tab.addEventListener('click', function (e) {

        var selectedTab = document.getElementsByClassName(selectedClassName)[0];

        selectedTab.classList.remove(selectedClassName);
        e.target.classList.add(selectedClassName);

        var changeSelectedTab = document.getElementsByClassName(selectedClassName)[0];

        if (changeSelectedTab.getAttribute('class') == key) {
          this.flag = true;
          var requestParam = changeSelectedTab.getAttribute('name');
          this.setCategorySort(requestParam);
        } else {
          e.target.classList.remove(selectedClassName);
          selectedTab.classList.add(selectedClassName);
        }
      }.bind(this));
    }
  }, {
    key: 'getBrandName',
    value: function getBrandName(params) {
      switch (params) {
        case 'gs25':
        case 'GS25':
          return 'gs25';
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
  }, {
    key: 'setBrandSort',
    value: function setBrandSort(params) {
      var brandName = void 0;
      if (!!params) {
        brandName = this.getBrandName(params);
        this.searchObject.brand = brandName;
      } else {
        params = this.searchObject.brand;
        brandName = params;
      }

      this.arrayObj = this.getArrayObject();

      var queryObj = [];

      if (this.searchObject.brand != 'all') {
        for (var key in this.arrayObj) {
          if (this.arrayObj[key].brand === brandName) {
            queryObj.push(this.arrayObj[key]);
          }
        }
      } else {
        queryObj = this.getArrayObject();
      }

      this.arrayObj = queryObj;

      if (this.flag) {
        this.flag = false;
        this.setCategorySort();
        this.setSorting();
      }

      this.setDefaultRankingData();
    }
  }, {
    key: 'setCategorySort',
    value: function setCategorySort(param) {
      var queryObj = [];
      if (!!param) {
        this.searchObject.category = param;
      } else {
        param = this.searchObject.category;
      }

      if (this.flag) {
        this.flag = false;
        this.setBrandSort();
      }

      for (var key in this.arrayObj) {
        if (param === "전체") {
          queryObj.push(this.arrayObj[key]);
        } else if (this.arrayObj[key].category === param) {
          queryObj.push(this.arrayObj[key]);
        }
      }

      this.arrayObj = queryObj;
      this.setDefaultRankingData();
    }
  }, {
    key: 'setSorting',
    value: function setSorting(params) {
      var queryObj = [];
      var sortObj = [];

      if (!!params) {
        this.searchObject.sort = params;
      } else {
        params = this.searchObject.sort;
      }

      for (var key in this.arrayObj) {
        queryObj.push(this.arrayObj[key]);
      }

      if (this.flag) {
        this.flag = false;
        this.setBrandSort();
      }

      switch (params) {

        case 'review':
          sortObj = this.setReviewSort(queryObj);

          break;
        case 'row':
          sortObj = this.setRowPriceSort(queryObj);

          break;
        default:
          sortObj = this.setGradeSort(queryObj);
          break;
      }

      this.arrayObj = sortObj;
      this.setDefaultRankingData();
    }
  }, {
    key: 'setRowPriceSort',
    value: function setRowPriceSort(array) {
      array.sort(function (a, b) {
        var beforePrice = parseInt(a.price);
        var afterPrice = parseInt(b.price);

        if (beforePrice > afterPrice) {
          return 1;
        } else if (beforePrice < afterPrice) {
          return -1;
        } else {
          return 0;
        }
      });

      return array;
    }
  }, {
    key: 'setReviewSort',
    value: function setReviewSort(array) {
      array.sort(function (a, b) {
        var beforeReview = parseInt(a.review_count);
        var afterReview = parseInt(b.review_count);
        if (beforeReview < afterReview) {
          return 1;
        } else if (beforeReview > afterReview) {
          return -1;
        } else {
          return 0;
        }
      });

      return array;
    }
  }, {
    key: 'setGradeSort',
    value: function setGradeSort(array) {
      array.sort(function (a, b) {
        var beforeGrade = parseFloat(a.grade_avg);
        var afterGrade = parseFloat(b.grade_avg);

        if (beforeGrade < afterGrade) {
          return 1;
        } else if (beforeGrade > afterGrade) {
          return -1;
        } else {
          return 0;
        }
      });

      return array;
    }
  }, {
    key: 'reloadEvent',
    value: function reloadEvent() {
      var that = this;
      $(window).scroll(function () {
        var val = $(this).scrollTop();

        if (that.height < val) {
          that.start += 12;
          that.end += 12;
          that.height += 1000;
          that.setRankingData();
        }
      });
    }
  }, {
    key: 'setRankingData',
    value: function setRankingData() {
      var resultValue = [];
      var element = document.createElement('div');

      for (var i = this.start; i < this.end; i++) {
        var key = Object.keys(this.arrayObj)[i];
        var value = this.arrayObj[key];

        if (!!value) {
          value["rating"] = "card-rank-rating" + i;

          resultValue.push(value);
        }
      }
      var template = Handlebars.compile(this.template);
      element.innerHTML = template(resultValue);

      this.rank_content.appendChild(element);

      this.setRatingHandler(resultValue);
    }
  }, {
    key: 'setSearchKeyword',
    value: function setSearchKeyword() {
      var value = [];

      for (var key in this.arrayObj) {
        if (this.arrayObj[key].name.match(this.searchObject.keyword)) {
          value.push(this.arrayObj[key]);
        }
      }
      this.arrayObj = value;

      return value;
    }
  }, {
    key: 'setDefaultRankingData',
    value: function setDefaultRankingData() {
      this.start = 0;
      this.end = 12;
      this.height = 800;

      if (this.flag) {
        this.setBrandSort();
      }

      var data = !!this.searchObject.keyword ? this.setSearchKeyword() : this.arrayObj;

      var resultValue = [];
      for (var i = this.start; i < this.end; i++) {
        var key = Object.keys(data)[i];
        var value = data[key];
        if (!!value) {
          if (i < 3) {
            var rank = (i + 1).toString();
            value["rank"] = rank;
            value["style"] = "card-main-badge-area" + rank;
          }

          value["rating"] = "card-rank-rating" + i;
          resultValue.push(value);
        }
      }
      // this.arrayObj = resultValue;

      var template = Handlebars.compile(this.template);
      this.rank_content.innerHTML = template(resultValue);
      this.setRatingHandler(resultValue);
    }
  }, {
    key: 'setRatingHandler',
    value: function setRatingHandler(value) {
      var i = this.start;
      var _iteratorNormalCompletion = true;
      var _didIteratorError = false;
      var _iteratorError = undefined;

      try {
        for (var _iterator = value[Symbol.iterator](), _step; !(_iteratorNormalCompletion = (_step = _iterator.next()).done); _iteratorNormalCompletion = true) {
          var x = _step.value;

          $("#card-rank-rating" + i).rateYo({
            rating: x.grade_avg,
            readOnly: true,
            spacing: "10px",
            normalFill: "#e2dbd6",
            ratedFill: "#ffcf4d"
          });
          i++;
        }
      } catch (err) {
        _didIteratorError = true;
        _iteratorError = err;
      } finally {
        try {
          if (!_iteratorNormalCompletion && _iterator.return) {
            _iterator.return();
          }
        } finally {
          if (_didIteratorError) {
            throw _iteratorError;
          }
        }
      }
    }
  }]);

  return RankingViewPage;
}();

/***/ }),
/* 7 */
/***/ (function(module, exports) {

// removed by extract-text-webpack-plugin

/***/ }),
/* 8 */
/***/ (function(module, exports) {

// removed by extract-text-webpack-plugin

/***/ }),
/* 9 */
/***/ (function(module, exports) {

// removed by extract-text-webpack-plugin

/***/ }),
/* 10 */
/***/ (function(module, exports) {

// removed by extract-text-webpack-plugin

/***/ }),
/* 11 */
/***/ (function(module, exports) {

// removed by extract-text-webpack-plugin

/***/ }),
/* 12 */
/***/ (function(module, exports) {

// removed by extract-text-webpack-plugin

/***/ })
/******/ ]);