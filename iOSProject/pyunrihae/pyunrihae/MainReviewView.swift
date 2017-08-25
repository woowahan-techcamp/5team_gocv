//
//  MainReviewView.swift
//  pyunrihae
//
//  Created by woowabrothers on 2017. 8. 22..
//  Copyright © 2017년 busride. All rights reserved.
//

import UIKit

class MainReviewView: UIView {
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var blackLayerView : UIView!
    @IBOutlet weak var barLabel : UILabel!
    @IBOutlet weak var brandLabel : UILabel!
    @IBOutlet weak var nameLabel : UILabel!
    @IBOutlet weak var reviewLabel : UILabel!
    @IBOutlet weak var moreLabel : UILabel!
    @IBOutlet weak var hotReviewLabel : UILabel!
    @IBOutlet weak var selectedCountLabel : UILabel!
    @IBOutlet weak var totalCountLabel : UILabel!
    @IBOutlet weak var starImageView : UIImageView!
    class func instanceFromNib() -> MainReviewView {
        return UINib(nibName: "MainReview", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MainReviewView
    }
}
