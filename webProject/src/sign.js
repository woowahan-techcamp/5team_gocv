class SignUp{
    constructor(nic,email,pw1,pw2,pwCheck){
        this.nic=nic;
        this.email=email;
        this.pw1=pw1;
        this.pw2=pw2;
        this.pwCheck=pwCheck;
        this.check=false;
        this.init()
    }

    init(){
        this.nic=document.querySelector("#signupNic");
        this.email=document.querySelector("#signupEmail");
        this.pw1=document.querySelector("#signupPw1");
        this.pw2=document.querySelector("#signupPw2");
        this.pwCheck=document.querySelector("#signupPwCheck");
        this.pwCheck2=document.querySelector("#signupPwCheck2");
        this.emailCheck=document.querySelector("#signupEmailCheck");
        this.setChangeEvent();
        this.setEventUser();
    }

    setChangeEvent(){

        this.email.addEventListener("click",function(){
            document.querySelector("#signupEmailCheck2").style.display="none";
            this.emailCheck.style.display="none"
        }.bind(this));

        this.pw2.addEventListener("change",function(){
            if(this.pw1.value!==this.pw2.value){
                this.pwCheck.style.display="block"
                this.check=false;
            }else {
                this.pwCheck.style.display="none"
                this.check=true;
            }
        }.bind(this));

        this.pw1.addEventListener("change",function(){
            if(this.pw1.value!==this.pw2.value){
                this.pwCheck.style.display="block"
                this.check=false;
            }else {
                this.pwCheck.style.display="none"
                this.check=true;
            }

            if(parseInt(this.pw1.value.length)>=6){
                this.pwCheck2.style.display="none";
                this.check=true;
            }else{
                this.pwCheck2.style.display="block"
                this.check=false;
            }
        }.bind(this));
    }


    setEventUser(){
        document.querySelector("#signupButton").addEventListener("click",function () {
            if(this.check===true){
                this.setUser();
            }
        }.bind(this))
    }

    setUser(){
        const database = firebase.database();

        //auth 생성후 db에 넣어주기
        firebase.auth().createUserWithEmailAndPassword(this.email.value, this.pw1.value).catch(function(error) {

            // console.log(error);

            //이미 있는 유저 일 경우 처리
            if(error.code==="auth/email-already-in-use"){
                document.querySelector("#signupEmailCheck2").style.display="block";
            }

            //올바른 이메일 형식이 아닐 경우처리
           if(error.code==="auth/invalid-email"){
                this.emailCheck.style.display="block"
            }

            return Promise.reject();

        }.bind(this)).then(function(){

            const that=this;
            firebase.auth().signInWithEmailAndPassword(this.email.value, this.pw1.value).catch(function(error) {
                console.log(error);

            }).then(function(){
                const user = firebase.auth().currentUser;

                database.ref('user/'+user.uid).set({
                    "email" : this.email.value,
                    "id" : user.uid,
                    "nickname" : this.nic.value,
                    "user_profile" : "https://avatars3.githubusercontent.com/u/22839752?v=4&s=460"
                }).then(function(){


                    //한번 다시 user db 캐시 업데이트
                    firebase.database().ref('user/').once('value').then(function (snapshot) {

                        localStorage['user'] = JSON.stringify(snapshot.val());

                        const userStorage = localStorage['user'];
                        const userData = JSON.parse(userStorage);
                        const user = firebase.auth().currentUser;

                        //프로필 탭 설정
                        document.querySelector(".fixTab-profile-wrapper").style.display = "block"
                        document.querySelector("#fixTabProfileImg").setAttribute("src",userData[user.uid].user_profile);
                        document.querySelector(".fixTab-profile-id").innerHTML =
                            userData[user.uid].nickname+ "<ul class=\"fixTab-profile-dropdown\">\n" +
                            "                    <li class=\"fixTab-profile-element\">내 정보</li>\n" +
                            "                    <li id=\"logout\" class=\"fixTab-profile-element\">로그아웃</li>\n" +
                            "                </ul>";

                        document.querySelector("#logout").addEventListener("click",function(){
                            firebase.auth().signOut().then(function() {
                                document.querySelector(".fixTab-profile-wrapper").style.display = "none"
                                document.querySelector('#sign').style.display = "block";
                            }, function(error) {
                                // An error happened.
                            });
                        })
                    });


                });

                alert("가입이 완료되었습니다. 가입한 이메일로 자동로그인 됩니다.");

                document.querySelector('#signupDetail').style.display="none";



            }.bind(that));
        }.bind(this));
    }




}


class SignIn{

    constructor(){
        this.email = document.querySelector(".signin-id");
        this.password = document.querySelector(".signin-password");
        this.signInButton = document.querySelector(".signin-button");
        this.setEventButton();
    }

    setEventButton(){
        this.email.addEventListener("click",function(){
            document.querySelector("#signinErrorCheck").style.display = "none";
        })

        this.password.addEventListener("click",function(){
            document.querySelector("#signinErrorCheck").style.display = "none";
        })

        this.signInButton.addEventListener("click",function(){
            this.checkEmail();
        }.bind(this));
    }

    checkEmail(){
        firebase.auth().signInWithEmailAndPassword(this.email.value,
            this.password.value).catch(function(error) {
                console.log(error)
            if(error.code==="auth/user-not-found") {
                document.querySelector("#signinErrorCheck").innerHTML="존재하지 않는 이메일 입니다."
                document.querySelector("#signinErrorCheck").style.display = "block";
            }
            if(error.code==="auth/wrong-password") {
                document.querySelector("#signinErrorCheck").innerHTML="비밀번호가 일치하지 않습니다."
                document.querySelector("#signinErrorCheck").style.display = "block";
            }
            return Promise.reject();
        }).then(function() {
            alert("로그인 되었습니다.")

            const userStorage = localStorage['user'];
            const userData = JSON.parse(userStorage);

            const user = firebase.auth().currentUser;
            //프로필 탭 설정
            document.querySelector(".fixTab-profile-wrapper").style.display = "block"
            document.querySelector("#fixTabProfileImg").setAttribute("src",userData[user.uid].user_profile);
            document.querySelector(".fixTab-profile-id").innerHTML =
                userData[user.uid].nickname+ "<ul class=\"fixTab-profile-dropdown\">\n" +
                "                    <li class=\"fixTab-profile-element\">내 정보</li>\n" +
                "                    <li id=\"logout\" class=\"fixTab-profile-element\">로그아웃</li>\n" +
                "                </ul>";

            document.querySelector("#logout").addEventListener("click",function(){
                firebase.auth().signOut().then(function() {
                    document.querySelector(".fixTab-profile-wrapper").style.display = "none"
                    document.querySelector('#sign').style.display = "block";
                }, function(error) {
                    // An error happened.
                });
            })

            document.querySelector('#sign').style.display="none";
        })
    }
}



class SignConnect{
    constructor(){
        this.sign = document.querySelector('#sign');
        this.signup = document.querySelector('#signup');
        this.signupDetail = document.querySelector('#signupDetail');
        this.connect();
    }

    connect(){
        document.querySelector("#sign-signupButton").addEventListener("click",function(){
            this.sign.style.display="none";
            this.signup.style.display="block";
        }.bind(this));

        document.querySelector("#signup-singinButton").addEventListener("click",function(){
            this.signup.style.display="none";
            this.sign.style.display="block";
        }.bind(this));

        document.querySelector("#signup-singupButton").addEventListener("click",function(){
            this.signup.style.display="none";
            this.signupDetail.style.display="block";
        }.bind(this));

        document.querySelector("#signupDetail-signinButton").addEventListener("click",function(){
            this.signupDetail.style.display="none";
            this.sign.style.display="block";
        }.bind(this));
    }



}



const signUp = new SignUp();
const signIn = new SignIn();
const signConnect = new SignConnect();