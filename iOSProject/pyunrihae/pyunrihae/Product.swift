//
//  Product.swift
//  pyunrihae
//
//  Created by woowabrothers on 2017. 8. 8..
//  Copyright © 2017년 busride. All rights reserved.
//
import Foundation
import FirebaseDatabase
class Product {
    var id : String // 상품의 고유번호 
    var image : String // 상품의 이미지 URL
    var name : String // 상품 이름 
    var price : String // 상품의 가격
    var brand : String // 해당 상품의 브랜드. 3사 전부인 경우 all. 나머지는 "CU" "GS25" 등
    var event : String // 해당 상품의 첫 이벤트
    var allergy : [String] // 알레르기 정보 목록
    var category : String // 카테고리(중분류)
    var grade_avg : Float // 가중치 공식에 따라 낸 평점 
    var grade_total : Int // 상품의 총 평점(모든 사람 합)
    var grade_count : Int // 이 상품을 평가한 사람 수 
    var price_level : [String : Int] // 가격의 수치를 표현한 것 
    var flavor_level : [String : Int] // 맛의 수치를 표현한 것
    var quantity_level : [String : Int] // 양의 수치를 표현한 것 
    var review_count : Int // 리뷰 갯수 
    var reviewList : [String] // 가지고 있는 리뷰 아이디의 리스트
    var capacity : String
    var manufacturer : String
    init(){
        self.id = ""
        self.image = ""
        self.name = ""
        self.price = ""
        self.brand = ""
        self.event = ""
        self.allergy = []
        self.category = ""
        self.grade_avg  = 0.0
        self.grade_total = 0
        self.grade_count = 0
        self.price_level = [:]
        self.flavor_level = [:]
        self.quantity_level = [:]
        self.review_count = 0
        self.reviewList = []
        self.capacity = ""
        self.manufacturer = ""
    }
    init(id : String, image : String, name : String, price : String, brand: String, event: String, allergy : [String] , category: String, grade_avg: Float, grade_total: Int, grade_count: Int, price_level: [String: Int] , flavor_level : [String : Int], quantity_level : [String: Int], review_count : Int, reviewList : [String], capacity : String, manufacturer : String ) {
        self.id = id
        self.image = image
        self.name = name
        self.price = price
        self.brand = brand
        self.event = event
        if event.contains("행사") {
            self.event = (self.event as NSString).replacingOccurrences(of: "행사", with: "")
        }
        self.allergy = allergy
        self.category = category
        self.grade_avg  = grade_avg
        self.grade_total = grade_total
        self.grade_count = grade_count
        self.price_level = price_level
        self.flavor_level = flavor_level
        self.quantity_level = quantity_level
        self.review_count = review_count
        self.reviewList = reviewList
        self.capacity = capacity
        self.manufacturer = manufacturer
    }
    convenience init(snapshot : DataSnapshot){
        let dict = snapshot.value as? [String : Any] ?? [:]
        let id = dict["id"] as? String ?? ""
        let image = dict["img"] as? String ?? ""
        let name = dict["name"] as? String ?? ""
        let price = dict["price"] as? String ?? ""
        let brand = dict["brand"] as? String ?? ""
        let event = dict["event"] as? String ?? ""
        let allergy = dict["allergy"] as? [String] ?? []
        let category = dict["category"] as? String ?? ""
        let grade_avg = dict["grade_avg"] as? Float ?? 0.0
        let grade_total = dict["grade_total"] as? Int ?? 0
        let grade_count = dict["grade_count"] as? Int ?? 0
        let price_level = dict["price_level"] as? [String : Int] ?? [:]
        let flavor_level = dict["flavor_level"] as? [String : Int] ?? [:]
        let quantity_level = dict["quantity_level"] as? [String: Int] ?? [:]
        let review_count = dict["review_count"] as? Int ?? 0
        let reviewList = dict["reviewList"] as? [String] ?? []
        let capacity = dict["capacity"] as? String ?? ""
        let manufacturer = dict["manufacture"] as? String ?? ""
        self.init(id: id, image: image, name: name, price: price, brand: brand, event: event, allergy: allergy, category: category, grade_avg: grade_avg, grade_total: grade_total, grade_count: grade_count, price_level: price_level, flavor_level: flavor_level, quantity_level: quantity_level, review_count: review_count, reviewList: reviewList, capacity: capacity, manufacturer: manufacturer)
    }
}
