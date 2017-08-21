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
    static func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        
        return label.frame.height
    }
}
