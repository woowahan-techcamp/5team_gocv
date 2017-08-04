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
}
