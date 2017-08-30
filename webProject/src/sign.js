import {Toast, Util} from './main.js'
import {UpLoadImage, ProductPopup} from './productDetail.js'
import {PopupInfo} from './manage'

export class SignUp {
    constructor(db, nic, email, pw1, pw2, pwCheck) {
        this.db = db;
        this.nic = nic;
        this.email = email;
        this.pw1 = pw1;
        this.pw2 = pw2;
        this.pwCheck = pwCheck;
        this.check = false;
        this.init()
    }

    init() {
        this.nic = document.querySelector("#signupNic");
        this.email = document.querySelector("#signupEmail");
        this.pw1 = document.querySelector("#signupPw1");
        this.pw2 = document.querySelector("#signupPw2");
        this.pwCheck = document.querySelector("#signupPwCheck");
        this.pwCheck2 = document.querySelector("#signupPwCheck2");
        this.emailCheck = document.querySelector("#signupEmailCheck");
        this.setChangeEvent();
        this.setEventUser();
    }

    setChangeEvent() {

        this.email.addEventListener("click", function () {
            document.querySelector("#signupEmailCheck2").style.display = "none";
            this.emailCheck.style.display = "none"
        }.bind(this));

        this.pw2.addEventListener("change", function () {
            if (this.pw1.value !== this.pw2.value) {
                this.pwCheck.style.display = "block"
                this.check = false;
            } else {
                this.pwCheck.style.display = "none"
                this.check = true;
            }
        }.bind(this));

        this.pw1.addEventListener("change", function () {
            if (this.pw1.value !== this.pw2.value) {
                this.pwCheck.style.display = "block"
                this.check = false;
            } else {
                this.pwCheck.style.display = "none"
                this.check = true;
            }

            if (parseInt(this.pw1.value.length) >= 6) {
                this.pwCheck2.style.display = "none";
                this.check = true;
            } else {
                this.pwCheck2.style.display = "block"
                this.check = false;
            }
        }.bind(this));
    }


    setEventUser() {
        document.querySelector("#signupButton").addEventListener("click", function () {
            if (this.check === true) {
                this.setUser();
                document.querySelector('#loading').style.display = "block";

            }
        }.bind(this))
    }

    setUser() {
        const database = firebase.database();

        //auth 생성후 db에 넣어주기
        firebase.auth().createUserWithEmailAndPassword(this.email.value, this.pw1.value).catch(function (error) {


            //이미 있는 유저 일 경우 처리
            if (error.code === "auth/email-already-in-use") {
                document.querySelector("#signupEmailCheck2").style.display = "block";
            }

            //올바른 이메일 형식이 아닐 경우처리
            if (error.code === "auth/invalid-email") {
                this.emailCheck.style.display = "block"
            }
            document.querySelector('#loading').style.display = "none";

            return Promise.reject();

        }.bind(this)).then(function () {

            const that = this;
            firebase.auth().signInWithEmailAndPassword(this.email.value, this.pw1.value).catch(function (error) {
                document.querySelector('#loading').style.display = "none";

            }).then(function () {
                const that2 = that;
                const user = firebase.auth().currentUser;

                database.ref('user/' + user.uid).set({
                    "email": this.email.value,
                    "id": user.uid,
                    "nickname": this.nic.value,
                    "user_profile": "http://item.kakaocdn.net/dw/4407092.title.png"
                }).then(function () {
                    that2.updateDb();

                }.bind(that2));

                document.querySelector('#signupDetail').style.display = "none";

            }.bind(that));
        }.bind(this));
    }

    updateDb() {
        //한번 다시 user db 캐시 업데이트
        firebase.database().ref('user/').once('value').then(function (snapshot) {

            const that = this;
            document.querySelector('#loading').style.display = "none";

            localStorage['user'] = JSON.stringify(snapshot.val());
            const userStorage = localStorage['user'];
            this.db.user = JSON.parse(userStorage);
            const user = firebase.auth().currentUser;

            //프로필 탭 설정
            document.querySelector(".fixTab-profile-wrapper").style.display = "block"
            document.querySelector("#fixTabProfileImg").setAttribute("src", this.db.user[user.uid].user_profile);
            document.querySelector(".fixTab-profile-id").innerHTML =
                this.db.user[user.uid].nickname + "<ul class=\"fixTab-profile-dropdown\">\n" +
                "                    <a href=\"#myPage\"><li class=\"fixTab-profile-element\">내 정보</li></a>\n" +
                "                    <li id=\"logout\" class=\"fixTab-profile-element\">로그아웃</li>\n" +
                "                </ul>";

            document.querySelector("#logout").addEventListener("click", function () {
                firebase.auth().signOut().then(function () {
                    document.querySelector(".fixTab-profile-wrapper").style.display = "none"
                    document.querySelector('#sign').style.display = "block";
                }, function (error) {
                    // An error happened.
                });
            })

            document.querySelector('.fixTab-profile-element').addEventListener("click", function () {
                const myPage = new MyPage(that.db);

            }.bind(that));
        }.bind(this));
    }


}

export class SignIn {

    constructor(db) {
        this.db = db;
        this.google = document.querySelector('.signin-google');
        this.facebook = document.querySelector('.signin-facebook');
        this.email = document.querySelector(".signin-id");
        this.password = document.querySelector(".signin-password");
        this.signInButton = document.querySelector(".signin-button");
        this.setEventButton();
    }

    setGoogleLogin() {
        var provider = new firebase.auth.GoogleAuthProvider();
        provider.addScope('https://www.googleapis.com/auth/contacts.readonly');

        firebase.auth().signInWithPopup(provider).then(function (result) {
            const that = this;
            // var token = result.credential.accessToken;
            var user = result.user;

            if (!!this.db.user[user.uid]) {
                this.login();
            } else {
                firebase.database().ref('user/' + user.uid).set({
                    "email": user.email,
                    "id": user.uid,
                    "nickname": user.displayName,
                    "user_profile": "http://item.kakaocdn.net/dw/4407092.title.png"
                }).then(function () {
                    const that2 = that;
                    firebase.database().ref('user/').once('value').then(function (snapshot) {
                        localStorage['user'] = JSON.stringify(snapshot.val());
                        that2.db.user = JSON.parse(localStorage['user']);
                        document.querySelector('#loading').style.display = "none"
                        that2.login();
                    }.bind(that2));
                }.bind(that));
            }
        }.bind(this))
    }


    setEventButton() {
        this.google.addEventListener('click', function () {
            this.setGoogleLogin()
        }.bind(this));


        this.email.addEventListener("click", function () {
            document.querySelector("#signinErrorCheck").style.display = "none";
        });

        this.password.addEventListener("click", function () {
            document.querySelector("#signinErrorCheck").style.display = "none";
        });


        firebase.auth().onAuthStateChanged(function (user) {
            if (user) {
                if (this.db.user[user.uid]) {
                    this.login();
                }
            } else {
                const that = this;
                this.signInButton.addEventListener("click", function () {
                    this.checkEmail();
                    document.querySelector('#loading').style.display = "block";
                }.bind(that));
            }
        }.bind(this));

    }

    checkEmail() {
        firebase.auth().signInWithEmailAndPassword(this.email.value,
            this.password.value).catch(function (error) {
            if (error.code === "auth/user-not-found") {
                document.querySelector("#signinErrorCheck").innerHTML = "존재하지 않는 이메일 입니다."
                document.querySelector("#signinErrorCheck").style.display = "block";

            }
            if (error.code === "auth/wrong-password") {
                document.querySelector("#signinErrorCheck").innerHTML = "비밀번호가 일치하지 않습니다."
                document.querySelector("#signinErrorCheck").style.display = "block";

            }

            document.querySelector('#loading').style.display = "none";

            return Promise.reject();
        }).then(function () {
            this.login();
        }.bind(this))

    }

    login() {
        document.querySelector('#sign').style.display = "none";
        document.querySelector('#loading').style.display = "none";

        const userData = this.db.user;
        const user = firebase.auth().currentUser;

        document.querySelector(".fixTab-profile-wrapper").style.display = "block"
        document.querySelector("#fixTabProfileImg").setAttribute("src", userData[user.uid].user_profile);
        document.querySelector(".fixTab-profile-id").innerHTML =
            userData[user.uid].nickname + "<ul class=\"fixTab-profile-dropdown\">\n" +
            "                     <a href=\"#myPage\"><li class=\"fixTab-profile-element\">내 정보</li></a>\n" +
            "                    <li id=\"logout\" class=\"fixTab-profile-element\">로그아웃</li>\n" +
            "                </ul>";

        document.querySelector("#logout").addEventListener("click", function () {
            firebase.auth().signOut().then(function () {
                document.querySelector(".fixTab-profile-wrapper").style.display = "none"
                document.querySelector('#sign').style.display = "block";
            }, function (error) {
                // An error happened.
            });
        });

        document.querySelector('#sign').style.display = "none";

        document.querySelector('.fixTab-profile-element').addEventListener("click", function () {
            const myPage = new MyPage(this.db);

        }.bind(this));
    }

}

export class SignConnect {
    constructor() {
        this.sign = document.querySelector('#sign');
        this.signup = document.querySelector('#signup');
        this.signupDetail = document.querySelector('#signupDetail');
        this.connect();
    }

    connect() {
        document.querySelector("#sign-signupButton").addEventListener("click", function () {
            this.sign.style.display = "none";
            this.signup.style.display = "block";
        }.bind(this));

        document.querySelector("#signup-singinButton").addEventListener("click", function () {
            this.signup.style.display = "none";
            this.sign.style.display = "block";
        }.bind(this));

        document.querySelector("#signup-singupButton").addEventListener("click", function () {
            this.signup.style.display = "none";
            this.signupDetail.style.display = "block";
        }.bind(this));

        document.querySelector("#signupDetail-signinButton").addEventListener("click", function () {
            this.signupDetail.style.display = "none";
            this.sign.style.display = "block";
        }.bind(this));
    }


}

class MyPage {
    constructor(db) {
        this.db = db;
        const user = firebase.auth().currentUser;
        this.userId = user.uid;

        this.popup = new PopupInfo();

        this.setData();
        this.setEventUpdateImage();
        this.setEventUpdateNicname();
    }

    setData() {
        const util = new Util();
        const that = this;

        const template = document.querySelector("#myPage-template").innerHTML;
        const sec = document.querySelector("#myPage");
        util.template(this.db.user[this.userId], template, sec);

        const myPageProduct = new ProductPopup(this.db, '#myPageReviewNavi', 'productSelect');

        const wishReviewArr = [];

        if (!!this.db.user[this.userId].wish_product_list) {
            this.db.user[this.userId].wish_product_list.forEach(function (e) {
                wishReviewArr.push(that.db.product[e]);
            }.bind(that));
        }

        const template2 = document.querySelector("#myPage-review-template").innerHTML;
        const sec2 = document.querySelector("#myPageReviewNavi");
        util.template(wishReviewArr, template2, sec2);

        this.setDeleteButtonEvent();

        this.popup.setMyPageInit();
    }

    setDeleteButtonEvent() {
        document.querySelector("#myPageReviewNavi").addEventListener("click", function (e) {
            const that = this;
            document.querySelector('#loading').style.display = "block";

            if (e.target.classList.contains("myPage-wish-element-delete")) {
                document.querySelector('#loading').style.display = "block";

                e.target.parentElement.style.display = "none";

                const id = e.target.getAttribute("name");
                const newWishArr = [];

                this.db.user[this.userId].wish_product_list.forEach(function (e) {
                    if (e !== id) {
                        newWishArr.push(e);
                    }
                });

                firebase.database().ref('user/' + that.userId + "/wish_product_list").set(newWishArr).then(function () {
                    that.db.updateUserDb();
                    new Toast("즐겨찾기에서 삭제되었습니다.");

                }.bind(that));
            }
        }.bind(this));
    }


    setEventUpdateImage() {
        const uploadProfile = new UpLoadImage("profileImageInput", "profilePreview");

        document.querySelector('#profileImageInput').addEventListener("change", function () {
            document.querySelector('#loading').style.display = "block";


            const that = this;

            let file = document.querySelector('#profileImageInput').files[0];

            this.fileName = 'user/' + this.userId + "." + file.type.split("/")[1]

            const storageRef = firebase.storage().ref();
            const mountainImagesRef = storageRef.child(this.fileName);

            mountainImagesRef.put(file).then(function () {
                that.updateDb();
                document.querySelector('#loading').style.display = "none";
                new Toast("이미지가 업로드 되었습니다.");
            }.bind(that));

        }.bind(this))
    }

    setEventUpdateNicname() {
        const changeBtn = document.querySelector(".myPage-profile-nickname");
        const input = document.querySelector(".myPage-profile-nickname-input");


        changeBtn.addEventListener("click", function () {


            if (input.value !== " " && input.value !== input.getAttribute("placeholder")) {
                const that = this;
                document.querySelector('#loading').style.display = "block";
                const changedName = input.value;
                input.setAttribute("value", changedName);

                firebase.database().ref('user/' + this.userId + '/nickname').set(changedName);
                firebase.database().ref('user/').once('value').then(function (snapshot) {
                    localStorage['user'] = JSON.stringify(snapshot.val());
                    that.db.user = JSON.parse(localStorage['user']);

                    that.setProfileTab();
                    document.querySelector('#loading').style.display = "none";
                    input.setAttribute("placeholder", input.value);
                    new Toast("닉네임이 변경되었습니다.");
                }.bind(that));
            } else if (input.value === "") {
                new Toast("닉네임을 입력해주세요.");

            } else if (input.value === input.getAttribute("placeholder")) {
                new Toast("중복된 닉네임입니다");

            }

            document.querySelector('#loading').style.display = "none";

        }.bind(this))

    }

    updateDb() {
        const storageRef = firebase.storage().ref();
        const database = firebase.database();

        storageRef.child(this.fileName).getDownloadURL().then(function (url) {
            const that = this;

            database.ref('user/' + this.userId + '/user_profile').set(url);

            firebase.database().ref('user/').once('value').then(function (snapshot) {
                localStorage['user'] = JSON.stringify(snapshot.val());
                that.db.user = JSON.parse(localStorage['user']);

                that.setProfileTab();
                document.querySelector('#loading').style.display = "none";
            }.bind(that));

        }.bind(this)).catch(function (error) {
            document.querySelector('#loading').style.display = "none"
        });
    }

    setProfileTab() {


        //프로필 탭 설정
        document.querySelector(".fixTab-profile-wrapper").style.display = "block"
        document.querySelector("#fixTabProfileImg").setAttribute("src", this.db.user[this.userId].user_profile);
        document.querySelector(".fixTab-profile-id").innerHTML =
            this.db.user[this.userId].nickname + "<ul class=\"fixTab-profile-dropdown\">\n" +
            "                     <a href=\"#myPage\"><li class=\"fixTab-profile-element\">내 정보</li></a>\n" +
            "                    <li id=\"logout\" class=\"fixTab-profile-element\">로그아웃</li>\n" +
            "                </ul>";
        document.querySelector("#logout").addEventListener("click", function () {
            firebase.auth().signOut().then(function () {
                document.querySelector(".fixTab-profile-wrapper").style.display = "none"
                document.querySelector('#sign').style.display = "block";
            }, function (error) {
                // An error happened.
            });
        });

        document.querySelector('.fixTab-profile-element').addEventListener("click", function () {
            const myPage = new MyPage(this.db);
        }.bind(this));



    }

}

