document.addEventListener('DOMContentLoaded', function () {
    const reviewObj = {
      R0001: {
        p_id: 'PR0001',
        p_image: 'http://cfile4.uf.tistory.com/image/2377E534552D9D8D1EFC02',
        p_name: '백종원의 제육드빱',
        brand: 'CU',
        user_image: 'http://image.hankookilbo.com/i.aspx?Guid=4c1af8f0fe474f19adf35a6ea48b6a3b&Month=201512&size=640',
        user: '백종원',
        timestamp: '2017-08-21',
        grade: 3.7,
        useful: 1234,
        bad: 323,
        comment: '행복스럽고 산야 간에 그들은 약동하다. 찾아 기쁘며, 가는 노래하며 그들의 피고, 황금시대다. 이는 목숨이 충분히 풀이 황금시대를 같이, 자신과 역사를 힘있다. 관현악이며, 곳이 싸인 이것은 이상의 뭇 소담스러운 이상, 두기 부패뿐이다. 못할 끓는 인간의 있으랴? 고행을 열매를 만물은 청춘의 청춘을 하는 유소년에게서 그들의 우는 있는가? 싹이 자신과 무한한 이것을 때까지 돋고, 청춘 약동하다. 동산에는 보내는 수 대한 하는 하여도 것이다. 열락의 피에 실로 찾아다녀도, 속에서 것이다. 인간이 새 우는 칼이다.',
      },
      R0002: {
        p_id: 'PR0001',
        p_image: 'http://cfile4.uf.tistory.com/image/2377E534552D9D8D1EFC02',
        p_name: '백종원의 제육드빱이쥬',
        brand: 'gs25',
        user_image: 'http://image.hankookilbo.com/i.aspx?Guid=4c1af8f0fe474f19adf35a6ea48b6a3b&Month=201512&size=640',
        user: '박종원',
        timestamp: '2017-08-21',
        grade: 3.9,
        useful: 1234,
        bad: 3223,
        comment: '행복스럽고 산야에 간에 그들은 약동하다. 찾아 기쁘며, 는 노래하며 그들의 피고, 황금시대다. 이는 목숨이 충분히 풀이 황금시대를 같이, 자신과 역사를 힘있다. 관현악이며, 곳이 싸인 이것은 이상의 뭇 소담스러운 이상, 두기 부패뿐이다. 못할 끓는 인간의 있으랴? 고행을 열매를 만물은 청춘의 청춘을 하는 유소년에게서 그들의 우는 있는가? 싹이 자신과 무한한 이것을 때까지 돋고, 청춘 약동하다. 동산에는 보내는 수 대한 하는 하여도 것이다. 열락의 피에 실로 찾아다녀도, 속에서 것이다. 인간이 새 우는 칼이다.',
      },
      R0003: {
        p_id: 'PR0001',
        p_image: 'http://cfile4.uf.tistory.com/image/2377E534552D9D8D1EFC02',
        p_name: '백종원의 제육드드빱',
        brand: 'CU',
        user_image: 'http://image.hankookilbo.com/i.aspx?Guid=4c1af8f0fe474f19adf35a6ea48b6a3b&Month=201512&size=640',
        user: '김종원',
        timestamp: '2017-08-21',
        grade: 4.7,
        useful: 3334,
        bad: 323,
        comment: '행복스럽고 산야에 간에 그들은 약동하다. 찾아기쁘며, 가는 노래하며 그들의 피고, 황금시대다. 이는 목숨이 충분히 풀이 황금시대를 같이, 자신과 역사를 힘있다. 관현악이며, 곳이 싸인 이것은 이상의 뭇 소담스러운 이상, 두기 부패뿐이다. 못할 끓는 인간의 있으랴? 고행을 열매를 만물은 청춘의 청춘을 하는 유소년에게서 그들의 우는 있는가? 싹이 자신과 무한한 이것을 때까지 돋고, 청춘 약동하다. 동산에는 보내는 수 대한 하는 하여도 것이다. 열락의 피에 실로 찾아다녀도, 속에서 것이다. 인간이 새 우는 칼이다.',
      },
      R0004: {
        p_id: 'PR0001',
        p_image: 'http://cfile4.uf.tistory.com/image/2377E534552D9D8D1EFC02',
        p_name: '백종원의 제육드빱',
        brand: 'seven',
        user_image: 'http://image.hankookilbo.com/i.aspx?Guid=4c1af8f0fe474f19adf35a6ea48b6a3b&Month=201512&size=640',
        user: '홍진호',
        timestamp: '2017-08-21',
        grade: 2.2,
        useful: 2222,
        bad: 222,
        comment: '행복스럽고 산야에 간에 그들은 약동하다.가는 노래하며 그들의 피고, 황금시대다. 이는 목숨이 충분히 풀이 황금시대를 같이, 자신과 역사를 힘있다. 관현악이며, 곳이 싸인 이것은 이상의 뭇 소담스러운 이상, 두기 부패뿐이다. 못할 끓는 인간의 있으랴? 고행을 열매를 만물은 청춘의 청춘을 하는 유소년에게서 그들의 우는 있는가? 싹이 자신과 무한한 이것을 때까지 돋고, 청춘 약동하다. 동산에는 보내는 수 대한 하는 하여도 것이다. 열락의 피에 실로 찾아다녀도, 속에서 것이다. 인간이 새 우는 칼이다.',
      },
      R0005: {
        p_id: 'PR0001',
        p_image: 'http://cfile4.uf.tistory.com/image/2377E534552D9D8D1EFC02',
        p_name: '백종원의 제육드빱',
        brand: 'CU',
        user_image: 'http://image.hankookilbo.com/i.aspx?Guid=4c1af8f0fe474f19adf35a6ea48b6a3b&Month=201512&size=640',
        user: '파스칼',
        timestamp: '2017-08-21',
        grade: 4.9,
        useful: 232,
        bad: 332,
        comment: '행복스럽고 산야에 간에 그들은 찾아 기쁘며, 가는 노래하며 그들의 피고, 황금시대다. 이는 목숨이 충분히 풀이 황금시대를 같이, 자신과 역사를 힘있다. 관현악이며, 곳이 싸인 이것은 이상의 뭇 소담스러운 이상, 두기 부패뿐이다. 못할 끓는 인간의 있으랴? 고행을 열매를 만물은 청춘의 청춘을 하는 유소년에게서 그들의 우는 있는가? 싹이 자신과 무한한 이것을 때까지 돋고, 청춘 약동하다. 동산에는 보내는 수 대한 하는 하여도 것이다. 열락의 피에 실로 찾아다녀도, 속에서 것이다. 인간이 새 우는 칼이다.',
      },
    };

    const reviewParams = {
      template: '#card-review-page-template',
      content: '.review-item-list-wrapper'
    };

    /* @TODO 처리 순서 정하기
      1. 데이터 가져오기
      -2. 데이터 핸들바 적용
      -3. 추가적인 데이터 불러오기(랭킹 페이지 처럼)
      4. 정렬 가능하도록 하기(유용순, 날짜순 ...)
      5. 클릭시 상품 팝업
      6. 추가적인 디버깅
    */

    new ReviewPage(reviewParams, reviewObj);
});

class ReviewPage{
  constructor(reviewParams, reviewObj){
    this.template = document.querySelector(reviewParams.template).innerHTML;
    this.review_content = document.querySelector(reviewParams.content);

    this.maxiumWord = 240;
    this.reviewObj = reviewObj;
    this.arrayObj = this.getArrayObject();

    this.init();
  }

  init(){
    this.setDefaultReviewData();
    // this.reloadEvent();
  }

  setDefaultReviewData(){
    this.start = 0;
    this.end = 12;
    this.height = 800;

    const data = this.arrayObj;

    const resultValue = [];
    for(let i = this.start; i < this.end; i++){
      const key = Object.keys(data)[i];
      const value = data[key];

      if(!!value){
        if(value.comment.length > this.maxiumWord){
          value["comment"] = this.getCommentOptions(value.comment);
        }
        value["brand_image"] = this.getBrandImage(value.brand);
        value["rating"] = "card-rank-rating" + i;
        resultValue.push(value);
      }
    }

    const template = Handlebars.compile(this.template);
    this.review_content.innerHTML = template(resultValue);
    this.setRatingHandler(resultValue);
  }

  getArrayObject(){
    const queryObj = [];

    for(const key in this.reviewObj){
      queryObj.push(this.reviewObj[key]);
    }

    return queryObj;
  }

  getCommentOptions(value, length){
    let result = '';
    const str = value.split('');

    for(let i = 0; i < this.maxiumWord; i++){
      result += str[i];
    }
    return result + '...';
  }

  getBrandImage(value){
    switch (value) {
      case 'gs25':
      case 'GS25':
        return '../image/gs25.jpg';
      case 'cu':
      case 'CU':
        return '../image/cu.jpg';
      case 'seven':
      case '7ELEVEN':
        return '../image/seven.png';
      default:
        return null;
    }
  }

  reloadEvent(){
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
