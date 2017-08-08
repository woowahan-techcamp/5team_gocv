// const firebase = require('firebase/app');

/*
const config = {
    apiKey: "AIzaSyAnDViQ2LyXlNzBWO2kWyGnN-Lr22B9sUI",
    authDomain: "pyeonrehae.firebaseapp.com",
    databaseURL: "https://pyeonrehae.firebaseio.com",
    projectId: "pyeonrehae",
    storageBucket: "pyeonrehae.appspot.com",
    messagingSenderId: "296270517036"
};*/

document.addEventListener('DOMContentLoaded', function(event) {
  const documentParams = {
    tab: '.mid-main-rv-tab',
    selected: 'main-rv-selectedtab',
    content: '.main-rv-content',
    template: '#card-template',
    check_key: 'main-rv-tab main-rv-selectedtab'
  };

  const popularReview = new MainPopularReview(documentParams);

});

// firebase 통신
class ReportFirebase{
  call(url, func){
    const obj = {
      "R0001" : {
        "bad" : 3,
        "brand" : "all",
        "category" : "도시락",
        "flavor" : 2,
        "grade" : 4,
        "image" : "http://cdn2.bgfretail.com/bgfbrand/files/product/424DF97A63D4407AB95B557B2140A104.jpg",
        "price" : 3,
        "product_key" : "PR02676",
        "quantity" : 5,
        "timestamp" : "2017-08-06",
        "useful" : 5,
        "user" : "준킴"
      },
      "R0002" : {
        "bad" : 3,
        "brand" : "CU",
        "category" : "도시락",
        "flavor" : 2,
        "grade" : 4,
        "image" : "https://scontent-icn1-1.cdninstagram.com/t51.2885-15/e35/20633189_1972534939631469_9076556705919139840_n.jpg",
        "price" : 3,
        "product_key" : "PR02677",
        "quantity" : 5,
        "timestamp" : "2017-08-06",
        "useful" : 5,
        "user" : "통통"
      },
      "R0003" : {
        "bad" : 3,
        "brand" : "CU",
        "category" : "도시락",
        "flavor" : 2,
        "grade" : 4,
        "image" : "https://scontent-icn1-1.cdninstagram.com/t51.2885-15/e35/20633189_1972534939631469_9076556705919139840_n.jpg",
        "price" : 3,
        "product_key" : "PR02678",
        "quantity" : 5,
        "timestamp" : "2017-08-06",
        "useful" : 5,
        "user" : "세훈"
      }
    };
    func.setReviewData(obj);
    // import firebase from 'firebase';
    /*
    firebase.database().ref('sample').once('value').then(function (snapshot) {
        const json = JSON.stringify(snapshot.val(), null, 3);
        console.log(json);
    });*/

  }
}

// main 인기 있는 리뷰 설정
class MainPopularReview{
  constructor(documentParams){
    this.rv_tab = document.querySelector(documentParams['tab']);
    this.template = document.querySelector(documentParams['template']).innerHTML;
    this.rv_content = document.querySelector(documentParams['content']);
    this.selected = documentParams['selected'];
    this.check_key = documentParams['check_key'];

    this.init();
  }

  init(){
    this.tabClickEvent(this.selected, this.check_key);
    document.getElementsByClassName(this.selected)[0].click();
  }

  tabClickEvent(selectedClassName, key){
    this.rv_tab.addEventListener('click', function(e){
      const selectedTab = document.getElementsByClassName(selectedClassName)[0];

      selectedTab.classList.remove(selectedClassName);
      e.target.classList.add(selectedClassName);

      const changeSelectedTab = document.getElementsByClassName(selectedClassName)[0];

      if(changeSelectedTab.getAttribute('class') == key){
        console.log('데이터 불러오기 ....');
        this.getReviewData();
      } else{
        e.target.classList.remove(selectedClassName);
        selectedTab.classList.add(selectedClassName);
      }

    }.bind(this));
  }

  getReviewData(){
    const firebase = new ReportFirebase();
    firebase.call(null, this);
  }

  setReviewData(data){
    const value = [];
    for(const x in data){
      value.push(data[x]);
    }

    console.log(value);
    const offerData = {
      review: value
    };
    const template = Handlebars.compile(this.template);
    this.rv_content.innerHTML = template(offerData);
  }
}
