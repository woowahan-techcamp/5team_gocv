
document.addEventListener('DOMContentLoaded', function (event) {
    const searchParams = {
        brand: '.fixTab-search-brand',
        brand_dropdown: '.fixTab-search-brand-dropdown',
        category: '.fixTab-search-category',
        category_drowndown: '.fixTab-search-category-dropdown',
        text: '.fixTab-search-word',
        button: '.fixTab-search-button'
    }

    new SearchTab(searchParams);

    const profileDrop = document.querySelector('.fixTab-profile-id');

    profileDrop.addEventListener("mouseover",function(){
        const dropdown = document.querySelector((".fixTab-profile-dropdown"));
        if(dropdown.style.display === "block"){
        }else{
            dropdown.style.display = "block";
        }
    });

    profileDrop.addEventListener("mouseout",function(){
        const dropdown = document.querySelector((".fixTab-profile-dropdown"));

        if(dropdown.style.display === "block"){
            dropdown.style.display = "none";
        }
    });

    const carousel = new Carousel('reviewNavi','carousel-leftButton',
        'carousel-rightButton', 10, 'carousel-template','carouselSec');
    const counter = new Counter(3000);
    counter.setCounter();



});


class Dropdown{
    constructor(event,button,drop){
        this.event = event;
        this.button = button;
        this.drop = drop;
        this.init();
    }

    init(){
        this.button = document.querySelector(this.button);
        this.drop = document.querySelector(this.drop);
        this.setEvent();
    }

    setEvent(){
        this.button.addEventListener(this.event,function(){
            console.log(this.drop.style.display)

            if(this.drop.style.display === "block"){
                this.drop.style.display = "none";
            }else{
                this.drop.style.display = "block";
            }
        }.bind(this),true);
    }


}

class Util {

    ajax(func) {
        const oReq = new XMLHttpRequest();
        oReq.addEventListener('load', function (e) {
            const data = JSON.parse(oReq.responseText);
            func.setData(data);
        });

        oReq.open('GET', func.url);
        oReq.send();
    }

    template(data,template,section){
        const context = data;
        const tmpl = Handlebars.compile(template);
        section.innerHTML = tmpl(context);
    }
}

//main 상단 리뷰 캐러셀
class Carousel {

    constructor(reviewNavi,leftButton, rightButton, count, template, sec) {
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

    init(){
        this.leftButton = document.getElementById(this.leftButton);
        this.rightButton = document.getElementById(this.rightButton);
        this.template = document.getElementById(this.template).innerHTML;
        this.sec = document.getElementById(this.sec);
        this.leftButton.addEventListener("click",function(){
            this.beforePage();
        }.bind(this));
        this.rightButton.addEventListener("click",function(){
            this.nextPage();
        }.bind(this));
        this.getData();
    }

    changeIndex(value) {
        this.index += value;
        console.log(this.index);
    }

    setDurationZero(){
        this.reviewNavi.style.transition="none";
    }

    setDurationfull(){
        this.reviewNavi.style.transition="";
        this.reviewNavi.style.transitionDuration="1s";
    }

    nextPage(){
        this.setDurationfull();
        this.changeIndex(1);
        const left = (this.index+1) * 100;
        this.reviewNavi.style.left = "-" + left + "%";

        if(this.index === this.count){
            console.log("sisi");

            this.index = 0;
            setTimeout(function () {
                this.setDurationZero();
                this.reviewNavi.style.left="-100%";
            }.bind(this), 1000);

        }

        this.changeCircle();
    }

    beforePage(){
        this.setDurationfull();
        this.changeIndex(-1);
        const left = (this.index+1) * 100;
        this.reviewNavi.style.left = "-" + left + "%";


        if(this.index === -1){
            this.index = 9;
            setTimeout(function () {
                this.setDurationZero();
                this.reviewNavi.style.left="-1000%";
            }.bind(this), 1000);
        }

        this.changeCircle();
    }

    changeCircle(){
        const beforeCircle = document.querySelector(".carousel-circle-selected");
        beforeCircle.setAttribute("class","carousel-circle");


        const arr = Array.from(document.querySelectorAll(".carousel-circle"));
        arr[this.index].setAttribute("class","carousel-circle carousel-circle-selected");
    }

    getData() {
        firebase.database().ref('/review').once('value').then(function(snapshot) {
            this.setData(snapshot.val());
        }.bind(this));
    }

    setData(data){
        this.data = data;


        const arr = []
        arr.push(this.data["R0010"]);

        for(let i = 1 ;i<=10;i++){
            if(i>=10&&i<100){
                arr.push(this.data["R00"+i]);
            }else{
                arr.push(this.data["R000"+i]);
            }
        }
        arr.push(this.data["R0001"]);


        const util = new Util();
        console.log(arr);

        util.template(arr,this.template,this.sec);
        this.reviewNavi = document.getElementById(this.reviewNavi);
    }
}

//메인 상단 고정 탭
class SearchTab{
    constructor(searchParams){
        this.searchParams = searchParams;

        this.brandDrop = document.querySelector(searchParams.brand);
        this.brandNavi = document.querySelector(searchParams.brand_dropdown);
        this.categoryDrop = document.querySelector(searchParams.category);
        this.categoryNavi = document.querySelector(searchParams.category_drowndown);
        this.inputText = document.querySelector(searchParams.text);
        this.searchButton = document.querySelector(searchParams.button);
        this.fixTabNavi = document.querySelector("#fixTabNavi")
        this.init();
    }

    init(){
        this.dropdownEvent();
        this.setTabClickEvent()
    }

    dropdownEvent(){
        const brandDrop = new Dropdown("click",this.searchParams.brand,this.searchParams.brand_dropdown);
        const categoryDrop = new Dropdown("click",this.searchParams.category,this.searchParams.category_drowndown);


        this.brandNavi.addEventListener("click",function (event) {
            this.brandDrop.firstChild.innerText = event.toElement.innerText;
        }.bind(this));

        this.categoryNavi.addEventListener("click",function (event) {
            this.categoryDrop.firstChild.innerText = event.toElement.innerText;
        }.bind(this));

        this.searchButton.addEventListener("click",function(){
            if(this.inputText.value === ''){
                console.log('검색어 입력 하셈;;');
            }else{
                this.setQuery();
            }
        }.bind(this));
    }

    setQuery(){
        const queryBrand = this.brandDrop.firstChild.innerText;
        const queryCategory = this.categoryDrop.firstChild.innerText;

        let brand;
        switch (queryBrand) {
            case 'GS25':
                brand = 'gs25';
                break;
            case '7ELEVEN':
                brand = '7-eleven'
                break;
            case 'CU':
                brand = 'CU';
                break;
            default:
                brand = '';
                break;
        }

        const category = (queryCategory === '카테고리') ? '' : queryCategory;
        const text = this.inputText.value;

        const product = localStorage['product'];
        const object = JSON.parse(product);

        this.setFilterSearchData(brand, category, text, object);
    }

    setFilterSearchData(brand, category, text, object){
        const value = [];
        console.log(brand, category, text);
        for(const key in object){
            if(brand === ''){
                if(category === ''){
                    if((object[key].name).match(text)){
                        value.push(object[key]);
                    }
                } else{
                    if(object[key].category === category){
                        if((object[key].name).match(text)){
                            value.push(object[key]);
                        }
                    }
                }
            } else{
                if(object[key].brand === brand){
                    if(category === ''){
                        if((object[key].name).match(text)){
                            value.push(object[key]);
                        }
                    } else{
                        if(object[key].category === category){
                            if((object[key].name).match(text)){
                                value.push(object[key]);
                            }
                        }
                    }
                }
            }
        }

        console.log(value);
    }

    setTabClickEvent(){
        this.fixTabNavi.addEventListener('click', function (e) {
            const selectedTab = document.getElementsByClassName("fixTab-select")[0];

            selectedTab.classList.remove("fixTab-select");
            e.target.classList.add("fixTab-select");

            const text = document.getElementsByClassName("fixTab-select")[0].innerHTML;

            if (text === "편리해") {
                document.querySelector(".main-wrapper").style.display = "";
                document.querySelector(".rank-container").style.display = "none";
            } else if(text === "랭킹"){
                document.querySelector(".main-wrapper").style.display = "none";
                document.querySelector(".rank-container").style.display = "";
            } else if(text === "리뷰"){
                document.querySelector(".main-wrapper").style.display = "none";
                document.querySelector(".rank-container").style.display = "none";
            }

        }.bind(this));
    }

}

//메인 하단 jquery plugin 을 이용한 counter, 매개변수는 스크롤 위치를 의미
class Counter{
    constructor(max){
        this.max = max;
    }

    setCounter(){
        var max = this.max;
        $(window).scroll(function () {
            var val = $(this).scrollTop();
            var cover = $('.cover');
            if (max < val) {
                $('#counter1').animateNumber({ number: 4200 },2000);
                $('#counter2').animateNumber({ number: 3203 },2000);
                $('#counter3').animateNumber({ number: 23 },2000);
                max = 99999;
            }
        });

    }


}

//chart.js를 이용하여 차트를 만드는 클래스
class MakeChart{
    constructor(feature, label, data, id, color, hoverColor ){
        this.feature = feature;
        this.label = label;
        this.data = data;
        this.id = id;
        this.color = color;
        this.hoverColor =hoverColor;
        this.setChart()
    }

    setChart(){
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

    constructor(id, navi) {
        this.id = id;
        this.value = 0;
        this.comment = "";
        this.data = [0, 0, 0, 0, ""];
        this.navi = navi;
        this.init()

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
        writeBtn.addEventListener("click", function () {
            this.setOnOff()
        }.bind(this));
    }

    //초기화 함수
    setInit() {
        const removeArr = document.getElementsByClassName("newReview-element-price-select");
        Array.from(removeArr).forEach(function (e) {
            e.className = "newReview-element"
        })
        const removeArr2 = document.getElementsByClassName("newReview-element-flavor-select");
        Array.from(removeArr2).forEach(function (e) {
            e.className = "newReview-element"
        })
        const removeArr3 = document.getElementsByClassName("newReview-element-quantity-select");
        Array.from(removeArr3).forEach(function (e) {
            e.className = "newReview-element"
        })
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
            console.log(e);
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


        }.bind(this))

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
        console.log(this.data)
        this.setOnOff();
    }

}

//image 업로드하고 미리보기 만드는 클래스
class UpLoadImage{
    constructor(inputId,imgPreviewId){
        this.inputId = inputId;
        this.imgPreviewId = imgPreviewId

        this.init();
    }

    init(){
        document.querySelector("#"+this.inputId).addEventListener("change",function () {
            this.previewFile();
        }.bind(this))
    }

    previewFile(){
        let preview = document.querySelector('#'+this.imgPreviewId);
        let file = document.querySelector('#'+this.inputId).files[0];
        let reader = new FileReader();



        reader.addEventListener("load", function () {
            preview.src = reader.result;

        },false);

        if (file) {
            reader.readAsDataURL(file);
        }

    }

}

function loadDetailProduct(event) {

    const product = localStorage['product'];
    const obj = JSON.parse(product);

    const review = localStorage['review'];
    const obj2 = JSON.parse(review);


    const id = event.getAttribute("name");
    const template = document.querySelector("#popup-template").innerHTML;
    const sec = document.querySelector("#popup");
    const util = new Util();

    // const value = obj[grade_total]/obj[grade_count];
    const value=4.3;
    obj[id].grade= value;

    util.template(obj[id],template,sec);

    const gradeData = [];
    Object.keys(obj[id].grade_data).forEach(function(e){
        gradeData.push(obj[id].grade_data[e])
    });

    const priceData = [];
    Object.keys(obj[id].price_level).forEach(function(e){
        priceData.push(obj[id].price_level[e])
    });

    const flavorData = [];
    Object.keys(obj[id].flavor_level).forEach(function(e){
        flavorData.push(obj[id].flavor_level[e])
    })

    const quantityData = [];
    Object.keys(obj[id].quantity_level).forEach(function(e){
        quantityData.push(obj[id].quantity_level[e])
    })

    const ratingChart=new MakeChart('line',["1🌟", "2🌟", "3🌟", "4🌟", "5🌟"],gradeData,'ratingChart','#ffc225','#eeb225');
    const priceChart=new MakeChart('bar',["비쌈", "", "적당", "", "저렴"],priceData,'priceChart','#ee5563','#9c3740');
    const flavorChart=new MakeChart('bar',["노맛", "", "적당", "", "존맛"],flavorData,'flavorChart','#ee5563','#9c3740');
    const quantityChart=new MakeChart('bar',["창렬", "", "적당", "", "헤자"],quantityData,'quantityChart','#ee5563','#9c3740');

    const reviewArr = [];

    obj[id].reviewList.forEach(function (e) {
        reviewArr.push(obj2[e])
    });

    console.log(reviewArr);

    const template2 = document.querySelector("#review-template").innerHTML;
    const sec2 = document.querySelector("#popupReview");

    util.template(reviewArr,template2,sec2);



    //rateyo.js를 사용하기 위한 별이 들어갈 DOM의 id, 전체 리뷰 Wrapper 클래스명
    const makeReview = new Review("popupStar", ".newReview-list");
    const reviewImageUpLoad = new UpLoadImage('reviewImageInput','imagePreview');

    //모달 리뷰 필터 드롭다운
    const reviewFilterDrop = new Dropdown("click",".popup-reviewFilter",".popup-reviewFilter-dropdown");

}

//이런식으로 해야 웹팩에서 function을 html onclick으로 사용가
window.loadDetailProduct = loadDetailProduct;
