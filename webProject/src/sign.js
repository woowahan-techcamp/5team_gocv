class SignUp {
    constructor(nic, email, pw1, pw2, pwCheck) {
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

            // console.log(error);

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
                console.log(error);
                document.querySelector('#loading').style.display = "none";

            }).then(function () {
                const user = firebase.auth().currentUser;

                database.ref('user/' + user.uid).set({
                    "email": this.email.value,
                    "id": user.uid,
                    "nickname": this.nic.value,
                    "user_profile": "https://avatars3.githubusercontent.com/u/22839752?v=4&s=460"
                }).then(function () {


                    //한번 다시 user db 캐시 업데이트
                    firebase.database().ref('user/').once('value').then(function (snapshot) {

                        document.querySelector('#loading').style.display = "none";

                        localStorage['user'] = JSON.stringify(snapshot.val());

                        const userStorage = localStorage['user'];
                        const userData = JSON.parse(userStorage);
                        const user = firebase.auth().currentUser;

                        //프로필 탭 설정
                        document.querySelector(".fixTab-profile-wrapper").style.display = "block"
                        document.querySelector("#fixTabProfileImg").setAttribute("src", userData[user.uid].user_profile);
                        document.querySelector(".fixTab-profile-id").innerHTML =
                            userData[user.uid].nickname + "<ul class=\"fixTab-profile-dropdown\">\n" +
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

                        document.querySelector('.fixTab-profile-element').addEventListener("click",function (){
                            const myPage = new MyPage(user.uid);

                        });
                    });


                });


                document.querySelector('#signupDetail').style.display = "none";



            }.bind(that));
        }.bind(this));
    }


}

class SignIn {

    constructor() {
        this.email = document.querySelector(".signin-id");
        this.password = document.querySelector(".signin-password");
        this.signInButton = document.querySelector(".signin-button");
        this.setEventButton();
    }

    setEventButton() {
        this.email.addEventListener("click", function () {
            document.querySelector("#signinErrorCheck").style.display = "none";
        })

        this.password.addEventListener("click", function () {
            document.querySelector("#signinErrorCheck").style.display = "none";
        })

        this.signInButton.addEventListener("click", function () {
            this.checkEmail();
            document.querySelector('#loading').style.display = "block";
        }.bind(this));
    }

    checkEmail() {
        firebase.auth().signInWithEmailAndPassword(this.email.value,
            this.password.value).catch(function (error) {
            console.log(error)
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


            document.querySelector('#loading').style.display = "none";

            const userStorage = localStorage['user'];
            const userData = JSON.parse(userStorage);
            const user = firebase.auth().currentUser;

            //프로필 탭 설정
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
            })

            document.querySelector('#sign').style.display = "none";

            document.querySelector('.fixTab-profile-element').addEventListener("click",function (){
                const myPage = new MyPage(user.uid);

            });


        })
    }
}

class SignConnect {
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

class Util {

    ajax(func) {
        const oReq = new XMLHttpRequest();
        oReq.addEventListener('load', function (e) {
            const data = JSON.parse(oReq.responseText);
            func.setData(data);
        });

        oReq.open('GET', func.url);
        oReq.send();
    }

    template(data, template, section) {
        const context = data;
        const tmpl = Handlebars.compile(template);
        section.innerHTML = tmpl(context);
    }
}

class MyPage {
    constructor(userId) {
        this.userId = userId;
        this.setData();
        this.setUploadProfile()
    }

    setData() {
        const userStorage = localStorage['user'];
        const userData = JSON.parse(userStorage);
        const util = new Util();

        const productStorage = localStorage['product'];
        const productData = JSON.parse(productStorage);

        const template = document.querySelector("#myPage-template").innerHTML;
        const sec = document.querySelector("#myPage");
        util.template(userData[this.userId], template, sec);

        const wishReviewArr = [];

        userData[this.userId].wish_product_list.forEach(function (e) {
            wishReviewArr.push(productData[e]);
        });


        const template2 = document.querySelector("#myPage-review-template").innerHTML;
        const sec2 = document.querySelector("#myPageReviewNavi");
        util.template(wishReviewArr, template2, sec2);

        this.setDeleteButtonEvent()
    }

    setDeleteButtonEvent() {
        document.querySelector("#myPageReviewNavi").addEventListener("click", function (e) {
            const that = this;



            firebase.database().ref('user/').once('value').then(function (snapshot) {
                document.querySelector('#loading').style.display = "block";
                localStorage['user'] = JSON.stringify(snapshot.val());
                const userStorage = localStorage['user'];
                const userData = JSON.parse(userStorage);


                if (e.target.classList.contains("myPage-wish-element-delete")) {
                    e.target.parentElement.style.display = "none";
                    const id = e.target.getAttribute("name");
                    const newWishArr = [];

                    console.log(id)

                    userData[that.userId].wish_product_list.forEach(function (e) {
                        if (e !== id) {
                            newWishArr.push(e);
                        }
                    })

                    console.log(newWishArr)

                    firebase.database().ref('user/' + that.userId + "/wish_product_list").set(newWishArr).then(function () {
                        firebase.database().ref('user/')
                            .once('value').then(function (snapshot) {

                            localStorage['user'] = JSON.stringify(snapshot.val());
                            document.querySelector('#loading').style.display = "none";
                        });
                    });
                }
            }.bind(that));
        }.bind(this));

    }

    setUploadProfile(){
        const uploadProfile = new UpLoadImage("profileImageInput","profilePreview")
    }

}

//일단 중복해서 쓰기
class UpLoadImage {
    constructor(inputId, imgPreviewId) {
        this.inputId = inputId;
        this.imgPreviewId = imgPreviewId
        this.init();
    }

    init() {
        const inputBtn =  document.querySelector("#" + this.inputId);
        const previewBtn = document.querySelector("#" + this.imgPreviewId);

        inputBtn.style.display = "none"

        inputBtn.addEventListener("change", function () {
            this.previewFile();
        }.bind(this));

        previewBtn.addEventListener("click",function () {
            inputBtn.click();
        })

    }

    previewFile(){
        let preview = document.querySelector('#' + this.imgPreviewId);
        let file = document.querySelector('#' + this.inputId).files[0];
        let reader = new FileReader();

        reader.addEventListener("load", function () {
            preview.src = reader.result;

        }, false);

        if (!file) {
        } else {
            reader.readAsDataURL(file);
            console.log(file.type.split("/")[1])
        }


    }

}


const signUp = new SignUp();
const signIn = new SignIn();
const signConnect = new SignConnect();

