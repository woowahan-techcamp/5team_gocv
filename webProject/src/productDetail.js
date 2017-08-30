import {Util, Dropdown, Toast} from './main.js'
import {PopupInfo, TimeManager, UpdateData} from "./manage";

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

//리뷰 탭에서 이미지 클릭 시 상세화면 나타나는 클래스
export class ReviewPopup {

    constructor(db, wrapper, targetName, reviewId, userId) {
        this.db = db;
        this.wrapper = wrapper;
        this.targetName = targetName;
        this.reviewId = reviewId;
        this.userId = userId;
        this.init();

        this.popup = new PopupInfo();
    }

    init() {
        this.wrapper = document.querySelector(this.wrapper);

        this.wrapper.addEventListener("click", function (e) {
            this.userId = firebase.auth().currentUser.uid;

            if (Array.from(e.target.classList).includes(this.targetName)) {
                this.reviewId = e.target.getAttribute("name");

                // this.scrollEvent("hidden");
                this.setReviewData();

                this.popup.setReviewPageInit();
            }

        }.bind(this));
    }

    setReviewData() {

        const template = document.querySelector('#review-preview-template').innerHTML;
        const popup = document.querySelector('#popup');

        const selectReviewData = this.db.review[this.reviewId];

        selectReviewData["rating"] = "review-preview-rating";

        const util = new Util();

        util.template(selectReviewData, template, popup);

        const reviewTabProduct = new ProductPopup(this.db, '.popup-review-preview', 'productSelect');


        $("#review-preview-rating").rateYo({
            rating: selectReviewData.grade,
            readOnly: true,
            spacing: "10px",
            starWidth: "20px",
            normalFill: "#e2dbd6",
            ratedFill: "#ffcf4d"

        });

        /*document.querySelector(".popup-newReview-cancel").addEventListener("click", function () {
            this.scrollEvent("visible")
        }.bind(this));*/
    }

    scrollEvent(event) {
        $("body").css("overflow", event);
    }


}

//상품 이미지 클릭 시 상세화면 나타나는 클래스
export class ProductPopup {

    constructor(db, wrapper, targetName, productId, userId) {
        this.db = db;
        this.wrapper = wrapper;
        this.targetName = targetName;
        this.productId = productId;
        this.userId = userId;
        this.init();

        this.popup = new PopupInfo();
    }

    init() {
        this.wrapper = document.querySelector(this.wrapper);


        this.wrapper.addEventListener("click", function (e) {
            this.userId = firebase.auth().currentUser.uid;

            if (Array.from(e.target.classList).includes(this.targetName)) {
                this.productId = e.target.getAttribute("name");

                // this.scrollEvent("hidden");
                this.settingData();
                // this.setEvent();
            }


        }.bind(this));
    }

    settingData() {
        this.setProductData();
        this.setProductWishEvent();
        this.setReviewData();
        new ReviewRating(this.db, this, this.reviewArr);

        this.popup.setItemPageInit();

    }

    scrollEvent(event) {
        $("body").css("overflow", event);
    }

    setProductData() {
        const template = document.querySelector("#popup-template").innerHTML;
        const sec = document.querySelector("#popup");
        const util = new Util();
        //grade_avg 평점이 소수점 둘째자리까지만 표시

        this.db.product[this.productId].grade_avg = parseFloat(this.db.product[this.productId].grade_avg).toFixed(1);

        let wish_flag = false;

        if (!!this.db.user[this.userId].wish_product_list) {
            if (this.db.user[this.userId].wish_product_list.includes(this.productId)) {
                wish_flag = true;
                this.db.product[this.productId].wish_flag = wish_flag;
            }
        }

        this.db.product[this.productId].wish_flag = wish_flag;


        util.template(this.db.product[this.productId], template, sec);

        const gradeData = [];
        Object.keys(this.db.product[this.productId].grade_data).forEach(function (e) {
            gradeData.push(this.db.product[this.productId].grade_data[e])
        }.bind(this));

        const priceData = [];
        Object.keys(this.db.product[this.productId].price_level).forEach(function (e) {
            priceData.push(this.db.product[this.productId].price_level[e])
        }.bind(this));

        const flavorData = [];
        Object.keys(this.db.product[this.productId].flavor_level).forEach(function (e) {
            flavorData.push(this.db.product[this.productId].flavor_level[e])
        }.bind(this));

        const quantityData = [];
        Object.keys(this.db.product[this.productId].quantity_level).forEach(function (e) {
            quantityData.push(this.db.product[this.productId].quantity_level[e])
        }.bind(this));

        const ratingChart = new MakeChart('line', ["1🌟", "2🌟", "3🌟", "4🌟", "5🌟"], gradeData, 'ratingChart', '#ffc225', '#eeb225');
        const priceChart = new MakeChart('bar', ["비쌈", "아쉽", "적당", "양호", "저렴"], priceData, 'priceChart', '#ee5563', '#9c3740');
        const flavorChart = new MakeChart('bar', ["노맛", "아쉽", "적당", "양호", "존맛"], flavorData, 'flavorChart', '#ee5563', '#9c3740');
        const quantityChart = new MakeChart('bar', ["창렬", "아쉽", "적당", "양호", "혜자"], quantityData, 'quantityChart', '#ee5563', '#9c3740');

        const allergyArr = this.db.product[this.productId].allergy;
        const allergyEleArr = Array.from(document.querySelectorAll(".popup-review-Allergy"));

        allergyEleArr.forEach(function (element) {
            if (!!allergyArr) {
                if (allergyArr.includes(element.getAttribute("name"))) {
                    element.style.color = "black";
                }
            } else {

            }
        })


    }

    setReviewData() {
        const reviewArr = [];

        if (!!this.db.product[this.productId].reviewList) {
            this.db.product[this.productId].reviewList.forEach(function (e) {
                reviewArr.push(this.db.review[e])
            }.bind(this));
        }

        //rateyo.js를 사용하기 위한 별이 들어갈 DOM의 id, 전체 리뷰 Wrapper 클래스명
        const makeReview = new Review(this.db, "popupStar", ".newReview-list", this.db.product[this.productId]);
        const reviewImageUpLoad = new UpLoadImage('reviewImageInput', 'imagePreview');

        //모달 리뷰 필터 드롭다운
        const reviewFilterDrop = new Dropdown("click", ".popup-reviewFilter", ".popup-reviewFilter-dropdown");
        const storage = JSON.parse(localStorage['review']);

        new ReviewFilter(reviewArr);

        document.querySelector('#loading').style.display = "none"

        this.reviewArr = reviewArr;
    }

    setProductWishEvent() {

        const popupWishBtn = document.querySelector("#popupWish");

        popupWishBtn.addEventListener("click", function () {
            document.querySelector('#loading').style.display = "block";

            popupWishBtn.disabled = true;
            const that = this;
            const wishBtn = document.querySelector("#popupWish")
            wishBtn.setAttribute("class", "popup-wish popup-wish-select");

            let newWishArr = this.db.user[this.userId].wish_product_list;
            let reduceWishArr = []
            let double = true;

            if (newWishArr) {
                newWishArr.forEach(function (element) {
                    if (element === that.productId) {
                        double = false;
                    } else {
                        reduceWishArr.push(element);
                    }
                }.bind(that))
            } else {
                newWishArr = []
            }

            if (double) {
                newWishArr.push(this.productId);
                firebase.database().ref('user/' + this.userId + "/wish_product_list").set(newWishArr).then(function () {
                    const that2 = that;
                    firebase.database().ref('user/').once('value').then(function (snapshot) {
                        localStorage['user'] = JSON.stringify(snapshot.val());
                        that2.db.user = JSON.parse(localStorage['user']);
                        new Toast("즐겨찾기 품목에 추가되었습니다.")

                        popupWishBtn.disabled = false;
                        document.querySelector('#loading').style.display = "none";
                    }.bind(that2));
                }.bind(that));
            } else {
                firebase.database().ref('user/' + this.userId + "/wish_product_list").set(reduceWishArr).then(function () {
                    const that2 = that;
                    firebase.database().ref('user/').once('value').then(function (snapshot) {
                        localStorage['user'] = JSON.stringify(snapshot.val());
                        that2.db.user = JSON.parse(localStorage['user']);
                        new Toast("즐겨찾기에서 삭제되었습니다.")


                        popupWishBtn.disabled = false;
                        wishBtn.className = "popup-wish"
                        document.querySelector('#loading').style.display = "none";
                    }.bind(that2));
                }.bind(that));
            }
        }.bind(this));
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
    constructor(db, id, navi, product) {
        this.db = db;
        this.id = id;
        this.navi = navi;
        this.product = product;
        this.userId = firebase.auth().currentUser.uid;
        this.value = 0;
        this.comment = "";
        this.data = [0, 0, 0, 0, ""];
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

        const userId = firebase.auth().currentUser.uid;


        writeBtn.addEventListener("click", function () {
            if (!!this.db.user[userId].product_review_list) {
                if (this.db.user[userId].product_review_list.includes(this.product.id)) {
                    new Toast("이미 리뷰를 작성한 상품입니다");
                } else {
                    this.setOnOff()
                }
            } else {
                this.setOnOff()
            }
        }.bind(this));

        const allergyBtn = new Dropdown("click", "#popupAllergyBtn", ".popup-newReview-Allergy-Wrapper");
        const allergyWrapper = document.querySelector('.popup-newReview-Allergy-Wrapper');

        allergyWrapper.addEventListener('click', function (e) {
            if (e.target.classList.contains("popup-newReview-Allergy-select")) {
                e.target.className = "popup-newReview-Allergy"
            } else {
                e.target.className = "popup-newReview-Allergy popup-newReview-Allergy-select"
            }
        });
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
        this.setStar();
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
            document.querySelector('#loading').style.display = "block";

            const database = firebase.database();
            this.reviewId = database.ref().child('review').push().key;

            let file = document.querySelector('#reviewImageInput').files[0];

            if (file) {
                this.fileName = 'images/' + this.reviewId + "." + file.type.split("/")[1];

                const storageRef = firebase.storage().ref();
                const mountainImagesRef = storageRef.child(this.fileName);

                mountainImagesRef.put(file).then(function (snapshot) {
                    this.updateDb();
                }.bind(this));
            } else {
                this.updateDb();
            }

        }
    }

    updateDb() {

        const storageRef = firebase.storage().ref();
        const database = firebase.database();

        if (this.fileName) {
            this.stoarge(storageRef, database);
        } else {
            this.getDatabase(database);
        }

    }

    getDatabase(database, url) {
        const that = this;
        let product_image;

        if (this.product.img) {
            product_image = this.product.img;
        } else {
            product_image = null;
        }

        let imageURL;
        if (url) {
            imageURL = url;
        } else {
            imageURL = product_image;
        }

        database.ref('review/' + this.reviewId).set({
            "bad": 0,
            "brand": this.product.brand,
            "category": this.product.category,
            "comment": this.data[4],
            "flavor": this.data[2],
            "grade": this.data[0],
            "id": this.reviewId,
            "p_id": this.product.id,
            "p_image": imageURL,
            "product_image": product_image,
            "p_name": this.product.name,
            "p_price": this.product.price,
            "price": this.data[1],
            "quantity": this.data[3],
            "timestamp": new TimeManager().timestamp(),
            "useful": 0,
            "user": this.db.user[this.userId].nickname,
            "user_image": this.db.user[this.userId].user_profile,
        });


        //해당 유저에 자기가 작성한 리뷰 리스트 넣기
        if (!!this.db.user[this.userId].product_review_list) {
            this.db.user[this.userId].product_review_list.push(this.product.id);
        } else {
            this.db.user[this.userId].product_review_list = [];
            this.db.user[this.userId].product_review_list.push(this.product.id);
        }

        database.ref('user/' + this.userId + '/product_review_list').set(this.db.user[this.userId].product_review_list);
        this.db.updateUserDb();

        const allergyArr = Array.from(document.querySelectorAll('.popup-newReview-Allergy-select'));

        if (allergyArr.length === 0) {

        } else {
            if (!!this.product.allergy) {
                allergyArr.forEach(function (element) {
                    if (this.product.allergy.includes(element.getAttribute("name"))) {
                    } else {
                        this.product.allergy.push(element.getAttribute("name"));
                    }
                }.bind(this))

            } else {
                this.product.allergy = [];
                allergyArr.forEach(function (element) {
                    this.product.allergy.push(element.getAttribute("name"));
                }.bind(this))
            }
        }


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
        database.ref('product/' + this.product.id).set(this.product).then(function () {
            that.db.updateProductDb();
        }.bind(that));


        firebase.database().ref('review/').once('value').then(function (snapshot) {
            localStorage['review'] = JSON.stringify(snapshot.val());
            that.db.review = JSON.parse(localStorage['review']);

            const util = new Util();

            const reviewArr = [];

            if (!!that.db.product[that.product.id].reviewList) {
                that.db.product[that.product.id].reviewList.forEach(function (e) {
                    reviewArr.push(that.db.review[e])
                });
            }

            new ReviewFilter(reviewArr);

            that.db.updateReviewDb();
            new UpdateData();
            document.querySelector('#loading').style.display = "none";

        }.bind(that));
    }

    stoarge(storageRef, database) {
        storageRef.child(this.fileName).getDownloadURL().then(function (url) {
            const that = this;
            that.getDatabase(database, url);

        }.bind(this)).catch(function (error) {
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

        this.manager = new TimeManager();

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

            value['time_score'] = this.manager.getDateTimeScore(splitTimestamp[0], splitTimestamp[1]);
            // value['rating'] = "carousel-review-star" + i;

            queryObj.push(value);
            i++;
        }

        return queryObj;
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
            const beforeTimeScore = a.time_score;
            const afterTimeScore = b.time_score;

            if (beforeTimeScore[2] < afterTimeScore[2]) {
                return 1;
            } else if (beforeTimeScore[2] > afterTimeScore[2]) {
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

        const priceArr = ["비쌈", "아쉽", "적당", "양호", "저렴"]
        const flavorArr = ["노맛", "아쉽", "적당", "양호", "존맛"]
        const quantityArr = ["창렬", "아쉽", "적당", "양호", "혜자"]

        let resultObj = []
        this.reviewObj.forEach(function (element) {
            if (typeof (element.price) === "number") {
                element.price = priceArr[parseInt(element.price) - 1];
                element.flavor = flavorArr[parseInt(element.flavor) - 1];
                element.quantity = quantityArr[parseInt(element.quantity) - 1];
            }
            resultObj.push(element);
        });

        this.reviewObj = resultObj;

        util.template(this.reviewObj, template, popup);
        util.setHandlebars(this.reviewObj);
    }
}

//리뷰 유용해야 별로에요 버튼 모듈 클래스
class ReviewRating {
    constructor(db, reviewClass, reviewArr, userId, productId, reviewId, likeList) {
        this.db = db;

        this.userId = userId;

        this.reviewArr = reviewArr;

        this.productId = productId;
        this.reviewId = reviewId;
        this.likeList = likeList;

        this.setEvent();
    }

    setEvent() {
        document.querySelector(".popup-reviewWrapperList").addEventListener("click", function (e) {
            if (e.target.classList.contains("popup-review-good") || e.target.classList.contains("popup-review-bad")) {

                let i = 0;

                const goodBtn = e.target.parentElement.parentElement.childNodes[1].childNodes[1];
                const badBtn = e.target.parentElement.parentElement.childNodes[3].childNodes[1];

                const review = this.reviewArr;

                this.userId = firebase.auth().currentUser.uid;
                this.reviewId = e.target.parentElement.getAttribute("name");

                let userReview = this.db.user[this.userId].review_like_list;

                if (!!userReview) {
                    this.likeList = userReview[this.reviewId];
                } else {
                    userReview = {};
                    this.likeList = userReview[this.reviewId];
                }

                /*if (!!this.db.user[this.userId].review_like_list) {
                    this.likeList = this.db.user[this.userId].review_like_list[this.reviewId];
                } else {
                    this.db.user[this.userId].review_like_list = {};
                    this.likeList = this.db.user[this.userId].review_like_list[this.reviewId];
                }*/

                const that = this;

                //데이터가 없거나, 0일경우
                if (!this.likeList || this.likeList === 0) {

                    document.querySelector('#loading').style.display = "block";
                    goodBtn.disabled = true;
                    badBtn.disabled = true;

                    let value = 0;
                    let newValue = parseInt(e.target.nextSibling.nextSibling.innerHTML);
                    newValue += 1;
                    e.target.nextSibling.nextSibling.innerHTML = newValue;


                    //good 버튼을 누를 경우
                    if (e.target.classList.contains("popup-review-good")) {
                        e.target.className = "good-bad-select popup-review-good";

                        for (const x of review) {
                            i++;
                            if (x.id === this.reviewId) {
                                x.useful++;
                                break;
                            }
                        }

                        value = 1;


                        firebase.database().ref('review/' + this.reviewId + "/useful")
                            .set(this.db.review[this.reviewId].useful + 1).then(function () {
                            that.db.updateReviewDb();
                        }.bind(that));

                        //bad button을 누를 경우
                    } else if (e.target.classList.contains("popup-review-bad")) {
                        e.target.className = "good-bad-select popup-review-bad";

                        for (const x of review) {
                            if (x.id === this.reviewId) {
                                x.bad++;
                                break;
                            }
                        }
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
                            document.querySelector('#loading').style.display = "none";
                            goodBtn.disabled = false;
                            badBtn.disabled = false;
                        }.bind(that2));
                    }.bind(that));
                    userReview[this.reviewId] = 1;
                    //이미 선택된적이 있는 경우
                } else if (this.likeList === 1) {

                    document.querySelector('#loading').style.display = "block";
                    goodBtn.disabled = true;
                    badBtn.disabled = true;

                    if (e.target.classList.contains("popup-review-good")) {
                        e.target.className = "popup-review-good";
                        let newValue = parseInt(e.target.nextSibling.nextSibling.innerHTML);
                        newValue -= 1;
                        e.target.nextSibling.nextSibling.innerHTML = newValue;

                        for (const x of review) {
                            i++;
                            if (x.id === this.reviewId) {
                                x.useful--;
                                break;
                            }
                        }

                        userReview[this.reviewId] = 0;

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

                                document.querySelector('#loading').style.display = "none";
                                goodBtn.disabled = false;
                                badBtn.disabled = false;
                            }.bind(that2));
                        }.bind(that));
                    } else {
                        document.querySelector('#loading').style.display = "none";
                        goodBtn.disabled = false;
                        badBtn.disabled = false;
                    }

                } else if (this.likeList === -1) {
                    document.querySelector('#loading').style.display = "block";
                    goodBtn.disabled = true;
                    badBtn.disabled = true;

                    if (e.target.classList.contains("popup-review-bad")) {
                        e.target.className = "popup-review-bad";
                        let newValue = parseInt(e.target.nextSibling.nextSibling.innerHTML);
                        newValue -= 1;
                        e.target.nextSibling.nextSibling.innerHTML = newValue;

                        for (const x of review) {
                            if (x.id === this.reviewId) {
                                x.bad--;
                                break;
                            }
                        }

                        userReview[this.reviewId] = 1;

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
                                document.querySelector('#loading').style.display = "none";
                                goodBtn.disabled = false;
                                badBtn.disabled = false;
                            }.bind(that2));
                        }.bind(that));

                    } else {
                        document.querySelector('#loading').style.display = "none";
                        goodBtn.disabled = false;
                        badBtn.disabled = false;
                    }
                }
            }
        }.bind(this));

    }

}

