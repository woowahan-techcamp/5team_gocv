var ctx = document.getElementById('ratingChart').getContext('2d');
var ctx1 = document.getElementById('priceChart').getContext('2d');
var ctx2 = document.getElementById('flavorChart').getContext('2d');
var ctx3 = document.getElementById('quantityChart').getContext('2d');


var chart = new Chart(ctx, {
    type: 'line',

    data: {
        labels: ["1🌟", "2🌟", "3🌟", "4🌟", "5🌟"],
        datasets: [{
            label:"",
            backgroundColor: '#ffc225',
            borderColor: 'white',
            borderSkipped:"left",
            hoverBackgroundColor:"#eeb225",
            data: [0, 10, 5, 2, 20],
        }]
    },
    options: {
        responsive: true,
        legend: {
            display: false,
        },
        scales:{
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


var chart = new Chart(ctx1, {
    type: 'bar',

    data: {
        labels: ["비쌈", "", "적당", "", "저렴"],
        datasets: [{
            label:"",
            backgroundColor: '#ee5563',
            borderColor: 'white',
            borderSkipped:"left",
            hoverBackgroundColor:"#9c3740",
            data: [0, 10, 13, 2, 0],
        }]
    },
    options: {
        responsive: true,
        legend: {
            display: false,
        },
        scales:{
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
var chart = new Chart(ctx2, {
    type: 'bar',

    data: {
        labels: ["노맛", "", "적당", "", "존맛"],
        datasets: [{
            label:"",
            backgroundColor: '#ee5563',
            borderColor: 'white',
            borderSkipped:"left",
            hoverBackgroundColor:"#9c3740",
            data: [9, 8, 0, 3, 0],
        }]
    },
    options: {
        responsive: true,
        legend: {
            display: false,
        },
        scales:{
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
var chart = new Chart(ctx3, {
    type: 'bar',

    data: {
        labels: ["창렬", "", "적당", "", "헤자"],
        datasets: [{
            label:"",
            backgroundColor: '#ee5563',
            borderColor: 'white',
            borderSkipped:"left",
            hoverBackgroundColor:"#9c3740",
            data: [0, 2, 5, 8, 10],
        }]
    },
    options: {
        responsive: true,
        legend: {
            display: false,
        },
        scales:{
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



// 별, 맛, 양, 가격 레이팅을 저장해주는 클래스
class Review{

    constructor(id,navi){
        this.id=id;
        this.value=0;
        this.comment="";
        this.data=[0,0,0,0, ""];
        this.navi=navi;
        this.init()

    }

    init(){
        this.setStar();
        this.setNavi();
        const makeBtn = document.querySelector(".popup-newReview-completeBtn");
        makeBtn.addEventListener("click",function(){
            this.setMakeReview();
        }.bind(this));

        const cancelBtn = document.querySelector(".popup-newReview-cancel");
        cancelBtn.addEventListener("click",function(){
            const newReview = document.querySelector(".popup-newReviewWrapper");
            if(newReview.style.display === "none"){
                newReview.style.display = "";
            }else {
                newReview.style.display = "none";
            }
            this.setInit();
        }.bind(this))
    }


    //초기화 함수
    setInit(){


        const removeArr =document.getElementsByClassName("newReview-element-price-select");
        Array.from(removeArr).forEach(function(e){
            e.className = "newReview-element"
        })
        const removeArr2 =document.getElementsByClassName("newReview-element-flavor-select");
        Array.from(removeArr2).forEach(function(e){
            e.className = "newReview-element"
        })
        const removeArr3 =document.getElementsByClassName("newReview-element-quantity-select");
        Array.from(removeArr3).forEach(function(e){
            e.className = "newReview-element"
        })
        this.setStar()

    }


    setNavi(){
        const naviArr = Array.from(document.querySelectorAll(this.navi));

       //price 레이팅
        naviArr[0].addEventListener("click",function(e){
            const removeArr =document.getElementsByClassName("newReview-element-price-select");
            if(removeArr.length!==0){
                removeArr[0].className="newReview-element";
            }
            e.target.className+=" newReview-element-price-select";

            this.data[1]=parseInt(e.target.getAttribute("name"));
        }.bind(this));

        //flavor 레이팅
        naviArr[1].addEventListener("click",function(e){
            const removeArr =document.getElementsByClassName("newReview-element-flavor-select");
            if(removeArr.length!==0){
                removeArr[0].className="newReview-element";
            }
            e.target.className+=" newReview-element-flavor-select";
            this.data[2]=parseInt(e.target.getAttribute("name"));


        }.bind(this))

        //quantity 레이팅
        naviArr[2].addEventListener("click",function(e){
            const removeArr =document.getElementsByClassName("newReview-element-quantity-select");
            if(removeArr.length!==0){
                removeArr[0].className="newReview-element";
            }
            e.target.className+=" newReview-element-quantity-select";
            this.data[3]=parseInt(e.target.getAttribute("name"));
        }.bind(this))

    }


    setStar(){
        $("#"+this.id).rateYo({
            fullStar: true, // 정수단위로
            spacing: "15px" // margin

        }).on("rateyo.change", function (e, data) {
                this.value= data.rating;
                this.setText();
        }.bind(this));
    }

    setText(){
        const ele =  document.querySelector(".popup-newReview-star");
        ele.style.background="";
        this.data[0] = this.value;
        ele.innerHTML=this.value + "점 ";
    }

    setMakeReview(){
        this.data[4] = document.querySelector('.popup-newReview-comment').value;
        console.log(this.data)
    }

}




const makeReview= new Review("popupStar",".newReview-list");

const writeBtn = document.querySelector(".popup-reviewWrite");
writeBtn.addEventListener("click",function () {
    const newReview = document.querySelector(".popup-newReviewWrapper");
    if(newReview.style.display === "none"){
        newReview.style.display = "";
    }else{
        newReview.style.display = "none";
    }
})