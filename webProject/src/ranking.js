document.addEventListener('DOMContentLoaded', function (event) {
    const documentParams = {
        tab: '.main-rank-tab-wrapper',
        selected: 'main-rank-selectedtab',
        content: '.main-rank-content',
        template: '#card-ranking-template',
        check_key: 'main-rank-tab main-rank-selectedtab'
    };

    new MainRankingPreview(documentParams);

});

// main 인기 있는 리뷰 설정
class MainRankingPreview {
    constructor(documentParams) {
        this.rank_tab = document.querySelector(documentParams.tab);
        this.template = document.querySelector(documentParams.template).innerHTML;
        this.rank_content = document.querySelector(documentParams.content);
        this.selected = documentParams.selected;
        this.check_key = documentParams.check_key;
        const product = localStorage['product'];
        this.obj = JSON.parse(product);

        this.init();
    }

    init() {
        this.tabClickEvent(this.selected, this.check_key);
        document.getElementsByClassName(this.selected)[0].click();
    }

    tabClickEvent(selectedClassName, key) {
        this.rank_tab.addEventListener('click', function (e) {
            const selectedTab = document.getElementsByClassName(selectedClassName)[0];

            selectedTab.classList.remove(selectedClassName);
            e.target.classList.add(selectedClassName);

            const changeSelectedTab = document.getElementsByClassName(selectedClassName)[0];

            if (changeSelectedTab.getAttribute('class') == key) {
                const requestParam = changeSelectedTab.getAttribute('name');
                this.queryData(requestParam);
            } else {
                e.target.classList.remove(selectedClassName);
                selectedTab.classList.add(selectedClassName);
            }

        }.bind(this));
    }

    queryData(value){
      const queryObj = [];

      for(const key in this.obj){
        if(this.obj[key].category === value){
          queryObj.push(this.obj[key]);
        }
      }

      const sortObj = this.setGradeSort(queryObj);

      const data = sortObj.slice(0, 3);
      this.setRankingData(data);
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

    setRankingData(data) {
        const value = [];
        let i = 1;
        for (const x in data) {
            const val = data[x];
            val["rank"] = i;
            val["style"] = "card-main-badge-area" + i;
            val["rating"] = "card-main-rank-rating" + i;

            value.push(val);
            i++;
        }

        const template = Handlebars.compile(this.template);
        this.rank_content.innerHTML = template({ranking: value});
        this.setRatingHandler(value);
    }

    setRatingHandler(value) {
        let i = 1;
        for(const x of value){
            $("#card-main-rank-rating"+i).rateYo({
                rating: x.grade_avg,
                readOnly: true
            });
            i++;
        }
    }


}
