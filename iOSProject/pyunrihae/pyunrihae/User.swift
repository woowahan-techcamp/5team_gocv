//
//  User.swift
//  pyunrihae
//
//  Created by woowabrothers on 2017. 8. 17..
//  Copyright © 2017년 busride. All rights reserved.
//

import Foundation


class User {
    var id : String // FirebaseAuth의 UID
    var email : String // 이메일
//    var password : String  비밀번호는 저장할 수 없음.
    var review_like_list : [String : Int]  // 유용해요 / 별로에요 누른 리뷰id : 숫자 (+1는 유용해요, -1는 별로에요)
    var product_like_list : [String] // 리뷰를 쓴 상품id 리스트
    var wish_product_list : [String] // 즐겨찾기한 상품id 리스트
    
    
    init(){
        id = ""
        email = ""
        review_like_list  = [:]
        product_like_list = []
        wish_product_list = []
    }
    
    init(id : String,email: String,review_like_list : [String:Int], product_like_list : [String], wish_product_list : [String]){
        self.id = id
        self.email = email
        self.review_like_list = review_like_list
        self.product_like_list = product_like_list
        self.wish_product_list = wish_product_list
    }
    
    convenience init(id :String, email: String){
        self.init(id: id,email: email, review_like_list: [:], product_like_list: [], wish_product_list :[])
    }
}
