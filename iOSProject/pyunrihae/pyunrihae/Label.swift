//
//  Label.swift
//  pyunrihae
//
//  Created by woowabrothers on 2017. 8. 9..
//  Copyright © 2017년 busride. All rights reserved.
//

import Foundation
import UIKit

class Label{
    static func makeRoundLabel(label: UILabel, color: UIColor){
        label.layer.borderWidth = 0.7
        label.layer.borderColor = color.cgColor
        label.layer.cornerRadius = label.layer.frame.height/2
        label.clipsToBounds = true
    }
}
