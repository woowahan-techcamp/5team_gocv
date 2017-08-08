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
    
    
    // id순서로 이벤트 정보 배열을 받아오기.
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
}
