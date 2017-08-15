//
//  SelectedProduct.swift
//  pyunrihae
//
//  Created by woowabrothers on 2017. 8. 11..
//  Copyright © 2017년 busride. All rights reserved.
//

import Foundation
import UIKit

class SelectedProduct {
    static var foodId = ""
    static var foodName = ""
    static var brandName = ""
    static var category = ""
    static var price = ""
    static var reviewCount = 0
    static var reviewList = [String]() // 이후 데이터베이스 product항목에 리뷰리스트 아이디 넣어놓면 그에 따라 받아올 값
}
