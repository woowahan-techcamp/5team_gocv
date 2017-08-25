//
//  MainProduct.swift
//  pyunrihae
//
//  Created by woowabrothers on 2017. 8. 24..
//  Copyright © 2017년 busride. All rights reserved.
//

import UIKit

class MainProduct: UIView {
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var productImageview: UIImageView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    class func instanceFromNib() -> MainProduct {
        return UINib(nibName: "MainProduct", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MainProduct
    }
}
