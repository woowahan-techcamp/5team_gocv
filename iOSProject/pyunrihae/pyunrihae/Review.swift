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
    var image : String // 사용자가 올린 리뷰 사진
    var user : String // 사용자 닉네임 
    var product_key : String // 리뷰가 달린 상품의 key 
    var timestamp : String // timestamp 
    var grade : Int // 리뷰어가 준 별점 (1~5)
    var price : Int // 가격에 대해서 리뷰어가 준 점수 (1~5)
    var flavor : Int // 맛에 대해서 리뷰어가 준 점수 (1~5)
    var quantity : Int // 양에 대해서 리뷰어가 준 점수 (1~5)
    var useful : Int // 이 리뷰가 유용하다고 평가한 사람 수 
    var bad : Int // 이 리뷰가 별로라고 평가한 사람 수 
    
    init() {
        self.id = ""
        self.image = ""
        self.user = ""
        self.product_key = ""
        self.timestamp  = ""
        self.grade = 0
        self.price = 0
        self.flavor = 0
        self.quantity = 0
        self.useful = 0
        self.bad = 0
    }
    
    
    init(id : String, image : String, user : String, product_key : String, timestamp : String, grade : Int, price : Int, flavor : Int, quantity : Int, useful : Int, bad :Int ){
        self.id = id
        self.image = image
        self.user = user
        self.product_key = product_key
        self.timestamp = timestamp
        self.grade = grade
        self.price = price
        self.flavor = flavor
        self.quantity = quantity
        self.useful = useful
        self.bad = bad
    }
    
    convenience init(snapshot : DataSnapshot){
        let dict = snapshot.value as? Dictionary<String,AnyObject> ?? [:]
        let id = dict["id"] as? String ?? ""
        let image = dict["image"] as? String ?? ""
        let user = dict["user"] as? String ?? ""
        let product_key = dict["product_key"] as? String ?? ""
        let timestamp = dict["timestamp"] as? String ?? ""
        let grade = dict["grade"] as? Int ?? 0
        let price = dict["price"] as? Int ?? 0
        let flavor = dict["flavor"] as? Int ?? 0
        let quantity = dict["quantity"] as? Int ?? 0
        let useful = dict["useful"] as? Int ?? 0
        let bad = dict["bad"] as? Int ?? 0
        self.init(id: id,image : image, user: user, product_key: product_key, timestamp : timestamp, grade: grade, price : price, flavor: flavor, quantity : quantity, useful: useful, bad : bad)
    }
}
