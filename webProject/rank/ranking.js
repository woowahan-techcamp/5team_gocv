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
  /*const getObject = {
      brand: 'all',
      category: '전체',
      keyword: ''
  };*/
  console.log(getObject);
  const searchParams = {};

  searchParams.brand = getObject.brand;
  searchParams.category = getObject.category;
  searchParams.sort = 'grade';
  searchParams.keyword = getObject.keyword;

  console.log(searchParams);

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

        // window height
        this.searchObject = searchParams;

        this.arrayObj = this.getArrayObject();

        this.flag = true;

        this.template = document.querySelector(rankingParams.template).innerHTML;
        this.rank_content = document.querySelector(rankingParams.content);

        this.init();
    }

    init() {
        this.setDefaultRankingData();
        this.sortEvent(this.selected_sort_rank_tab, this.sort_key);
        this.brandEvent(this.selected_brand_rank_tab, this.brand_key);
        this.categoryEvent(this.selected_category_rank_tab, this.category_key);
        this.reloadEvent();
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
          return 'gs25';
        case 'cu':
          return 'CU';
        case 'seven':
          return '7-eleven'
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
          queryObj.sort(function(a, b){
            return (a.review < b.review) ? -1 : (a.review > b.review) ? 1 : 0;
          });

          break;
        case 'row':
          queryObj.sort(function(a, b){
            return (a.price < b.price) ? -1 : (a.price > b.price) ? 1 : 0;
          });

          break;
        default:
          queryObj.sort(function(a, b){
            return (a.grade < b.grade) ? -1 : (a.grade > b.grade) ? 1 : 0;
          });
      }

      this.arrayObj = queryObj;
      this.setDefaultRankingData();
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
                value["rating"] = "card-main-rank-rating" + i;

                resultValue.push(value);

                const template = Handlebars.compile(this.template);
                element.innerHTML = template(resultValue);

                this.rank_content.appendChild(element);

                this.setRatingHandler(resultValue);
            }
        }
    }

    setSearchKeyword(){
      const value = [];

      for(const key in this.arrayObj){
        if((this.arrayObj[key].name).match(this.searchObject.keyword)){
          value.push(this.arrayObj[key]);
        }
      }
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
              if(i < 3){
                const rank = (i+1).toString();
                value["rank"] = rank;
                value["style"] = "card-main-badge-area" + rank;
              }
                value["rating"] = "card-main-rank-rating" + i;

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
            $("#card-main-rank-rating" + i).rateYo({
                rating: x.grade,
                readOnly: true
            });
            i++;
        }
    }
}
