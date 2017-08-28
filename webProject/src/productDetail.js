import {Util,Dropdown, Toast} from './main'
import {DB, UpdateData} from './index.js'
import timestamp from './manage.js'
import {PopupInfo} from "./manage";

export class PopupOverlayClick {

    constructor() {
        this.signOverlay = document.querySelector('.sign-overlay');
        this.signInner = document.querySelector('.sign-wrapper');

        this.signFlag = false;

        this.getEvent();
    }

    getEvent() {
        /* sign in modal settings */
        this.signOverlay.addEventListener('click', function () {
            if (!this.signFlag) {
                this.closePopup();
            }
            this.signFlag = false;

        }.bind(this));

        this.signInner.addEventListener('click', function () {
            this.signFlag = true;
        }.bind(this));

    }

    closePopup() {
        if (!this.signFlag) {
            this.signOverlay.style.display = "none";
            this.signFlag = false;
        }
    }
}

//image 업로드하고 미리보기 만드는 클래스
export class UpLoadImage {
    constructor(inputId, imgPreviewId) {
        this.inputId = inputId;
        this.imgPreviewId = imgPreviewId;
        this.init();
    }

    init() {
        const inputBtn = document.querySelector("#" + this.inputId);
        const previewBtn = document.querySelector("#" + this.imgPreviewId);

        inputBtn.style.display = "none";

        inputBtn.addEventListener("change", function () {
            this.previewFile();
        }.bind(this));

        previewBtn.addEventListener("click", function () {
            inputBtn.click();
        })

    }

    previewFile() {
        let preview = document.querySelector('#' + this.imgPreviewId);
        let file = document.querySelector('#' + this.inputId).files[0];
        let reader = new FileReader();

        reader.addEventListener("load", function () {
            preview.src = reader.result;

        }, false);

        if (!file) {
        } else {
            reader.readAsDataURL(file);
        }


    }

}

//chart.js를 이용하여 차트를 만드는 클래스
class MakeChart {
    constructor(feature, label, data, id, color, hoverColor) {
        this.feature = feature;
        this.label = label;
        this.data = data;
        this.id = id;
        this.color = color;
        this.hoverColor = hoverColor;
        this.setChart()
    }

    setChart() {
        let ctx = document.getElementById(this.id).getContext('2d');
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
                    data: this.data,
                }]
            },
            options: {
                responsive: true,
                legend: {
                    display: false,
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
}

//review의 이벤트를 만들고 리뷰를 생성하는 클래스
class Review {
    constructor(id, navi, product, user) {
        this.popup = new PopupInfo();

        this.id = id;
        this.value = 0;
        this.product = product;
        this.user = user;
        this.comment = "";
        this.data = [0, 0, 0, 0, ""];
        this.navi = navi;
        this.reviewId = "";
        this.fileName = "";

        this.init();

    }

    init() {
        this.setStar();
        this.setNavi();
        const makeBtn = document.querySelector(".popup-newReview-completeBtn");
        makeBtn.addEventListener("click", function () {
            this.setMakeReview();
        }.bind(this));

        const cancelBtn = document.querySelector(".popup-newReview-cancel");
        cancelBtn.addEventListener("click", function () {
            this.setOnOff();
            this.setInit();
        }.bind(this));

        const writeBtn = document.querySelector(".popup-reviewWrite");


        const db = new DB();
        db.updateUserDb();

        const userStorage = localStorage['user'];
        this.user = JSON.parse(userStorage);
        const userId = firebase.auth().currentUser.uid


        writeBtn.addEventListener("click", function () {

            if (db.user[userId].product_review_list.includes(this.product.id)) {
                new Toast("이미 리뷰를 작성한 상품입니다");
            } else {
                this.setOnOff()
            }
        }.bind(this));


    }

    //초기화 함수
    setInit() {
        const removeArr = document.getElementsByClassName("newReview-element-price-select");
        Array.from(removeArr).forEach(function (e) {
            e.className = "newReview-element"
        });

        const removeArr2 = document.getElementsByClassName("newReview-element-flavor-select");
        Array.from(removeArr2).forEach(function (e) {
            e.className = "newReview-element"
        });

        const removeArr3 = document.getElementsByClassName("newReview-element-quantity-select");
        Array.from(removeArr3).forEach(function (e) {
            e.className = "newReview-element"
        });
        this.setStar()

    }

    setOnOff() {

        const newReview = document.querySelector(".popup-newReviewWrapper");
        if (newReview.style.display === "none") {
            newReview.style.display = "";
        } else {
            newReview.style.display = "none";
        }
    }

    setNavi() {
        const naviArr = Array.from(document.querySelectorAll(this.navi));

        //price 레이팅
        naviArr[0].addEventListener("click", function (e) {
            if (e.srcElement.nodeName === "LI") {
                const removeArr = document.getElementsByClassName("newReview-element-price-select");
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
                const removeArr = document.getElementsByClassName("newReview-element-flavor-select");
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
                const removeArr = document.getElementsByClassName("newReview-element-quantity-select");
                if (removeArr.length !== 0) {
                    removeArr[0].className = "newReview-element";
                }
                e.target.className += " newReview-element-quantity-select";
                this.data[3] = parseInt(e.target.getAttribute("name"));
            }
        }.bind(this))

    }


    setStar() {
        $("#" + this.id).rateYo({
            fullStar: true, // 정수단위로
            spacing: "15px" // margin

        }).on("rateyo.change", function (e, data) {
            this.value = data.rating;
            this.setText();
        }.bind(this));
    }

    setText() {
        const ele = document.querySelector(".popup-newReview-star");
        ele.style.background = "";
        this.data[0] = this.value;
        ele.innerHTML = this.value + "점 ";
    }

    setMakeReview() {
        // document.querySelector('#loading').style.display = "block";

        this.data[4] = document.querySelector('.popup-newReview-comment').value;


        if (this.data[0] === 0) {
            new Toast("한 개이상의 별을 선택해 주세요.");
        } else if (this.data[1] === 0) {
            new Toast("가격 평가를 선택해 주세요.");
        } else if (this.data[2] === 0) {
            new Toast("맛 평가를 선택해 주세요.");
        } else if (this.data[3] === 0) {
            new Toast("양 평가를 선택해 주세요.");
        } else if (this.data[4].length < 20) {
            new Toast("20자 이상의 리뷰를 써주시길 바랍니다")
        } else {
            this.setOnOff();
            const database = firebase.database();

            this.reviewId = database.ref().child('review').push().key;

            let file = document.querySelector('#reviewImageInput').files[0];


            this.fileName = 'images/' + this.reviewId + "." + file.type.split("/")[1];

            const storageRef = firebase.storage().ref();
            const mountainImagesRef = storageRef.child(this.fileName);

            mountainImagesRef.put(file).then(function (snapshot) {
                this.updateDb();
            }.bind(this));


        }
    }

    updateDb() {
        const storageRef = firebase.storage().ref();
        const database = firebase.database();

        storageRef.child(this.fileName).getDownloadURL().then(function (url) {
            const that = this;


            const userId = firebase.auth().currentUser.uid;

            database.ref('review/' + this.reviewId).set({
                "bad": 0,
                "brand": this.product.brand,
                "category": this.product.category,
                "comment": this.data[4],
                "flavor": this.data[2],
                "grade": this.data[0],
                "id": this.reviewId,
                "p_id": this.product.id,
                "p_image": url,
                "p_name": this.product.name,
                "p_price": this.product.price,
                "price": this.data[1],
                "quantity": this.data[3],
                "timestamp": timestamp(),
                "useful": 0,
                "user": this.user[userId].nickname,
                "user_image": this.user[userId].user_profile,
            });


            //해당 유저에 자기가 작성한 리뷰 리스트 넣기
            if (!!this.user.product_review_list) {
                this.user.product_review_list.push(this.product.id);
            } else {
                this.user.product_review_list = [];
                this.user.product_review_list.push(this.product.id);
            }
            database.ref('user/' + userId + '/product_review_list').set(this.user.product_review_list);


            //상품 리뷰리스트에 리뷰 번호 추가
            if (!!this.product.reviewList) {
                this.product.reviewList.push(this.reviewId);
            } else {
                this.product.reviewList = [];
                this.product.reviewList.push(this.reviewId);
            }

            this.product.grade_count += 1;
            this.product.review_count += 1;
            this.product.grade_total += this.data[0];
            // this.product.grade_avg = this.product.grade_total / this.product.grade_count;
            this.product.grade_avg = (this.product.review_count / (this.product.review_count + 10)) * (this.product.grade_total / this.product.grade_count) + (10 / (this.product.review_count + 10)) * (2.75);
            this.product.grade_data["g" + this.data[0]] += 1;
            this.product.price_level["p" + this.data[1]] += 1;
            this.product.flavor_level["f" + this.data[2]] += 1;
            this.product.quantity_level["q" + this.data[3]] += 1;


            //업데이트 반영된 product 삽입
            database.ref('product/' + this.product.id).set(this.product);
            database.ref('product/').once('value').then(function (snapshot) {
                localStorage['product'] = JSON.stringify(snapshot.val());
            });
            database.ref('review/').once('value').then(function (snapshot) {
                localStorage['review'] = JSON.stringify(snapshot.val());

                const util = new Util();
                const product = localStorage['product'];
                const obj = JSON.parse(product);

                const review = localStorage['review'];
                const obj2 = JSON.parse(review);

                const reviewArr = [];
                obj[this.product.id].reviewList.forEach(function (e) {
                    reviewArr.push(obj2[e])
                });

                const template2 = document.querySelector("#review-template").innerHTML;
                const sec2 = document.querySelector("#popupReview");
                util.template(reviewArr, template2, sec2);

                util.setHandlebars(reviewArr);
                document.querySelector('#loading').style.display = "none";

                const Event = function () {
                    this.getAttribute = function (name) {
                        return that.product.id;
                    };
                };


                const event = new Event();

                loadDetailProduct(event);

                new UpdateData();

            }.bind(that));


        }.bind(this)).catch(function (error) {
            console.log(error);
            document.querySelector('#loading').style.display = "none"
        });
    }

}

//리뷰 정렬 하는 클래스
class ReviewFilter {
    constructor(reviewArray) {
        this.reviewFilter = document.querySelector('.popup-reviewFilter-dropdown');
        this.selectedReviewFilter = 'selected-popup-reviewFilter-element';
        this.reviewFilterKey = 'popup-reviewFilter-element selected-popup-reviewFilter-element';

        this.reviewArray = reviewArray;

        this.init();
    }

    init() {
        this.reviewObj = this.getDefaultArrayObject();
        this.setSorting('date');
        this.getEvent(this.selectedReviewFilter, this.reviewFilterKey);
    }

    getDefaultArrayObject() {
        const queryObj = [];
        const obj = this.reviewArray;
        let i = 0;

        for (const key in obj) {
            const value = obj[key];

            const time = value.timestamp;
            const splitTimestamp = time.split(' ');

            value['time_score'] = this.getDate(splitTimestamp[0]) + this.getTime(splitTimestamp[1]);
            // value['rating'] = "carousel-review-star" + i;

            queryObj.push(value);
            i++;
        }

        return queryObj;
    }

    getDate(value) {
        const splitDate = value.split('-');

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

        return (dateValue);
    }

    getTime(value) {
        const splitTime = value.split(':');

        const hh = parseInt(splitTime[0]);
        const mm = parseInt(splitTime[1]);
        const ss = parseInt(splitTime[2]);

        let timeValue = 0;

        timeValue = (mm + (hh * 60)) * 100;
        timeValue += ss;

        return timeValue / 1e6;
    }

    getEvent(selectedReviewFilter, reviewFilterKey) {
        this.reviewFilter.addEventListener("click", function (e) {
            const selectedFilter = document.getElementsByClassName(selectedReviewFilter)[0];

            selectedFilter.classList.remove(selectedReviewFilter);
            e.target.classList.add(selectedReviewFilter);

            const changeSelectedFilter = document.getElementsByClassName(selectedReviewFilter)[0];

            if (changeSelectedFilter.getAttribute('class') == reviewFilterKey) {
                const requestParam = changeSelectedFilter.getAttribute('name');
                this.setSorting(requestParam);
            } else {
                e.target.classList.remove(selectedReviewFilter);
                selectedFilter.classList.add(selectedReviewFilter);
            }
        }.bind(this));
    }

    setSorting(param) {
        const queryObj = this.reviewObj;
        let sortObj = [];
        const result = [];

        switch (param) {
            case 'date':
                sortObj = this.setDateSorting(queryObj);
                break;
            case 'useful':
                sortObj = this.setUsefulSorting(queryObj);
                break;
            default:
                break;
        }

        let i = 0;
        for (const x in sortObj) {
            const value = sortObj[x];

            value['rating'] = "carousel-review-star" + i;
            result.push(value);
            i++;
        }

        this.reviewObj = result;

        this.setDefaultReviewData();
    }

    setDateSorting(array) {
        array.sort(function (a, b) {
            const beforeTimeScore = parseFloat(a.time_score);
            const afterTimeScore = parseFloat(b.time_score);

            if (beforeTimeScore < afterTimeScore) {
                return 1;
            } else if (beforeTimeScore > afterTimeScore) {
                return -1;
            } else {
                return 0;
            }
        });

        return array;
    }

    setUsefulSorting(array) {
        array.sort(function (a, b) {
            const beforeUseful = parseInt(a.useful);
            const afterUseful = parseInt(b.useful);

            if (beforeUseful < afterUseful) {
                return 1;
            } else if (beforeUseful > afterUseful) {
                return -1;
            } else {
                return 0;
            }
        });

        return array;
    }

    setDefaultReviewData() {
        const util = new Util();
        const template = document.querySelector("#review-template").innerHTML;
        const popup = document.querySelector("#popupReview");


        const product = localStorage['product'];
        const obj = JSON.parse(product);
        const review = localStorage['review'];
        const obj2 = JSON.parse(review);
        const user = localStorage['user'];
        const obj3 = JSON.parse(user);

        const userId = firebase.auth().currentUser.uid;

        let newReviewObj = [];

        this.reviewObj.forEach(function (e) {

            if (!!obj3[userId].review_like_list) {
                if (obj3[userId].review_like_list[e.id] === 1) {
                    e.rate1 = " good-bad-select";
                    e.rate2 = "";

                } else if (obj3[userId].review_like_list[e.id] === -1) {
                    e.rate1 = "";
                    e.rate2 = " good-bad-select";
                }

                newReviewObj.push(e);
            } else {

                newReviewObj.push(e);

            }

        }.bind(this));

        this.reviewObj = newReviewObj;
        console.log(newReviewObj);

        util.template(this.reviewObj, template, popup);
        util.setHandlebars(this.reviewObj);
    }
}
class ReviewRating {
    constructor(userId, productId, reviewId, likeList) {
        this.userId = userId;
        this.productId = productId;
        this.reviewId = reviewId;
        this.likeList = likeList;
        this.db = new DB();
        this.setEvent()
    }

    setEvent() {
        // console.log(this.db.review);
        // console.log(this.db.user);
        // console.log(this.db.product);

        document.querySelector(".popup-reviewWrapperList").addEventListener("click", function (e) {


            if (e.target.classList.contains("popup-review-good") || e.target.classList.contains("popup-review-bad")) {
                this.userId = firebase.auth().currentUser.uid;
                this.reviewId = e.target.parentElement.getAttribute("name");
                //
                // console.log(this.userId);
                // console.log(this.productId);
                // console.log(this.reviewId);
                if (!!this.db.user[this.userId].review_like_list) {
                    this.likeList = this.db.user[this.userId].review_like_list[this.reviewId];
                } else {
                    this.db.user[this.userId].review_like_list = {};
                    this.likeList = this.db.user[this.userId].review_like_list[this.reviewId];
                }

                // console.log(!this.likeList)

                const that = this;

                //데이터가 없거나, 0일경우
                if (!this.likeList || this.likeList === 0) {
                    console.log("데이터가 없거나, 0일경우");

                    document.querySelector('#loading').style.display = "block";
                    e.target.disabled = true;


                    let value = 0;
                    let newValue = parseInt(e.target.nextSibling.nextSibling.innerHTML);
                    newValue += 1;
                    e.target.nextSibling.nextSibling.innerHTML = newValue;


                    //good 버튼을 누를 경우
                    if (e.target.classList.contains("popup-review-good")) {
                        e.target.className = "good-bad-select popup-review-good";
                        value = 1;
                        firebase.database().ref('review/' + this.reviewId + "/useful")
                            .set(this.db.review[this.reviewId].useful + 1).then(function () {
                            that.db.updateReviewDb();
                        }.bind(that));

                        //bad button을 누를 경우
                    } else {
                        e.target.className = "good-bad-select popup-review-bad";
                        value = -1;
                        firebase.database().ref('review/' + this.reviewId + "/bad")
                            .set(this.db.review[this.reviewId].bad + 1).then(function () {
                            this.db.updateReviewDb();
                        }.bind(that));
                    }


                    //userDb에 해당 값을 업데이트
                    firebase.database().ref('user/' + this.userId + "/review_like_list/" + this.reviewId)
                        .set(value).then(function () {
                        const that2 = that;
                        firebase.database().ref('user/').once('value').then(function (snapshot) {
                            localStorage['user'] = JSON.stringify(snapshot.val());
                            that2.db.user = JSON.parse(localStorage['user']);
                            document.querySelector('#loading').style.display = "none"
                            e.target.disabled = false;
                            console.log("user 캐시 업데이트")
                        }.bind(that2));
                    }.bind(that));

                    //이미 선택된적이 있는 경우
                } else if (this.likeList === 1) {
                    console.log("good 으로 선택된적 있는 경우")


                    document.querySelector('#loading').style.display = "block"
                    e.target.disabled = true;

                    if (e.target.classList.contains("popup-review-good")) {
                        e.target.className = "popup-review-good";
                        let newValue = parseInt(e.target.nextSibling.nextSibling.innerHTML);
                        newValue -= 1;
                        e.target.nextSibling.nextSibling.innerHTML = newValue;

                        let value = 0;
                        firebase.database().ref("review/" + this.reviewId + '/useful').set(newValue).then(function () {
                            this.db.updateReviewDb();
                        }.bind(that));

                        //userDb에 해당 값을 업데이트
                        firebase.database().ref('user/' + this.userId + "/review_like_list/" + this.reviewId)
                            .set(value).then(function () {
                            const that2 = that;
                            firebase.database().ref('user/').once('value').then(function (snapshot) {
                                localStorage['user'] = JSON.stringify(snapshot.val());
                                that2.db.user = JSON.parse(localStorage['user']);
                                document.querySelector('#loading').style.display = "none"
                                e.target.disabled = false;
                                console.log("user 캐시 업데이트")
                            }.bind(that2));
                        }.bind(that));
                    } else {

                        console.log("아무반응이 없어야함")
                        document.querySelector('#loading').style.display = "none"
                        e.target.disabled = false

                    }

                } else if (this.likeList === -1) {
                    console.log("bad 으로 선택된적 있는 경우")
                    document.querySelector('#loading').style.display = "block"
                    e.target.disabled = true;


                    if (e.target.classList.contains("popup-review-bad")) {
                        e.target.className = "popup-review-bad";
                        let newValue = parseInt(e.target.nextSibling.nextSibling.innerHTML);
                        newValue -= 1;
                        e.target.nextSibling.nextSibling.innerHTML = newValue;


                        let value = 0;
                        firebase.database().ref('review/' + this.reviewId + "/bad")
                            .set(this.db.review[this.reviewId].bad - 1).then(function () {
                            this.db.updateReviewDb();
                        }.bind(that));

                        //userDb에 해당 값을 업데이트
                        firebase.database().ref('user/' + this.userId + "/review_like_list/" + this.reviewId)
                            .set(value).then(function () {
                            const that2 = that;
                            firebase.database().ref('user/').once('value').then(function (snapshot) {
                                localStorage['user'] = JSON.stringify(snapshot.val());
                                that2.db.user = JSON.parse(localStorage['user']);
                                document.querySelector('#loading').style.display = "none"
                                e.target.disabled = false;
                                console.log("user 캐시 업데이트")
                            }.bind(that2));
                        }.bind(that));

                    } else {

                        console.log("아무반응이 없어야함")
                        document.querySelector('#loading').style.display = "none"
                        e.target.disabled = false

                    }
                }
            }
        }.bind(this))

    }

}
class ItemPopup {

    constructor() {
        this.popupOverlay = document.querySelector('.overlay');
        this.popupInner = document.querySelector('.popup-wrapper');

        this.flag = false;

        this.getEvent();
    }

    getEvent() {
        /* item view modal settings */
        this.popupOverlay.addEventListener('click', function () {
            if (!this.flag) {
                this.closePopup();
            } else {
                this.flag = false;
            }
        }.bind(this));

        this.popupInner.addEventListener('click', function (e) {
            this.flag = true;
            e.stopPropagation();
        }.bind(this));
    }

    closePopup() {
        if (!this.flag) {
            document.getElementsByClassName('popup-close-fake')[0].click();
            $("body").css("overflow", "visible");
            this.flag = false;
        }
    }
}
class ReviewPopup {

    constructor() {
        this.popupOverlay = document.querySelector('.overlay');
        this.popupInner = document.querySelector('.popup-review-preview');

        this.flag = false;

        this.getEvent();
    }

    getEvent() {
        /* item view modal settings */
        this.popupOverlay.addEventListener('click', function () {
            if (!this.flag) {
                this.closePopup();
            } else {
                this.flag = false;
            }
        }.bind(this));

        this.popupInner.addEventListener('click', function (e) {
            this.flag = true;
            e.stopPropagation();
        }.bind(this));
    }

    closePopup() {
        if (!this.flag) {
            document.getElementsByClassName('popup-close-fake')[0].click();
            $("body").css("overflow", "visible");
            this.flag = false;
        }
    }
}

function loadDetailProduct(event) {

    $("body").css("overflow", "hidden");
    document.querySelector('#loading').style.display = "block";

    //데이터 받아오기
    const product = localStorage['product'];
    const obj = JSON.parse(product);
    const review = localStorage['review'];
    const obj2 = JSON.parse(review);
    const user = localStorage['user'];
    const obj3 = JSON.parse(user);
    const userId = firebase.auth().currentUser.uid;

    //상품의 d 값받기 각종 초기 설정
    const id = event.getAttribute("name");
    const template = document.querySelector("#popup-template").innerHTML;
    const sec = document.querySelector("#popup");
    const util = new Util();


    // const value = obj[grade_total]/obj[grade_count];

    //grade_avg 평점이 소수점 둘째자리까지만 표시
    obj[id].grade_avg = obj[id].grade_avg.toFixed(1);

    util.template(obj[id], template, sec);

    const gradeData = [];
    Object.keys(obj[id].grade_data).forEach(function (e) {
        gradeData.push(obj[id].grade_data[e])
    });

    const priceData = [];
    Object.keys(obj[id].price_level).forEach(function (e) {
        priceData.push(obj[id].price_level[e])
    });

    const flavorData = [];
    Object.keys(obj[id].flavor_level).forEach(function (e) {
        flavorData.push(obj[id].flavor_level[e])
    });

    const quantityData = [];
    Object.keys(obj[id].quantity_level).forEach(function (e) {
        quantityData.push(obj[id].quantity_level[e])
    });

    const ratingChart = new MakeChart('line', ["1🌟", "2🌟", "3🌟", "4🌟", "5🌟"], gradeData, 'ratingChart', '#ffc225', '#eeb225');
    const priceChart = new MakeChart('bar', ["비쌈", "아쉽", "적당", "양호", "저렴"], priceData, 'priceChart', '#ee5563', '#9c3740');
    const flavorChart = new MakeChart('bar', ["노맛", "아쉽", "적당", "양호", "존맛"], flavorData, 'flavorChart', '#ee5563', '#9c3740');
    const quantityChart = new MakeChart('bar', ["창렬", "아쉽", "적당", "양호", "혜자"], quantityData, 'quantityChart', '#ee5563', '#9c3740');

    const reviewArr = [];

    if (!!obj[id].reviewList) {
        obj[id].reviewList.forEach(function (e) {
            reviewArr.push(obj2[e])
        });
    }


    //rateyo.js를 사용하기 위한 별이 들어갈 DOM의 id, 전체 리뷰 Wrapper 클래스명
    const makeReview = new Review("popupStar", ".newReview-list", obj[id]);
    const reviewImageUpLoad = new UpLoadImage('reviewImageInput', 'imagePreview');

    //모달 리뷰 필터 드롭다운
    const reviewFilterDrop = new Dropdown("click", ".popup-reviewFilter", ".popup-reviewFilter-dropdown");

    new ReviewFilter(reviewArr);

    setTimeout(function () {
        document.querySelector('#loading').style.display = "none"
    }, 1000);

    new ItemPopup();

    document.querySelector("#popupWish").addEventListener("click", function () {
        document.querySelector("#popupWish").setAttribute("class", "popup-wish popup-wish-select");

        const userStorage = localStorage['user'];
        const userData = JSON.parse(userStorage);
        const user = firebase.auth().currentUser;
        let newWishArr = userData[user.uid].wish_product_list;
        let double = true;

        if (!!newWishArr) {
            newWishArr.forEach(function (e) {
                if (e === id) {
                    double = false;
                }
            })
        } else {
            newWishArr = [];
        }

        if (double) {
            newWishArr.push(id);
            firebase.database().ref('user/' + user.uid + "/wish_product_list").set(newWishArr).then(function () {
                firebase.database().ref('user/').once('value').then(function (snapshot) {
                    localStorage['user'] = JSON.stringify(snapshot.val());
                    new Toast("즐겨찾기 품목에 추가되었습니다.")
                });
            });

        } else {
            new Toast("이미 즐겨찾기에 포함된 상품입니다.")

        }

    });

    const reviewRating = new ReviewRating();


    document.querySelector(".popup-close").addEventListener("click", function () {
        $("body").css("overflow", "visible");
    });
}



function loadReviewDetail(event) {

    $("body").css("overflow", "hidden");

    const key = event.getAttribute("name");
    const review = localStorage['review'];

    const reviewObj = JSON.parse(review);

    const template = document.querySelector('#review-preview-template').innerHTML;
    const popup = document.querySelector('#popup');

    const selectReviewData = reviewObj[key];

    selectReviewData["rating"] = "review-preview-rating";

    const util = new Util();

    util.template(selectReviewData, template, popup);

    $("#review-preview-rating").rateYo({
        rating: selectReviewData.grade,
        readOnly: true,
        spacing: "10px",
        starWidth: "20px",
        normalFill: "#e2dbd6",
        ratedFill: "#ffcf4d"

    });

    new ReviewPopup();

    document.querySelector(".popup-newReview-cancel").addEventListener("click", function () {
        $("body").css("overflow", "visible");
    });
}

window.loadDetailProduct = loadDetailProduct;
window.loadReviewDetail = loadReviewDetail;
