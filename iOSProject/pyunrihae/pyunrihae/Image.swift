//
//  Image.swift
//  pyunrihae
//
//  Created by woowabrothers on 2017. 8. 10..
//  Copyright © 2017년 busride. All rights reserved.
//

import Foundation
import UIKit

class Image {
    static func makeCircleImage (image: UIImageView) {
        image.layer.cornerRadius = image.layer.frame.height/2
        image.clipsToBounds = true
    }
}
