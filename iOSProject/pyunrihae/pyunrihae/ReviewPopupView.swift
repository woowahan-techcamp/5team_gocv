//
//  ReviewPopupView.swift
//  pyunrihae
//
//  Created by woowabrothers on 2017. 8. 26..
//  Copyright © 2017년 busride. All rights reserved.
//

import UIKit

class ReviewPopupView: UIView {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var comment: UITextView!
    @IBOutlet weak var badNumLabel: UILabel!
    @IBOutlet weak var usefulNumLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var starView: UIImageView!
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var brand: UIImageView!
    @IBOutlet weak var uploadedImage: UIImageView!
    @IBOutlet weak var userImage: UIImageView!
    var validator = 0
    @IBAction func tabBlockView(_ sender: UITapGestureRecognizer) {
        self.removeFromSuperview()
    }
    @IBAction func showDetailProduct(_ sender: UIButton) {
        self.removeFromSuperview()
        NotificationCenter.default.post(name: NSNotification.Name("showDetailProduct"), object: self, userInfo: ["validator": validator])
    }
    @IBAction func closeBtn(_ sender: UIButton) {
        self.removeFromSuperview()
    }
}
