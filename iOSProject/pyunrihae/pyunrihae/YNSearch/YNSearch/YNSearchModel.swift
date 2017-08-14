//
//  YNSearchModel.swift
//  YNSearch
//
//  Created by YiSeungyoun on 2017. 4. 21..
//  Copyright © 2017년 SeungyounYi. All rights reserved.
//

import Foundation

open class YNSearchModel {
    public init(key: String, id: String) {
        self.key = key
        self.id = id
    }
    open var key: String?
    open var id : String?
}
