document.addEventListener('DOMContentLoaded', function () {
    const documentParams = {
        leftBtn: 'gs-left-scroll',
        rightBtn: 'gs-right-scroll',
        // ul
        wrapper: '.brand-rank-item',
        template: 'brand-ranking-template',
        item_wrapper: 'gs-item-wrapper'
    };
    const obj = getRankingData();

    new BrandRankingPreview(documentParams, obj);
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
        this.setNode(this.rankingData[this.rankingDataKey[0]], 1);
        this.setNode(this.rankingData[this.rankingDataKey[1]], 1);
        this.setNode(this.rankingData[this.rankingDataKey[2]], 1);
        this.setNode(this.rankingData[this.rankingDataKey[3]], 1);
        this.setNode(this.rankingData[this.rankingDataKey[4]], 1);

        const array = Array.from(
            document.querySelectorAll(`#${this.item_template}> .brand-item-wrapper`));

        array.forEach(function(element){
            element.setAttribute('class', 'brand-item-wrapper brand-item-selected');
        });
        this.setLeftScroll();
        this.setRightScroll();
    }

    setNode(object, value){
        console.log(object);
        const element = document.createElement('li');
        element.setAttribute('class', 'brand-item-wrapper');

        const template = Handlebars.compile(this.template);

        Handlebars.registerHelper('event_tag', function () {
            const event_tag = Handlebars.escapeExpression(this);
            return new Handlebars.SafeString(event_tag);
        });

        element.innerHTML = template(object);

        if(value === 1){
            const nextElement = document.getElementById(this.item_template).firstChild;
            document.getElementById(this.item_template).insertBefore(element, nextElement);
        } else{
            document.getElementById(this.item_template).appendChild(element);
        }
    }

    removeNode(){
        const array = Array.from(
            document.querySelectorAll(`#${this.item_template}> .brand-item-selected`));

        array.forEach(function(element){
            console.log(element);
            document.getElementById(this.item_template).removeChild(element);
        }.bind(this));
    }

    setLeftScroll() {
        this.leftBtn.addEventListener('click', function () {
            const that = this;
            this.leftBtn.disabled = true;
            const template = document.getElementById(this.item_template).parentNode;

            this.query = this.query - 5;
            for(let x = this.query - 1; x > this.query -6; x--){
                let nextQuery;
                if(x < 0){
                    nextQuery = this.rankingDataSize + x;
                }else if(x >= this.rankingDataSize){
                    nextQuery = x - this.rankingDataSize;
                }else{
                    nextQuery = x;
                }
                this.setNode(this.rankingData[this.rankingDataKey[nextQuery]], -1);
            }

            if(this.query < 0){
                this.query += this.rankingDataSize;
            }

            this.index++;

            template.style.transitionDuration = '0.5s';
            template.style.marginLeft = '-50%';
            template.style.transform = 'translateX(-50%)';

            setTimeout(function() {
                that.removeNode();
                template.style.transitionDuration = '0s';

                const array = Array.from(document.querySelectorAll(`#${this.item_template} > .brand-item-wrapper`));
                array.forEach(function(element){
                    element.setAttribute('class', 'brand-item-wrapper brand-item-selected');
                });

                template.style.margin = 'auto';
                template.style.transform = 'translateX(0px)';

                that.leftBtn.disabled = false;
            }, 500);
        }.bind(this));
    }

    setRightScroll() {
        this.rightBtn.addEventListener('click', function () {
            const that = this;
            this.rightBtn.disabled = true;
            const template = document.getElementById(this.item_template).parentNode;

            for(let x = 0; x < 5; x++){
                this.setNode(this.rankingData[this.rankingDataKey[this.query]], 1);
                this.query++;
                if(this.query === this.rankingDataSize){
                    this.query = 0;
                }
            }

            this.index++;

            template.style.transitionDuration = '0.5s';
            template.style.transform = 'translateX(50%)';

            setTimeout(function() {
                that.removeNode();
                template.style.transitionDuration = '0s';
                // template.style.transform = 'none';

                const array = Array.from(document.querySelectorAll(`#${this.item_template} > .brand-item-wrapper`));
                array.forEach(function(element){
                    element.setAttribute('class', 'brand-item-wrapper brand-item-selected');
                });

                template.style.margin = 'auto';
                template.style.transform = 'translateX(0px)';

                that.rightBtn.disabled = false;
            }.bind(that), 500);
        }.bind(this));
    }
}