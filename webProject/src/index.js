import "./firebaseinit.js"
import "./index.css"

document.addEventListener('DOMContentLoaded', function (event) {
    console.log('DOM fully loaded and parsed');

    const brandDrop = document.querySelector(".fixTab-search-brand");
    const categoryDrop = document.querySelector(".fixTab-search-category");
    const serchButton = document.querySelector(".fixTab-search-word");


    brandDrop.addEventListener("click",function () {
        const dropdown = document.querySelector((".fixTab-search-brand-dropdown"));


        if(dropdown.style.display === "block"){
            dropdown.style.display = "none";
        }else{
            dropdown.style.display = "block";
        }
    })

    categoryDrop.addEventListener("click",function () {
        const dropdown = document.querySelector((".fixTab-search-category-dropdown"));

        if(dropdown.style.display === "block"){
            dropdown.style.display = "none";
        }else{
            dropdown.style.display = "block";
        }
    })

    serchButton.addEventListener("click",function(){
        serchButton.setAttribute("value","");

    });


    const brandNavi = document.querySelector((".fixTab-search-brand-dropdown"));

    brandNavi.addEventListener("click",function (event) {
        brandDrop.firstChild.innerText = event.toElement.innerText;
    })

    const categoryNavi = document.querySelector((".fixTab-search-category-dropdown"));

    categoryNavi.addEventListener("click",function (event) {
        categoryDrop.firstChild.innerText = event.toElement.innerText;
    })



    const carousel= new Carousel('reviewNavi','carousel-leftButton', 'carousel-rightButton', 10);





});

class Carousel {

    constructor(reviewNavi,leftButton, rightButton, count) {
        this.reviewNavi = reviewNavi;
        this.leftButton = leftButton;
        this.rightButton = rightButton;
        this.count = count;
        this.index = 0;
        this.init();
    }

    init(){
        this.reviewNavi = document.getElementById(this.reviewNavi);
        this.leftButton = document.getElementById(this.leftButton);
        this.rightButton = document.getElementById(this.rightButton);
        this.leftButton.addEventListener("click",function(){
            this.beforePage();
        }.bind(this));
        this.rightButton.addEventListener("click",function(){
            this.nextPage();
        }.bind(this));

        const circleArr = Array.from(document.querySelectorAll(".carousel-circle"));
        circleArr.forEach(function (e) {
            const that=this;
            e.addEventListener("click",function(){
                this.index = parseInt(e.getAttribute("name"));
                this.changeCircle();
            }.bind(that));
        }.bind(this));

    }

    changeIndex(value) {
        this.index += value;
        console.log(this.index);

        if (this.index === this.count ) {
            this.index = 0;
        }

        if (this.index === -1) {
            this.index = this.count - 1;
        }
    }

    setDurationZero(){
        this.reviewNavi.style.transitionDuration="0s";
    }

    setDurationfull(){
        this.reviewNavi.style.transitionDuration="1s";
    }


    nextPage(){
        this.changeIndex(1);
        this.changeCircle();

        if(this.index = 900)
        const left= this.index*100;
        this.reviewNavi.style.left = "-"+left+"%";

    }

    beforePage(){
        this.changeIndex(-1);
        this.changeCircle();

        const left= this.index*100;
        this.reviewNavi.style.left = "-"+left+"%";

    }

    changeCircle(){
        const beforeCircle = document.querySelector(".carousel-circle-selected");
        beforeCircle.setAttribute("class","carousel-circle");


        const arr = Array.from(document.querySelectorAll(".carousel-circle"));
        arr[this.index].setAttribute("class","carousel-circle carousel-circle-selected");
    }




}
