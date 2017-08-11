//
//  TabBarView.swift
//  pyunrihae
//
//  Created by woowabrothers on 2017. 8. 7..
//  Copyright © 2017년 busride. All rights reserved.
//

import UIKit

class TabBarView: UIView {

    override func draw(_ rect: CGRect) {
        let color = UIColor(red: CGFloat(Float(0x90) / 255.0), green: CGFloat(Float(0x90) / 255.0),  blue: CGFloat(Float(0x90) / 255.0), alpha: CGFloat(Float(1)))
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = 0.3
    }

}
