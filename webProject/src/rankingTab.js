document.addEventListener('DOMContentLoaded', function () {

    const rankingParams = {
        sort_tab: '.rank-query-type-wrapper',
        selected_sort: 'selected-rank-query-tab',
        sort_check_key: 'rank-query-tab selected-rank-query-tab',

        category_tab: '.rank-category-wrapper',
        selected_category: 'selected-rank-category-tab',
        category_check_key: 'rank-category-tab selected-rank-category-tab',

        brand_tab: '.rank-brand-type',
        selected_brand: 'selected-rank-brand-type-tab',
        brand_check_key: 'rank-brand-type-tab selected-rank-brand-type-tab',

        template: '#rank-card-template',
        content: '.ranking-item-list-wrapper'
    };

    const searchParams = getSearchParams();

    new RankingViewPage(rankingParams, searchParams);
});

function getSearchParams(){
  const getObject = JSON.parse(localStorage['search_keyword']);

  const searchParams = {};

  searchParams.brand = getObject.brand;
  searchParams.category = getObject.category;
  searchParams.sort = 'grade';
  searchParams.keyword = getObject.keyword;

  return searchParams;
}

class RankingViewPage {
    constructor(rankingParams, searchParams) {
        // sort
        this.sort_rank_tab = document.querySelector(rankingParams.sort_tab);
        this.selected_sort_rank_tab = rankingParams.selected_sort;
        this.sort_key = rankingParams.sort_check_key;

        // brand
        this.brand_rank_tab = document.querySelector(rankingParams.brand_tab);
        this.selected_brand_rank_tab = rankingParams.selected_brand;
        this.brand_key = rankingParams.brand_check_key;

        // category
        this.category_rank_tab = document.querySelector(rankingParams.category_tab);
        this.selected_category_rank_tab = rankingParams.selected_category;
        this.category_key = rankingParams.category_check_key;

        this.searchObject = searchParams;
        this.arrayObj = this.getArrayObject();

        this.flag = true;

        this.template = document.querySelector(rankingParams.template).innerHTML;
        this.rank_content = document.querySelector(rankingParams.content);

        this.init();
    }

    init() {
        this.setDefaultRankingData();
        this.setClickEvent();
        this.sortEvent(this.selected_sort_rank_tab, this.sort_key);
        this.brandEvent(this.selected_brand_rank_tab, this.brand_key);
        this.categoryEvent(this.selected_category_rank_tab, this.category_key);
        this.reloadEvent();
    }

    setClickEvent(){
      document.querySelector('.fixTab-search-button').addEventListener('click', function() {
          const storage = localStorage['search_keyword'];
          const value = JSON.parse(storage);

          const brand = this.getBrandName(value.brand);
          value['brand'] = brand;
          console.log(value);

          this.flag = true;
          this.searchObject = value;
          this.setDefaultRankingData();
      }.bind(this));

      document.querySelector("#fixTabNavi").addEventListener('click', function() {
        const selectedTab = document.getElementsByClassName("fixTab-select")[0];

        const text = document.getElementsByClassName("fixTab-select")[0].innerHTML;

        if(text === "랭킹"){
          const value = {
            brand: 'all',
            category: '전체',
            sort: 'grade',
            keyword: ''
          };

          this.flag = true;
          this.searchObject = value;
          this.setDefaultRankingData();
        }
      }.bind(this));
    }

    getArrayObject(){
      const product = localStorage['product'];
      const obj = JSON.parse(product);
      const queryObj = [];

      for(const key in obj){
        queryObj.push(obj[key]);
      }

      return queryObj;
    }

    sortEvent(selectedClassName, key) {
        this.sort_rank_tab.addEventListener('click', function (e) {
            const selectedTab = document.getElementsByClassName(selectedClassName)[0];

            selectedTab.classList.remove(selectedClassName);
            e.target.classList.add(selectedClassName);

            const changeSelectedTab = document.getElementsByClassName(selectedClassName)[0];

            if (changeSelectedTab.getAttribute('class') == key) {
              this.flag = true;
              const requestParam = changeSelectedTab.getAttribute('name');
              this.setSorting(requestParam);
            } else {
              e.target.classList.remove(selectedClassName);
              selectedTab.classList.add(selectedClassName);
            }
        }.bind(this));
    }

    brandEvent(selectedClassName, key){
        this.brand_rank_tab.addEventListener('click', function(e){
            const selectedTab = document.getElementsByClassName(selectedClassName)[0];

            selectedTab.classList.remove(selectedClassName);
            e.target.classList.add(selectedClassName);

            const changeSelectedTab = document.getElementsByClassName(selectedClassName)[0];

            if (changeSelectedTab.getAttribute('class') == key) {
              this.flag = true;
              const requestParam = changeSelectedTab.getAttribute('name');
              this.setBrandSort(requestParam);
            } else {
              e.target.classList.remove(selectedClassName);
              selectedTab.classList.add(selectedClassName);
            }
        }.bind(this));
    }

    categoryEvent(selectedClassName, key){
        this.category_rank_tab.addEventListener('click', function(e){

          const selectedTab = document.getElementsByClassName(selectedClassName)[0];

          selectedTab.classList.remove(selectedClassName);
          e.target.classList.add(selectedClassName);

          const changeSelectedTab = document.getElementsByClassName(selectedClassName)[0];

          if (changeSelectedTab.getAttribute('class') == key) {
            this.flag = true;
            const requestParam = changeSelectedTab.getAttribute('name');
            this.setCategorySort(requestParam);
          } else {
            e.target.classList.remove(selectedClassName);
            selectedTab.classList.add(selectedClassName);
          }
        }.bind(this));
    }

    getBrandName(params){
      switch (params) {
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

    setBrandSort(params){
      let brandName;
      if(!!params){
        brandName = this.getBrandName(params);
        this.searchObject.brand = brandName;
      }else{
        params = this.searchObject.brand;
        brandName = params;
      }

      this.arrayObj = this.getArrayObject();

      let queryObj = [];

      if(this.searchObject.brand != 'all'){
        for(const key in this.arrayObj){
          if(this.arrayObj[key].brand === brandName){
            queryObj.push(this.arrayObj[key]);
          }
        }
      }else{
        queryObj = this.getArrayObject();
      }

      this.arrayObj = queryObj;

      if(this.flag){
        this.flag = false;
        this.setCategorySort();
        this.setSorting();
      }

      this.setDefaultRankingData();
    }

    setCategorySort(param){
      const queryObj = [];
      if(!!param){
        this.searchObject.category = param;
      }else{
        param = this.searchObject.category;
      }

      if(this.flag){
        this.flag = false;
        this.setBrandSort();
      }

      for(const key in this.arrayObj){
        if(param === "전체"){
          queryObj.push(this.arrayObj[key]);
        }else if(this.arrayObj[key].category === param){
          queryObj.push(this.arrayObj[key]);
        }
      }

      this.arrayObj = queryObj;
      this.setDefaultRankingData();
    }

    setSorting(params) {
      const queryObj = [];
      let sortObj = [];

      if(!!params){
        this.searchObject.sort = params
      }else{
        params = this.searchObject.sort;
      }

      for(const key in this.arrayObj){
        queryObj.push(this.arrayObj[key]);
      }

      if(this.flag){
        this.flag = false;
        this.setBrandSort();
      }

      switch (params) {

        case 'review':
          sortObj = this.setReviewSort(queryObj);

          break;
        case 'row':
          sortObj = this.setRowPriceSort(queryObj);

          break;
        default:
          sortObj = this.setGradeSort(queryObj);
          break;
      }

      this.arrayObj = sortObj;
      this.setDefaultRankingData();
    }

    setRowPriceSort(array){
      array.sort(function(a, b){
        const beforePrice = parseInt(a.price);
        const afterPrice = parseInt(b.price);

        if (beforePrice > afterPrice) {
          return 1;
        } else if (beforePrice < afterPrice) {
          return -1;
        } else{
          return 0;
        }
      });

      return array;
    }

    setReviewSort(array){
      array.sort(function(a, b){
        const beforeReview = parseInt(a.review_count);
        const afterReview = parseInt(b.review_count);
        if (beforeReview < afterReview) {
          return 1;
        } else if (beforeReview > afterReview) {
          return -1;
        } else{
          return 0;
        }
      });

      return array;
    }

    setGradeSort(array){
      array.sort(function(a, b){
        const beforeGrade = parseFloat(a.grade_avg);
        const afterGrade = parseFloat(b.grade_avg);

        if (beforeGrade < afterGrade) {
          return 1;
        } else if (beforeGrade > afterGrade) {
          return -1;
        } else{
          return 0;
        }
      });

      return array;
    }

    reloadEvent() {
        const that = this;
        $(window).scroll(function () {
            const val = $(this).scrollTop();

            if (that.height < val) {
                that.start += 12;
                that.end += 12;
                that.height += 1000;
                that.setRankingData();
            }
        });
    }

    setRankingData() {
        const resultValue = [];
        const element = document.createElement('div');

        for (let i = this.start; i < this.end; i++) {
            const key = Object.keys(this.arrayObj)[i];
            const value = this.arrayObj[key];

            if (!!value) {
                value["rank"] = (i+1).toString();
                value["rating"] = "card-rank-rating" + i;
                resultValue.push(value);
            }
        }
        const template = Handlebars.compile(this.template);
        element.innerHTML = template(resultValue);

        this.rank_content.appendChild(element);

        this.setRatingHandler(resultValue);
    }

    setSearchKeyword(){
      const value = [];

      for(const key in this.arrayObj){
        if((this.arrayObj[key].name).match(this.searchObject.keyword)){
          value.push(this.arrayObj[key]);
        }
      }
      this.arrayObj = value;

      return value;
    }

    setDefaultRankingData() {
        this.start = 0;
        this.end = 12;
        this.height = 800;

        if(this.flag){
          this.setBrandSort();
        }

        const data = (!!this.searchObject.keyword) ? this.setSearchKeyword() : this.arrayObj;

        const resultValue = [];
        for (let i = this.start; i < this.end; i++) {
            const key = Object.keys(data)[i];
            const value = data[key];
            if (!!value) {
                const rank = (i+1).toString();
                value["rank"] = rank;
                value["style"] = "rank-card-badge-area" + rank;
                value["rating"] = "card-rank-rating" + i;
                resultValue.push(value);
            }
        }

        const template = Handlebars.compile(this.template);
        this.rank_content.innerHTML = template(resultValue);
        this.setRatingHandler(resultValue);
    }

    setRatingHandler(value) {
        let i = this.start;
        for (const x of value) {
            $("#card-rank-rating" + i).rateYo({
                rating: x.grade_avg,
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
