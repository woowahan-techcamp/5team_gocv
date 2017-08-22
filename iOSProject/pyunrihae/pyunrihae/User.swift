//
//  User.swift
//  pyunrihae
//
//  Created by woowabrothers on 2017. 8. 17..
//  Copyright © 2017년 busride. All rights reserved.
//

import Foundation
import FirebaseDatabase

class User {
    var id : String // FirebaseAuth의 UID
    var email : String // 이메일
    var nickname : String // 닉네임
//    var password : String  비밀번호는 저장할 수 없음.
    var user_profile : String // 유저 프로필 사진 url
    var review_like_list : [String : Int]  // 유용해요 / 별로에요 누른 리뷰id : 숫자 (+1는 유용해요, -1는 별로에요)
    var product_review_list : [String] // 리뷰를 쓴 상품id 리스트
    var wish_product_list : [String] // 즐겨찾기한 상품id 리스트
    
    
    init(){
        id = ""
        email = ""
        nickname = ""
        user_profile = "http://item.kakaocdn.net/dw/4407092.title.png"
        review_like_list  = [:]
        product_review_list = []
        wish_product_list = []
    }
    
    init(id : String,email: String, nickname: String, user_profile : String, review_like_list : [String:Int], product_review_list : [String], wish_product_list : [String]){
        self.id = id
        self.email = email
        self.nickname = nickname
        self.user_profile = user_profile
        self.review_like_list = review_like_list
        self.product_review_list = product_review_list
        self.wish_product_list = wish_product_list
    }
    
    convenience init(id :String, email: String, nickname: String){
        self.init(id: id,email: email,nickname : nickname, user_profile : "http://item.kakaocdn.net/dw/4407092.title.png",review_like_list: [:], product_review_list: [], wish_product_list :[])
    }
    
    convenience init(snapshot : DataSnapshot){
        let dict = snapshot.value as? [String : Any] ?? [:]
        let id = dict["id"] as? String ?? ""
        let email = dict["email"] as? String ?? ""
        let nickname = dict["nickname"] as? String ?? ""
        let user_profile = dict["user_profile"] as? String ?? "http://item.kakaocdn.net/dw/4407092.title.png"
        let review_like_list = dict["review_like_list"] as? [String : Int] ?? [:]
        let product_review_list = dict["product_review_list"] as? [String] ?? []
        let wish_product_list = dict["wish_product_list"] as? [String] ?? []
        
        self.init(id: id,email: email,nickname : nickname, user_profile : user_profile, review_like_list: review_like_list, product_review_list: product_review_list, wish_product_list : wish_product_list)
    }

}
