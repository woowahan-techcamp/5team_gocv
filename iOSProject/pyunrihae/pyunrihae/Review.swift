//
//  Review.swift
//  pyunrihae
//
//  Created by woowabrothers on 2017. 8. 8..
//  Copyright © 2017년 busride. All rights reserved.
//

import Foundation
import FirebaseDatabase


class Review {
    
    var id : String  // 리뷰 아이디
    var user : String // 사용자 닉네임
    var p_image : String // 사용자가 올린 리뷰 사진
    var p_price : Int // 리뷰한 상품 가격
    var p_id : String // 리뷰가 달린 상품의 key
    var p_name : String // 리뷰한 상품 이름
    var commmet : String // 리뷰 내용
    var timestamp : String // timestamp
    var brand : String // 리뷰한 상품의 브랜드
    var category : String // 리뷰한 상품의 카테고리
    var grade : Int // 리뷰어가 준 별점 (1~5)
    var price : Int // 가격에 대해서 리뷰어가 준 점수 (1~5)
    var flavor : Int // 맛에 대해서 리뷰어가 준 점수 (1~5)
    var quantity : Int // 양에 대해서 리뷰어가 준 점수 (1~5)
    var useful : Int // 이 리뷰가 유용하다고 평가한 사람 수
    var bad : Int // 이 리뷰가 별로라고 평가한 사람 수
    
    init() {
        self.id = ""
        self.p_image = ""
        self.user = ""
        self.p_id = ""
        self.p_price = 0
        self.timestamp  = ""
        self.brand = ""
        self.category = ""
        self.grade = 0
        self.price = 0
        self.flavor = 0
        self.quantity = 0
        self.useful = 0
        self.bad = 0
        self.p_name = ""
        self.commmet = ""
    }
    
    
    init(id : String, p_image : String, user : String, p_id : String, p_price : Int,timestamp : String, brand : String, category : String, grade : Int, price : Int, flavor : Int, quantity : Int, useful : Int, bad :Int , p_name : String, comment: String){
        self.id = id
        self.p_image = p_image
        self.user = user
        self.p_id = p_id
        self.p_price = p_price
        self.timestamp = timestamp
        self.brand = brand
        self.category = category
        self.grade = grade
        self.price = price
        self.flavor = flavor
        self.quantity = quantity
        self.useful = useful
        self.bad = bad
        self.p_name = p_name
        self.commmet = comment
    }
    
    convenience init(snapshot : DataSnapshot){
        let dict = snapshot.value as? Dictionary<String,AnyObject> ?? [:]
        let id = dict["id"] as? String ?? ""
        let p_image = dict["p_image"] as? String ?? ""
        let user = dict["user"] as? String ?? ""
        let p_id = dict["p_id"] as? String ?? ""
        let p_price = dict["p_price"] as? Int ?? 0
        let timestamp = dict["timestamp"] as? String ?? ""
        let brand = dict["brand"] as? String ?? ""
        let category = dict["category"] as? String ?? ""
        let grade = dict["grade"] as? Int ?? 0
        let price = dict["price"] as? Int ?? 0
        let flavor = dict["flavor"] as? Int ?? 0
        let quantity = dict["quantity"] as? Int ?? 0
        let useful = dict["useful"] as? Int ?? 0
        let bad = dict["bad"] as? Int ?? 0
        let p_name = dict["p_name"] as? String ?? ""
        let comment = dict["comment"] as? String ?? ""
        
        self.init(id: id,p_image : p_image, user: user, p_id: p_id, p_price: p_price, timestamp : timestamp, brand: brand, category: category, grade: grade, price : price, flavor: flavor, quantity : quantity, useful: useful, bad : bad, p_name: p_name, comment: comment)
    }
}
