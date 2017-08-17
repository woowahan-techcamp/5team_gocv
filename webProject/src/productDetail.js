

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

//image 업로드하고 미리보기 만드는 클래
class ImageUpLoad{
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


// 형태, x라벨, 데이터, id, 배경색, 호버배경색
const ratingChart=new MakeChart('line',["1🌟", "2🌟", "3🌟", "4🌟", "5🌟"],[0, 10, 5, 2, 20],'ratingChart','#ffc225','#eeb225');
const priceChart=new MakeChart('bar',["비쌈", "", "적당", "", "저렴"],[0, 10, 13, 2, 0],'priceChart','#ee5563','#9c3740');
const flavorChart=new MakeChart('bar',["노맛", "", "적당", "", "존맛"],[0, 10, 13, 2, 0],'flavorChart','#ee5563','#9c3740');
const quantityChart=new MakeChart('bar',["창렬", "", "적당", "", "헤자"],[0, 10, 13, 2, 0],'quantityChart','#ee5563','#9c3740');

//rateyo.js를 사용하기 위한 별이 들어갈 DOM의 id, 전체 리뷰 Wrapper 클래스명
const makeReview = new Review("popupStar", ".newReview-list");

const reviewImageUpLoad = new ImageUpLoad('reviewImageInput','imagePreview');

