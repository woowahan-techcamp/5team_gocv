//
//  Event.swift
//  pyunrihae
//
//  Created by woowabrothers on 2017. 8. 3..
//  Copyright © 2017년 busride. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Event {
    
    var id : String // 이벤트 id
    var name : String // 이벤트 명
    var startDate : String // "2017.7.11"
    var endDate : String // "2017.7.11"
    var brand : String // "CU" / "GS25" /"SevenEleven"
    var url : String // 각 편의점의 이벤트 상세 페이지 url
    var image : String // image url
    
    init(){
        id = ""
        name = ""
        startDate = ""
        endDate = ""
        brand = ""
        url = ""
        image = ""
    }
    
    
    init(id : String, name: String,  startDate : String, endDate : String, brand : String, url : String, image : String){
        self.id = id
        self.name = name
        self.startDate = startDate
        self.endDate = endDate
        self.brand = brand
        self.url = url
        self.image = image
    }
    
    
    convenience init(snapshot : DataSnapshot){
        let dict = snapshot.value as? Dictionary<String,AnyObject> ?? [:]
        self.init(id: "",name : dict["name"] as? String ?? "", startDate: dict["startDate"] as? String ?? "",endDate: dict["endDate"] as? String ?? "",
                  brand: dict["brand"] as? String ?? "", url:  dict["url"] as? String ?? "",
                  image: dict["image"] as? String ?? "")
    }
}
