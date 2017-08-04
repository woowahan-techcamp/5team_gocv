
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
* CSS는 div-header-wrapper와 같이 선언하며, [tag이름-기능]과 같이 구현한다.(우리만의 룰 정리가 더 필요하다)
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
brand | array | ["CU", "GS"] | 해당 상품의 브랜드 리스트
recipeList | array | [RE0001, RE0002] | 해당 상품이 사용된 레시피의 목록
allergy | array | ["당근", "토마토"] | 알레르기에 정보 목록
category | string | 즉석식품 | 상품의 카테고리(대분류)
type | string | 도시락 | 상품의 종류(중분류)
grade_avg | float | 4.5 | 상품의 평점(별)
grade_total | int | 90 | 상품의 총 평점(모든 평점의 합)
grade_count | int | 20 | 해당 상품을 평가한 사람 수
price_level | object | {p1:10, p2:20, p3:15} | 가격의 수치를 표현한것(p1:저렴, p2:중간, p3:비쌈)
flavor_level | object | {f1:10, f2:20, f3:15} | 맛의 수치를 표현한 것(f1:극혐, f2:중간, f3:존맛)
quantity_level | object | {q1:10, q2:20, q3:15} | 양의 수치를 표현한 것(q1:창렬, q2:적당, q3:넘많)
review_count | int | 100 | 해당 상품의 리뷰 개수
reviewList | array | ["R0001, R0002"] | 해당 상품의 리뷰 

#### 2. 레시피(recipe)
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

#### 3. 이벤트(event)
key | type | example| description
----|--------|------|-----|
id| string | EV0001 | 이벤트의 고유번호
name | string | 완쁠라스 완 | 이벤트 이름
brand | string | CU | 이벤트를 주최하는 브랜드
url | string | LINK URL | 해당 이벤트 링크
image | string | IMAGE URL | 해당 이벤트 이미지 링크
startDate | timestamp | 2017-08-02 | 이벤트가 시작된 날짜
endDate | timestamp | 2017-08-30 | 이벤트가 종료된 날짜

#### 4. 사용자(user)
key | type | example| description
----|--------|------|-----|
id| string | ~@mail.com | 사용자의 고유 아이디
pwd | string | sha255 | 사용자의 패스워드
nickname | string | jude | 사용자의 별명
likeList | array | [RE0001, RE0002] | 레시피를 좋아요 누른 리스트
reviewList | array | [PR0001, PR0002] | 상품에 리뷰를 작성한 리스트
wish_product | array | [PR0001, PR0002] | 상품을 즐겨찾기에 추가한 리스트
wish_recipe| array | [RE0002] | 레시피에 좋아요 누른 리스트
my_recipe| array | [RE0003, RE0004] | 사용자가 쓴 레시피 리스트

#### 5. 리뷰(review)

key |	type |	example |	description
----|------|----------|------------
id	| string	| R0001 | 리뷰 고유번호
user | string | jude | 유저의 닉네임
product_key | string | PR0001 | 어떤상품에 리뷰를 달았는지 알려주는 key
timestamp | timestamp | 2017-08-01 | 해당 리뷰를 남긴 날짜
grade | float | 4 | 해당 상품의 별점



## 기획서 링크 
[편리해 기획서 초안 링크](https://docs.google.com/document/d/1jVmS0zjNG-4lkVaPkqFE1c6sU9i3j-eR2COsos0fbHE/edit)

## 앱 백로그
[백로그 스프레드 시트 링크](https://docs.google.com/spreadsheets/d/1VxQ7uHRMojI4kAINT8IKsNo_10K-AX_7Z-9kQjrHyrM/edit?usp=sharing)

## 웹 백로그
[백로그 스프레드 시트 링크](https://docs.google.com/a/woowahan.com/spreadsheets/d/1fkCNpmwckjDcSs0wb7FZsA7qmkSLn5rjkvw7VBgXzYU/edit?usp=sharing)
