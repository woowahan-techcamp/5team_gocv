//
//  DataManager.swift
//  pyunrihae
//
//  Created by woowabrothers on 2017. 8. 3..
//  Copyright © 2017년 busride. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class DataManager{
    
    // 기본 데이터 레퍼런스
    static var ref : DatabaseReference! = Database.database().reference()
    
    
    // id 순서 이벤트 리스트 리턴
    static func getEventInfoOrdeyById() -> [Event]{
        
        var eventList : [Event] = []
        
        ref.child("event").observe(DataEventType.value, with: { (snapshot) in
            
            var event : Event
            for childSnapshot in snapshot.children {
                event = Event.init(snapshot: childSnapshot as! DataSnapshot)
                // ID 하위에 있는 snapshot으로 event 초기화
                let snap = childSnapshot as? DataSnapshot
                event.id = snap?.key ?? ""
                //
                eventList.append(event)
            }
        })
        
        return eventList
    }
    
    // 원하는 편의점 별 이벤트 리스트 리턴
    static func getEventInfoByBrand(store_name: String) -> [Event]{
        
        var eventList : [Event] = []
        
        let localRef = ref.child("event")
        let query  = localRef.queryOrdered(byChild: "brand").queryEqual(toValue: store_name)
        query.observe(DataEventType.value, with: { (snapshot) in
            var event : Event
            for childSnapshot in snapshot.children {
                event = Event.init(snapshot: childSnapshot as! DataSnapshot)
                // ID 하위에 있는 snapshot으로 event 초기화
                let snap = childSnapshot as? DataSnapshot
                event.id = snap?.key ?? ""
                //
                eventList.append(event)
            }

        })
        return eventList
    }
    
    // 브랜드에 따라 리뷰 가져오고, 그걸 유용순으로 정리하기.
    static func getTop3ReviewByBrand(brand : String) -> [Review] {
        var reviewList : [Review]  = []
        
        let localRef = ref.child("review")
        let query = localRef.queryOrdered(byChild: "brand").queryEqual(toValue: brand)
        
        query.observe(DataEventType.value, with: { (snapshot) in
            
            for childSnapshot in snapshot.children {
                let review = Review.init(snapshot: childSnapshot as! DataSnapshot)
                reviewList.append(review)
            }
        })
        
        reviewList.sorted(by: { $0.useful > $1.useful })
        // 유용순으로 정렬하기
        return reviewList
    }
    
    // 카테고리로 받아와서 클라이언트에서 brand로 filter해주기 , 그리고 점수로 뿌려주기.
    static func getTop3ProductBy(brand : String, category : String) -> [Product] {
        var productList : [Product] = []
        
        let localRef = ref.child("product")
        var query = localRef.queryOrdered(byChild: "category").queryEqual(toValue: category)
        
        query.observe(DataEventType.value, with: { (snapshot) in
            
            for childSnapshot in snapshot.children {
                let product = Product.init(snapshot: childSnapshot as! DataSnapshot)
                if product.brand == brand {
                    productList.append(product)
                }
            }
        })
        
        productList.sorted(by: { $0.grade_avg > $1.grade_avg})
        // 가져온 상품를 크기 순으로 뿌려준다.
        return productList
    }
}
