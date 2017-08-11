import "./firebaseinit.js"
import "./ranking.js"
import "./brand.js"
import "./index.css"

document.addEventListener('DOMContentLoaded', function (event) {
    console.log('DOM fully loaded and parsed');

    const brandDrop = document.querySelector(".fixTab-search-brand");
    const categoryDrop = document.querySelector(".fixTab-search-category");
    const serchButton = document.querySelector(".fixTab-search-word");
    const profileDrop = document.querySelector(".fixTab-profile-id");


    brandDrop.addEventListener("click",function () {
        const dropdown = document.querySelector((".fixTab-search-brand-dropdown"));


        if(dropdown.style.display === "block"){
            dropdown.style.display = "none";
        }else{
            dropdown.style.display = "block";
        }
    });

    categoryDrop.addEventListener("click",function () {
        const dropdown = document.querySelector((".fixTab-search-category-dropdown"));

        if(dropdown.style.display === "block"){
            dropdown.style.display = "none";
        }else{
            dropdown.style.display = "block";
        }
    });

    serchButton.addEventListener("click",function(){
        serchButton.setAttribute("value","");

    });

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

    const brandNavi = document.querySelector((".fixTab-search-brand-dropdown"));

    brandNavi.addEventListener("click",function (event) {
        brandDrop.firstChild.innerText = event.toElement.innerText;
    });

    const categoryNavi = document.querySelector((".fixTab-search-category-dropdown"));

    categoryNavi.addEventListener("click",function (event) {
        categoryDrop.firstChild.innerText = event.toElement.innerText;
    });



    const carousel = new Carousel('reviewNavi','carousel-leftButton',
        'carousel-rightButton', 10, 'carousel-template','carouselSec');
    const counter = new Counter(3000);
    counter.setCounter();




});


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

        //동그라미 클릭하면 해당 화면으로 전환 기능 - 아직 미구현 , 버튼으로만 가능하게끔 함
        // const circleArr = Array.from(document.querySelectorAll(".carousel-circle"));
        // circleArr.forEach(function (e) {
        //     const that=this;
        //     e.addEventListener("click",function(){
        //         this.index = parseInt(e.getAttribute("name"));
        //         this.changeCircle();
        //     }.bind(that));
        // }.bind(this));

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

