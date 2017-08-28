// utils
export class TimeManager {
    constructor() {
        this.now = this.getNowTimeScore();
    }

    getNowTimeScore() {
        const d = new Date();
        const curr_date = d.getDate();
        const curr_month = d.getMonth() + 1; //Months are zero based
        const curr_year = d.getFullYear();
        const curr_hour = d.getHours();
        const curr_minute = d.getMinutes();
        const curr_second = d.getSeconds();

        let dateValue = 0;

        for (let x = 2016; x < curr_year; x++) {
            if (x % 4 == 0) {
                if (x % 100 != 0 || x % 400 == 0) {
                    dateValue += 366;
                }
            } else {
                dateValue += 365;
            }
        }

        for (let x = 1; x < curr_month; x++) {
            switch (x) {
                case 4:
                case 6:
                case 9:
                case 11:
                    dateValue += 31;
                    break;
                case 2:
                    dateValue += 28;
                default:
                    dateValue += 31;
                    break;
            }
        }

        dateValue += curr_date;


        let timeValue = 0;

        timeValue = (curr_minute + (curr_hour * 60)) * 100;
        timeValue += curr_second;

        return parseFloat(dateValue + (timeValue / 1e6));
    }

    getDateWord(value) {
        const date = (this.now * 1e6) - (value * 1e6);

        if (date < 6000) {
            if (date / 100 === 0) {
                return '방금 전';
            } else {
                return parseInt(date / 100) + '분 전';
            }
        } else if (date >= 1e6 && date <= 3e6) {
            return parseInt(date / 1e6) + '일 전';
        } else if (date <= 1e6) {
            const day = parseInt(this.now);
            const nowHour = parseInt((this.now - day) * 10000) + 2400;
            const hour = parseInt((value - 634) * 10000);
            if (hour > 1e4) {
                return parseInt(hour / 1e4) + '시간 전';
            } else {
                return parseInt((nowHour - hour) / 100) + '시간 전';
            }
        }
    }

    timestamp() {
        const d = new Date();
        let curr_date = d.getDate();
        let curr_month = d.getMonth() + 1; //Months are zero based
        let curr_year = d.getFullYear();
        let curr_hour = d.getHours();
        let curr_minute = d.getMinutes();
        let curr_second = d.getSeconds();

        if (curr_month < 10) {
            curr_month = "0" + curr_month;
        }

        if (curr_hour < 10) {
            curr_hour = "0" + curr_hour;
        }

        if (curr_minute < 10) {
            curr_minute = "0" + curr_minute;

        }

        if (curr_second < 10) {
            curr_second = "0" + curr_second;

        }

        return curr_year + "-" + curr_month + "-" + curr_date + " " +
            curr_hour + ":" + curr_minute + ":" + curr_second;
    }

    getDate(value) {
        const splitDate = value.split('-');

        const yy = parseInt(splitDate[0]);
        const mm = parseInt(splitDate[1]);
        const dd = parseInt(splitDate[2]);

        let dateValue = 0;

        for (let x = 2016; x < yy; x++) {
            if (x % 4 == 0) {
                if (x % 100 != 0 || x % 400 == 0) {
                    dateValue += 366;
                }
            } else {
                dateValue += 365;
            }
        }

        for (let x = 1; x < mm; x++) {
            switch (x) {
                case 4:
                case 6:
                case 9:
                case 11:
                    dateValue += 31;
                    break;
                case 2:
                    dateValue += 28;
                default:
                    dateValue += 31;
                    break;
            }
        }

        dateValue += dd;

        return (dateValue);
    }

    getTime(value) {
        const splitTime = value.split(':');

        const hh = parseInt(splitTime[0]);
        const mm = parseInt(splitTime[1]);
        const ss = parseInt(splitTime[2]);

        let timeValue = 0;

        timeValue = (mm + (hh * 60)) * 100;
        timeValue += ss;

        return timeValue / 1e6;
    }

    timestampScore() {
        const d = new Date();
        const curr_date = d.getDate();
        const curr_month = d.getMonth() + 1; //Months are zero based
        const curr_year = d.getFullYear();
        const curr_hour = d.getHours();
        const curr_minute = d.getMinutes();
        const curr_second = d.getSeconds();

        let dateValue = 0;

        for (let x = 2016; x < curr_year; x++) {
            if (x % 4 == 0) {
                if (x % 100 != 0 || x % 400 == 0) {
                    dateValue += 366;
                }
            } else {
                dateValue += 365;
            }
        }

        for (let x = 1; x < curr_month; x++) {
            switch (x) {
                case 4:
                case 6:
                case 9:
                case 11:
                    dateValue += 31;
                    break;
                case 2:
                    dateValue += 28;
                default:
                    dateValue += 31;
                    break;
            }
        }

        dateValue += curr_date;

        let timeValue = 0;
        timeValue = (curr_minute + (curr_hour * 60)) * 100;
        timeValue += curr_second;

        return parseFloat(dateValue + (timeValue / 1e6));

    }

    getDateWord(value) {
        const date = (this.now * 1e6) - (value * 1e6);

        if (date < 6000) {
            if (date / 100 < 1) {
                return '방금 전';
            } else {
                return parseInt(date / 100) + '분 전';
            }
        } else if (date >= 1e6 && date <= 3e6) {
            return parseInt(date / 1e6) + '일 전';
        } else if (date <= 1e6) {
            const day = parseInt(this.now);
            const nowHour = parseInt((this.now - day) * 10000) + 2400;
            const hour = parseInt((value - 634) * 10000);
            if (hour > 1e4) {
                return parseInt(hour / 1e4) + '시간 전';
            } else {
                return parseInt((nowHour - hour) / 100) + '시간 전';
            }
        }
    }
}

export class BrandInfo {

    constructor() {

    }

    getBrandImage(value) {
        switch (value) {
            case 'gs25':
            case 'GS25':
                return './image/gs25.jpg';
            case 'cu':
            case 'CU':
                return './image/cu.jpg';
            case 'seven':
            case '7ELEVEN':
            case '7-eleven':
                return './image/seven.png';
            default:
                return './image/all_category.png';
        }
    }

    getBrandName(value) {
        switch (value) {
            case 'gs25':
            case 'GS25':
                return 'GS25';
            case 'cu':
            case 'CU':
                return 'CU';
            case 'seven':
            case '7ELEVEN':
                return '7-eleven';
            default:
                return 'all';
        }
    }
}

export class PopupInfo {
    constructor() {

    }

    // My Page
    setMyPageInit() {
        this.myPageInit();
        this.getMyPageEvent();
    }

    myPageInit() {
        this.popupOverlay = document.querySelector('.myPage-overlay');
        this.popupInner = document.querySelector('.myPage-wrapper');

        $("body").css("overflow", "hidden");

        this.flag = false;
    }

    getMyPageEvent() {
        /* item view modal settings */
        this.popupOverlay.addEventListener('click', function () {
            if (!this.flag) {
                $("body").css("overflow", "visible");
                this.closeMyPagePopup();
            } else {
                this.flag = false;
            }
        }.bind(this));

        this.popupInner.addEventListener('click', function (e) {
            this.flag = true;
            e.stopPropagation();
        }.bind(this));
    }

    closeMyPagePopup() {
        if (!this.flag) {
            document.getElementsByClassName('popup-close-fake')[0].click();
            this.flag = false;
        }
    }

    setRefreshOverlay() {
        const popup = document.querySelector('#popup');

        popup.addEventListener('click', function () {
            document.getElementsByClassName('popup-close-fake')[0].click();
        });
    }

    // Sign Page
    setSignPageInit() {
        this.signPageInit();
        this.getSignPageEvent();
    }

    signPageInit() {
        this.signOverlay = document.querySelector('.sign-overlay');
        this.signInner = document.querySelector('.sign-wrapper');

        this.signFlag = false;

    }

    getSignPageEvent() {
        this.signOverlay.addEventListener('click', function () {
            if (!this.signFlag) {
                this.closeSignPagePopup();
            }
            this.signFlag = false;

        }.bind(this));

        this.signInner.addEventListener('click', function () {
            this.signFlag = true;
        }.bind(this));

    }

    closeSignPagePopup() {
        if (!this.signFlag) {
            this.signOverlay.style.display = "none";
            this.signFlag = false;
        }
    }

    // Item Page
    setItemPageInit() {
        this.itemPageInit();
        this.getItemPageEvent();
    }

    itemPageInit() {
        this.popupOverlay = document.querySelector('.overlay');
        this.popupInner = document.querySelector('.popup-wrapper');

        this.flag = false;
    }

    getItemPageEvent() {
        this.popupOverlay.addEventListener('click', function () {
            if (!this.flag) {
                this.closeItemPagePopup();
            } else {
                this.flag = false;
            }
        }.bind(this));

        this.popupInner.addEventListener('click', function (e) {
            this.flag = true;
            e.stopPropagation();
        }.bind(this));
    }

    closeItemPagePopup() {
        if (!this.flag) {
            document.getElementsByClassName('popup-close-fake')[0].click();
            $("body").css("overflow", "visible");
            this.flag = false;
        }
    }

    // Review
    setReviewPageInit() {
        this.reviewPageInit();
        this.getReviewPageEvent();
    }

    reviewPageInit() {
        this.popupOverlay = document.querySelector('.overlay');
        this.popupInner = document.querySelector('.popup-review-preview');

        this.flag = false;
    }

    getReviewPageEvent() {
        this.popupOverlay.addEventListener('click', function () {
            if (!this.flag) {
                this.closeReviewPagePopup();
            } else {
                this.flag = false;
            }
        }.bind(this));

        this.popupInner.addEventListener('click', function (e) {
            this.flag = true;
            e.stopPropagation();
        }.bind(this));
    }

    closeReviewPagePopup() {
        if (!this.flag) {
            document.getElementsByClassName('popup-close-fake')[0].click();
            $("body").css("overflow", "visible");
            this.flag = false;
        }
    }
}