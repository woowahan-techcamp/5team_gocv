document.addEventListener('DOMContentLoaded', function () {
    const obj = getRankingData();

    const gsParams = {
        brand: 'gs',
        leftBtn: 'gs-left-scroll',
        rightBtn: 'gs-right-scroll',
        // ul
        wrapper: '.brand-rank-item',
        template: 'brand-ranking-template',
        item_wrapper: 'gs-item-wrapper'
    };

    const cuParams = {
        brand: 'cu',
        leftBtn: 'cu-left-scroll',
        rightBtn: 'cu-right-scroll',
        // ul
        wrapper: '.brand-rank-item',
        template: 'brand-ranking-template',
        item_wrapper: 'cu-item-wrapper'
    };

    const sevenParams = {
        brand: 'seven',
        leftBtn: 'seven-left-scroll',
        rightBtn: 'seven-right-scroll',
        // ul
        wrapper: '.brand-rank-item',
        template: 'brand-ranking-template',
        item_wrapper: 'seven-item-wrapper'
    };

    new BrandRankingPreview(gsParams, obj);
    new BrandRankingPreview(cuParams, obj);
    new BrandRankingPreview(sevenParams, obj);
});

function getRankingData() {
    return {
        PR0001: {
            brand: 'GS25',
            category: '도시락',
            event: ['1+1', 'NEW'],
            img: "http://sbook.allabout.co.kr/autoalbum/a_mode/webupload/upload_dir/bgfcu/images/image1.jpg",
            name: '맛있어 도시락',
            price: 3500,
            grade: 4.0,
            id: 'PR0001'
        },
        PR0002: {
            brand: 'GS25',
            category: '김밥',
            event: ['1+1'],
            img: "http://sbook.allabout.co.kr/autoalbum/a_mode/webupload/upload_dir/bgfcu/images/image1.jpg",
            name: '맛있어 김밥',
            price: 3500,
            grade: 3.5,
            id: 'PR0001'
        },
        PR0003: {
            brand: 'GS25',
            category: '음료',
            event: ['1+1'],
            img: "http://sbook.allabout.co.kr/autoalbum/a_mode/webupload/upload_dir/bgfcu/images/image1.jpg",
            name: '맛있어 음료',
            price: 3500,
            grade: 3.3,
            id: 'PR0001'
        },
        PR0004: {
            brand: 'GS25',
            category: '베이커리',
            event: ['1+1'],
            img: "http://sbook.allabout.co.kr/autoalbum/a_mode/webupload/upload_dir/bgfcu/images/image1.jpg",
            name: '맛있어 빵',
            price: 3500,
            grade: 4.0,
            id: 'PR0001'
        },
        PR0005: {
            brand: 'GS25',
            category: '아이스크림',
            event: ['1+1'],
            img: "http://sbook.allabout.co.kr/autoalbum/a_mode/webupload/upload_dir/bgfcu/images/image1.jpg",
            name: '맛있어 아이스',
            price: 3500,
            grade: 4.0,
            id: 'PR0001'
        },
        PR0006: {
            brand: 'GS25',
            category: '유제품',
            event: ['1+1'],
            img: "http://sbook.allabout.co.kr/autoalbum/a_mode/webupload/upload_dir/bgfcu/images/image1.jpg",
            name: '맛있어 우유',
            price: 3500,
            grade: 4.3,
            id: 'PR0001'
        },
        PR0007: {
            brand: 'GS25',
            category: '스낵',
            event: ['1+1'],
            img: "http://sbook.allabout.co.kr/autoalbum/a_mode/webupload/upload_dir/bgfcu/images/image1.jpg",
            name: '맛있어 스낵',
            price: 3500,
            grade: 4.0,
            id: 'PR0001'
        },
        PR0008: {
            brand: 'GS25',
            category: '라면',
            event: ['1+1'],
            img: "http://sbook.allabout.co.kr/autoalbum/a_mode/webupload/upload_dir/bgfcu/images/image1.jpg",
            name: '맛있어 라면',
            price: 3500,
            grade: 3.3,
            id: 'PR0001'
        },
        PR0009: {
            brand: 'GS25',
            category: '즉석식품',
            event: ['1+1', 'NEW'],
            img: "http://sbook.allabout.co.kr/autoalbum/a_mode/webupload/upload_dir/bgfcu/images/image1.jpg",
            name: '맛있어 즉석',
            price: 3500,
            grade: 3.3,
            id: 'PR0001'
        }

    };
}

class BrandRankingPreview {
    constructor(documentParams, obj) {
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

        this.setRatingHandler(id, object.grade);
    }

    setRatingHandler(id, value) {
        $("#" + id).rateYo({
            rating: value,
            readOnly: true
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
                this.translateValue = '880px';
            } else {
                this.translateValue = '220px';
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
                this.translateValue = '880px';
            } else {
                this.translateValue = '220px';
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
}