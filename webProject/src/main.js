
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


    //모달 리뷰 필터 드롭다운
    const reviewFilterDrop = new Dropdown("click",".popup-reviewFilter",".popup-reviewFilter-dropdown");

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
            if(this.drop.style.display === "block"){
                this.drop.style.display = "none";
            }else{
                this.drop.style.display = "block";
            }
        }.bind(this));
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
        this.init();
    }

    init(){
        this.dropdownEvent();
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
