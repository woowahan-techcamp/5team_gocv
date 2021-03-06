
export class BrandRankingPreview {
    constructor(documentParams, brandName) {
        this.item_template = documentParams.item_wrapper;
        this.leftBtn = document.getElementById(documentParams.leftBtn);
        this.rightBtn = document.getElementById(documentParams.rightBtn);
        this.template = document.getElementById(documentParams.template).innerHTML;
        this.brand = documentParams.brand;
        this.translateValue = 0;



        // dummy data
        this.rankingData = this.brandFilter(brandName);
        this.rankingDataKey = Object.keys(this.rankingData);
        this.rankingDataSize = Object.keys(this.rankingData).length;
        // start
        this.index = 0;
        // view page
        this.query = 4;
        this.init();

    }

    init() {
        this.setNode(this.rankingData[this.rankingDataKey[0]], 1, 0);
        this.setNode(this.rankingData[this.rankingDataKey[1]], 1, 1);
        this.setNode(this.rankingData[this.rankingDataKey[2]], 1, 2);
        this.setNode(this.rankingData[this.rankingDataKey[3]], 1, 3);

        const array = Array.from(
            document.querySelectorAll(`#${this.item_template}> .brand-item-wrapper`));

        array.forEach(function (element) {
            element.setAttribute('class', 'brand-item-wrapper brand-item-selected');
        });

        this.setLeftScroll();
        this.setRightScroll();

    }

    setNode(object, value, params) {
        const element = document.createElement('li');
        element.setAttribute('class', 'brand-item-wrapper');
        element.setAttribute('name', object.id)

        const template = Handlebars.compile(this.template);

        Handlebars.registerHelper('event_tag', function () {
            const event_tag = Handlebars.escapeExpression(this);
            return new Handlebars.SafeString(event_tag);
        });
        const id = "brand-item-rating-" + this.brand + params;
        object['rating'] = id;

        element.innerHTML = template(object);

        if (value === -1) {
            const nextElement = document.getElementById(this.item_template).firstChild;
            document.getElementById(this.item_template).insertBefore(element, nextElement);
        } else {
            document.getElementById(this.item_template).appendChild(element);
        }

        this.setRatingHandler(id, object.grade_avg);
    }

    setRatingHandler(id, value) {
        $("#" + id).rateYo({
            rating: value,
            readOnly: true,
            spacing: "10px",
            starWidth: "20px",
            normalFill: "#e2dbd6",
            ratedFill: "#ffcf4d"
        });
    }

    removeNode() {
        const array = Array.from(
            document.querySelectorAll(`#${this.item_template}> .brand-item-selected`));

        array.forEach(function (element) {
            document.getElementById(this.item_template).removeChild(element);
        }.bind(this));
    }

    setLeftScroll() {

        this.leftBtn.addEventListener('click', function () {

            //화면 크기변화에 따른 값 조절
            const mq = window.matchMedia( "(min-width: 780px)" );

            if (mq.matches) {
                this.translateValue = '1200px';
            } else {
                this.translateValue = '300px';
            }

            const that = this;
            this.leftBtn.disabled = true;
            const template = document.getElementById(this.item_template).parentNode;

            this.query = this.query - 4;
            for (let x = this.query - 1; x > this.query - 5; x--) {
                let nextQuery;
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
            template.style.marginLeft = '-'+this.translateValue;
            template.style.transform = 'translateX('+this.translateValue+')';

            setTimeout(function () {
                that.removeNode();
                template.style.transitionDuration = '0s';
                template.style.margin = 'auto';
                template.style.transform = 'translateX(0px)';

                const array = Array.from(document.querySelectorAll(`#${this.item_template} > .brand-item-wrapper`));
                array.forEach(function (element) {
                    element.setAttribute('class', 'brand-item-wrapper brand-item-selected');
                });

                that.leftBtn.disabled = false;
            }, 400);
        }.bind(this));
    }

    setRightScroll() {


        this.rightBtn.addEventListener('click', function () {

            //화면 크기변화에 따른 값 조절
            const mq = window.matchMedia( "(min-width: 780px)" );

            if (mq.matches) {
                this.translateValue = '1200px';
            } else {
                this.translateValue = '300px';
            }

            const that = this;
            this.rightBtn.disabled = true;
            const template = document.getElementById(this.item_template).parentNode;

            for (let x = 0; x < 4; x++) {
                this.setNode(this.rankingData[this.rankingDataKey[this.query]], 1, this.query);
                this.query++;
                if (this.query === this.rankingDataSize) {
                    this.query = 0;
                }
            }

            this.index++;

            template.style.transitionDuration = '0.4s';
            template.style.transform = 'translateX(-'+this.translateValue+')';

            setTimeout(function () {
                that.removeNode();
                template.style.transitionDuration = '0s';
                template.style.transform = 'none';

                const array = Array.from(document.querySelectorAll(`#${this.item_template} > .brand-item-wrapper`));
                array.forEach(function (element) {
                    element.setAttribute('class', 'brand-item-wrapper brand-item-selected');
                });

                that.rightBtn.disabled = false;
            }.bind(that), 400);
        }.bind(this));
    }

    brandFilter(param){
        const obj = JSON.parse(localStorage['product']);

        const value = [];
        const finValue = [];
        const category = ['도시락', '김밥', '베이커리', '라면', '스낵', '아이스크림', '음료', '식품'];
        const defaultParam = {
            brand: "",
            category: "",
            event: [],
            id: "",
            img:"",
            name: "",
            price: ""
        };

        for(const key in obj){
            if(obj[key].brand === param){
                value.push(obj[key]);
            }
        }

        for(const x in category){
            finValue.push(defaultParam);
        }

        for(const key in value){
            for(const x in category){
                if(value[key].category === category[x]){
                    if(!!!finValue[x].price ||
                        finValue[x].grade_avg < value[key].grade_avg){
                        finValue[x] = value[key];
                    }
                }
            }
        }

        return finValue;
    }

}
