import {TimeManager, BrandInfo} from "./manage";

export class ReviewPage {
    constructor(reviewParams, reviewObj) {
        this.template = document.querySelector(reviewParams.template).innerHTML;
        this.review_content = document.querySelector(reviewParams.content);
        this.readmore = document.getElementsByClassName(reviewParams.readmore);

        this.sort_review_tab = document.querySelector(reviewParams.sort_tab);
        this.selected_sort_review_tab = reviewParams.selected_sort;
        this.sort_key = reviewParams.sort_check_key;

        this.domControlKey = 'date';

        this.maxiumWord = 240;
        this.manager = new TimeManager();
        this.brand = new BrandInfo();
        this.now = this.manager.timestampScore();

        this.arrayObj = this.getArrayObject();

        this.init();
    }

    init() {
        this.setSorting(this.domControlKey);
        this.sortEvent(this.selected_sort_review_tab, this.sort_key);
        this.reloadEvent();
    }

    sortEvent(selectedClassName, key) {
        this.sort_review_tab.addEventListener('click', function (e) {
            const selectedTab = document.getElementsByClassName(selectedClassName)[0];

            selectedTab.classList.remove(selectedClassName);
            e.target.classList.add(selectedClassName);

            const changeSelectedTab = document.getElementsByClassName(selectedClassName)[0];

            if (changeSelectedTab.getAttribute('class') == key) {
                const requestParam = changeSelectedTab.getAttribute('name');
                this.domControlKey = requestParam;
                this.setSorting(requestParam);
            } else {
                e.target.classList.remove(selectedClassName);
                selectedTab.classList.add(selectedClassName);
            }
        }.bind(this));
    }

    setSorting(params) {
        const queryObj = [];
        let sortObj = [];

        for (const key in this.arrayObj) {
            queryObj.push(this.arrayObj[key]);
        }

        switch (params) {
            case 'date':
                sortObj = this.setDateSorting(queryObj);
                break;
            case 'useful':
                sortObj = this.setUsefulSorting(queryObj);
                break;
            default:
                break;
        }

        this.arrayObj = sortObj;

        this.setDefaultReviewData();
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

    setDateSorting(array) {
        array.sort(function (a, b) {
            const beforeTimeScore = parseFloat(a.time_score);
            const afterTimeScore = parseFloat(b.time_score);

            if (beforeTimeScore < afterTimeScore) {
                return 1;
            } else if (beforeTimeScore > afterTimeScore) {
                return -1;
            } else {
                return 0;
            }
        });

        return array;
    }

    setDefaultReviewData() {
        this.start = 0;
        this.end = 6;
        this.height = 400;

        const data = this.arrayObj;

        const resultValue = [];
        for (let i = this.start; i < this.end; i++) {
            const key = Object.keys(data)[i];
            const value = data[key];

            if (!!value) {
                if (value.comment.length > this.maxiumWord) {
                    value["comment"] = this.getCommentOptions(value.comment);
                }
                value["brand_image"] = this.brand.getBrandImage(value.brand);
                value["rating"] = "card-rank-rating" + i;
                resultValue.push(value);
            }
        }

        const template = Handlebars.compile(this.template);
        this.review_content.innerHTML = template(resultValue);
        this.setRatingHandler(resultValue);
    }

    getArrayObject() {
        const review = localStorage['review'];
        const obj = JSON.parse(review);

        const queryObj = [];

        for (const key in obj) {
            const value = obj[key];

            const time = value.timestamp;

            const splitTimestamp = time.split(' ');

            value['time_score'] = this.manager.getDate(splitTimestamp[0]) + this.manager.getTime(splitTimestamp[1]);
            const dateValue = this.manager.getDateWord(value.time_score);

            value['date'] = (!!dateValue) ? dateValue : splitTimestamp[0];
            value['key'] = key;

            queryObj.push(value);
        }

        return queryObj;
    }

    getCommentOptions(value) {
        let result = '';

        const str = value.split('');

        for (let i = 0; i < this.maxiumWord; i++) {
            result += str[i];
        }

        result += '...';

        return result;
    }



    setReviewData() {
        const resultValue = [];
        const element = document.createElement('div');

        for (let i = this.start; i < this.end; i++) {
            const key = Object.keys(this.arrayObj)[i];
            const value = this.arrayObj[key];

            if (!!value) {
                if (value.comment.length > this.maxiumWord) {
                    value["comment"] = this.getCommentOptions(value.comment);
                }

                value["brand_image"] = this.brand.getBrandImage(value.brand);
                value["rank"] = (i + 1).toString();
                value["rating"] = "card-rank-rating" + i;
                resultValue.push(value);
            }
        }
        const template = Handlebars.compile(this.template);
        element.innerHTML = template(resultValue);

        this.review_content.appendChild(element);

        this.setRatingHandler(resultValue);
    }

    reloadEvent() {
        const that = this;
        $(window).scroll(function () {
            const val = $(this).scrollTop();

            if (that.height < val) {
                that.start += 6;
                that.end += 6;
                that.height += 1000;
                that.setReviewData();
            }
        });
    }

    setRatingHandler(value) {
        let i = this.start;
        for (const x of value) {
            $("#card-rank-rating" + i).rateYo({
                rating: x.grade,
                readOnly: true,
                spacing: "10px",
                starWidth: "20px",
                normalFill: "#e2dbd6",
                ratedFill: "#ffcf4d"
            });
            i++;
        }
    }
}
