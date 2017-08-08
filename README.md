
# 5조 프로젝트 : 편리해(편의점 리뷰해)


## Ground Rule

1. 아침에 출근하고 전날했던거 리뷰, 이슈 공유
* 한 가지 이상 의견 제시하기
* 서로의 이야기 경청하기
* 회의 내용 기록하기(깃허브 위키에 기록한다. 서기는 매일 돌아가며 한다.)
2. 회의시간(30분 ~ 1시간)
* 시간은 9시에서 10시 사이로 정한다.
* 구현했던 것에 대한 리뷰
* 풀리퀘스트한 것 Merge
* 오늘의 할일에 대한 논의
* 추가 기능에 대한 논의
* 개발하면서 생기는 문제점과, 구현할 때 어려운 부분을 논의.
3. 의사결정은 다수결의원칙으로 정한다.
* 다만 2:2로 나뉠경우 강현구 멘토님에게 여쭤본다.
* 결정이 안날 경우 설문조사를 실시한다.
* 결정이 안날 경우 사다리 타기를 진행한다.
4. Git 사용법
* Commit 메시지는 “170802 - 변경 및 추가사항” 한글로 쓸 것
* Commit은 의미있는 하나의 기능 단위로 한다.
* 매일 아침에 각각의 branch 가 기능적으로 완료 됬을 경우, 원격저장소로 branch를 push한 뒤에, master에 pull request를 보낸다. 이후 각 트랙별로 코드리뷰를 통해 master와 merge를 한다
* master branch는 항상 동작 가능한 상태로 둘 것 
* 한 주마다 데모시, 혹은 큰 기능이 완료 되었다고 판단했을 경우 TAG를 부여한다.
* TAG Name은   V.0.주차.1  / V.1.0.0 - 마지막 최종 릴리즈
5. 기타
* 백로그에 따라서 이슈를 만들어 일을 관리한다.
* 할 일 / 하는 중인 일 / 다한 일을 프로젝트에서 나누어서 관리한다.
* 일을 하는 중 / 한 후에는 프로젝트에 가서 분류를 옮긴다. 다한 일은 issue close.
* 결정이 안날 경우 사다리 타기를 진행한다.
* 개발 관련 이야기는 슬랙에서 나누는게 좋을 거 같고, 확인하면 댓글이나 확인했다고 말해주기.
----------------------------
## 데이터 가져오는 방법
> 크롤링으로 각 3사(GS25, CU, 7Eleven)에서 가져오며, 해당 데이터를 JSON화 하여 Firebase RealtimeDatabase에 저장한다.
> 각각 iOS와 Web에서 Firebase를 import하고, 화면마다 적절한 쿼리를 적용하여 필요한 부분만 가져온다.
----------------------------
## 코딩스타일
### 웹
* 한줄처리 하지 말것(가독성)
* 프레임워크는 Pure Javascript로 한다.(추후에 Vue.js 가능성이 있다.)
* CSS는 top-fixTab-wrapper와 같이 선언하며, [위치-큰기능-세부기능]과 같이 구현한다.(우리만의 룰 정리가 더 필요하다)
* JS에서는 클래스는 대문자, 함수는 소문자로 사용하며 동사+명사로 사용한다.
* 변수는 소문자로 시작하며 중간 구분을 대문자로 한다(ex. httpRequest)
* Template은 Handlebar.js 를 사용한다.
* Template 형식은 HTML 내부에 작성하여 보관한다.
* 페이지이름은 서로 의논하에 정한다.
* 변수 선언은 const/let만 사용한다.
* Event를 사용할 때 초기에 event.preventDefault()를 선언해준다.
* HTML DOM에서 ID값 사용을 최소화한다. - QuerySelector를 사용하자!
* TAB/NAV부분은 EventDelegation 방식을 사용한다.
* Webpack을 이용하여 모든 브라우저 호환되게끔
* UnitTest는 데이터 Request/Response 때만 사용한다.
* 주석은 한줄 단위가 아니라 문장으로 묶는다. (ex )
* 서로 다른 페이지를 개발한다.(ex 통일 : index, 세훈 : item)
* 총 코드리뷰는 17시~18시 사이에 한다.
* Airbnb의 JS 스타일을 준수한다.
* [function의 형식은 자유롭게 한다. ex (x) => ... or function(x){ ... }]
> function의 형식은 function(params){ ... } 로 고정한다.
----------------------------

### iOS
* 변수 / 함수 소문자 카멜케이스하고 클래스는 대문자 카멜케이스 로 작성한다.
* 함수명에 동사가 들어가고 파라미터에 목적어 / 보어가 들어가도록 함수명을 작성한다.
* 라벨 / 버튼 / 텍스트 / 이미지 / 이미지 뷰의 변수명인 경우 각각  label / btn / text / image / imageView로 단다.
* 코멘트는 한글로 한다.
* 함수 / 기능 / 모델별 코멘트를 단다.
* Notification 쓸 때는 받는 쪽 / 보내는 쪽 둘다 명시해서 코멘트를 단다.
* 기기 아이폰 7 을 기준으로 한다.
* indent는 tab으로 한다.
* 상대방 파일 건드릴 일있으면 짝코딩을 한다.
* 뷰 컨트롤러 단위로 작업한다.
* 통신하는 모델은 하나에 몰아서 쓴다
* 통신 시 받아오는 데이터를 무조건 클래스로 만들어서 관리한다.
* 중요한 string은 plist로 관리한다.
=======


## 데이터 모델링
### Use to Firebase

### Overview
> 편리해 프로젝트를 사용할 때 필요한 데이터 정리

#### 1. 상품(item)
key | type | example| description
----|--------|------|-----|
id| string | PR0001 | 상품의 고유번호
img| string | URL | 상품의 이미지 URL
name | string | 백종원의 제육덮밥 | 상품의 이름
price | int | 3900 | 상품의 가격
brand | String | "CU","all" | 해당 상품의 브랜드
event | array | ["1+1", "2+1"] | 해당 상품의 이벤트 목록
allergy | array | ["당근", "토마토"] | 알레르기에 정보 목록
category | string | 즉석식품 | 상품의 카테고리(분류) 
grade_avg | float | 4.5 | 가중치 공식에 맞게 평점을 낸 것 
grade_total | int | 90 | 상품의 총 평점(모든 평점의 합)
grade_count | int | 20 | 해당 상품을 평가한 사람 수
price_level | object | {p1:10, p2:20, p3:15} | 가격의 수치를 표현한것(p1:저렴, p2:중간, p3:비쌈)
flavor_level | object | {f1:10, f2:20, f3:15} | 맛의 수치를 표현한 것(f1:극혐, f2:중간, f3:존맛)
quantity_level | object | {q1:10, q2:20, q3:15} | 양의 수치를 표현한 것(q1:창렬, q2:적당, q3:넘많)
review_count | int | 100 | 해당 상품의 리뷰 개수
reviewList | array | ["R0001, R0002"] | 해당 상품의 리뷰 

* [가중치 공식 관련 홈페이지](http://www.beerforum.co.kr/index.php?document_srl=96427&mid=article_beer)
* 상품분류 8가지 : 도시락 / 김밥 / 베이커리 / 라면 / 스낵 / 유제품 / 음료 / 즉석식품

#### 2. 사용자(user)
key | type | example| description
----|--------|------|-----|
id| string | ~@mail.com | 사용자의 고유 아이디
pwd | string | sha255 | 사용자의 패스워드
nickname | string | jude | 사용자의 별명
review_like_list | object | {R0001:+1, R0002:-1,R0006:+1} | 본인이 리뷰에 좋아요 누른 리스트
product_review_list | array | [PR0001, PR0002] | 본인이 상품에 리뷰를 작성한 리스트
wish_product_list | array | [PR0001, PR0002] | 본인이 상품을 즐겨찾기에 추가한 리스트

#### 3. 리뷰(review)
key |	type |	example |	description
----|------|----------|------------
id	| string	| R0001 | 리뷰 고유번호
image | string | url | 사용자가 올린 사진
user | string | jude | 유저의 닉네임
product_key | string | PR0001 | 어떤상품에 리뷰를 달았는지 알려주는 key
brand | string | CU | 리뷰 단 상품의 브랜드 
timestamp | timestamp | 2017-08-01 | 해당 리뷰를 남긴 날짜
grade | int | 4 | 해당 상품의 별점(총점)
price | int | 2 | 1~5 점수
flavor | int | 3 | 1~5 점수
quantity | int | 2 | 1~5 점수
useful | int | 23 | 리뷰에 대해서 유용하다고 평가한 사람들의 수
bad | int | 12 | 리뷰에 대해서 별로라고 평가한 사람들의 수






------------
* 레시피, 이벤트 나중에 먼훗날에..

#### 0. 레시피(recipe)
key | type | example| description
----|--------|------|-----|
id| string | RE0001 | 레시피의 고유번호
name | string | 짜파구리 | 레시피의 이름
like | int | 140 | 해당 레시피의 좋아요 수
price | int | 3400 | 해당 레시피를 만드는데 필요한 금액
date | timestamp | 2017-08-02 | 해당 레시피를 작성한 날짜
description | string | 첫번째로 ... | 레시피를 만드는 방법에 대한 것
image | string | URL | 레시피 이미지 URL
ingredient | array | [PR001, PR002] | 해당 레시피를 사용하는데 필요한 상품의 리스트
user_id | string | ~@mail.com | 레시피를 작성한 사람의 아이디

#### 0. 이벤트(event)
key | type | example| description
----|--------|------|-----|
id| string | EV0001 | 이벤트의 고유번호
name | string | 완쁠라스 완 | 이벤트 이름
brand | string | CU | 이벤트를 주최하는 브랜드
url | string | LINK URL | 해당 이벤트 링크
image | string | IMAGE URL | 해당 이벤트 이미지 링크
startDate | timestamp | 2017-08-02 | 이벤트가 시작된 날짜
endDate | timestamp | 2017-08-30 | 이벤트가 종료된 날짜



## 기획서 링크 
* [편리해 기획서 초안 링크](https://docs.google.com/document/d/1jVmS0zjNG-4lkVaPkqFE1c6sU9i3j-eR2COsos0fbHE/edit)
* [편리해 기획서](https://drive.google.com/open?id=0By1KuX15XRMnVHF5MEZZcDRkVDg)

## 스토리보드
* [Web 스토리보드](https://goo.gl/a3wq7j)
* [ios 스토리보드](https://projects.invisionapp.com/share/MKCWW0NH5#/screens/247362313)


## 백로그
* [앱 백로그 스프레드 시트 링크](https://docs.google.com/spreadsheets/d/1VxQ7uHRMojI4kAINT8IKsNo_10K-AX_7Z-9kQjrHyrM/edit?usp=sharing)
* [웹 백로그 스프레드 시트 링크](https://docs.google.com/a/woowahan.com/spreadsheets/d/1fkCNpmwckjDcSs0wb7FZsA7qmkSLn5rjkvw7VBgXzYU/edit?usp=sharing)

## 기획

> 서비스 개요
- 편의점 음식에 대한 정보(총점, 가격, 양, 알레르기 성분 등)의 - 다방면 평가 리뷰를 통해 소비자의 선택을 도움
- 편의점 이벤트 정보 공유

> 기획 의도
- 점점 편의점 이용고객이 많아짐에 따라서 편의점 즉석음식의 수요가 높아지는 중
- 또한 수요가 높아짐에 따라서 각 프랜차이즈 편의점에서는 다양한 도시락을 제공하고 있음
- 위의 두가지를 통해 즉석음식에 대해서 이용고객들이 어떤 상품(맛, 리뷰, 알레르기 등)인지 알아 볼 수 있게 하기 위해 프로젝트 기획

> 타겟 고객
- 편의점을 주로 이용하는 사람
- 20, 30대 직장인/대학생

> 개발 기획

 # TODO : 나머지는 각자 더 생각해봐요
 
#### 1. 편의점 음식에 대한 정보를 랭크쿼리에 따라서 보여준다
 - Q1 : 랭크쿼리 어떻게 할꺼야?
 - A1 : default rank query는 ratebeer의 계산 방식을 따를 예정
 - Q2 : 다른 분류 방법은 어떻게 할꺼야?
 - A2 : 낮은 가격순, 리뷰가 많은 순, 높은 평점순(Q1), 그리고 각 카테고리별로 분류 (기회가 된다면 가장 최근에 리뷰가 달린 음식, 유용한 정보가 많은 음식 등.. 더 구체화 할 방법은 많음)
 
#### 2. 음식들의 상세 정보를 볼 수 있다.
 - Q1 : 음식 정보에는 뭐가 있음?
 - A1 : 음식정보에는 가격, 이름, 종류(카테고리), 브란도, 리뷰 개수, 알레르기 성분등을 가지고 있다.
 - Q2 : 상세정보의 리뷰는 어떻게 보여줄꺼야?
 - A2 : 리뷰에도 평가를 할 수 있게 하여 Useful, Good, bad 정도로 구분하여 아무래도 useful이 높은게 가장 연관성이 높을테니 이거위주로 보여줄 예정
 - Q3 : 리뷰평가주작은?
 - A3 : 주작못하게 해당 리뷰ID에 1번 평가하면 못하게 할거
 - Q4 : 리뷰 다른거 보고싶으면 어케함
 - A4 : 다양한?(최신순, 높은 평점순, useful, good, bad..) 등의 쿼리문으로 리뷰종류를 여러개 볼 수 있게 끔한다.
 - Q5 : 리뷰평가는 어떻게해
 - A5 : 알고리즘은 ratebeer꺼 따라할 거같긴한데.. 조금 구체화해야할듯

#### 3. 다양한 음식에 다양한 리뷰가 있다.
 - Q1 : 리뷰 많아서 머함
 - A1 : 추가적으로 구현할 수 있다면.. 랭크같은거 넣어서 ㅎㅎ재밌게 해보는것도 좋을듯(20~30대가 타겟층이니 티어가 뭔지 가장 잘알 사람들이잖, 모르면 사람아님)
 - Q2 : 상품은 또 뭐있음?
 - A2 : 랭크쿼리알고리즘(1번질문) 그거 점수가 가장 높으면 쿠팡과 같이 테두리 둘러주는것도 좋을거같음
