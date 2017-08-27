//
//  ProductReviewTableViewCell.swift
//  pyunrihae
//
//  Created by woowabrothers on 2017. 8. 10..
//  Copyright © 2017년 busride. All rights reserved.
//
import UIKit
class ProductReviewTableViewCell: UITableViewCell {
    @IBOutlet weak var uploadedFoodImage: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var usefulView: UIView!
    @IBOutlet weak var badView: UIView!
    @IBOutlet weak var commentTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var usefulBtn: UIButton!
    @IBOutlet weak var badBtn: UIButton!
    @IBOutlet weak var uploadedImageLoading: UIActivityIndicatorView!
    @IBOutlet weak var userImageLoading: UIActivityIndicatorView!
    @IBOutlet weak var noReviewView: UIView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var badNumLabel: UILabel!
    @IBOutlet weak var usefulNumLabel: UILabel!
    @IBOutlet weak var reviewBoxView: UIView!
    @IBOutlet weak var starView: UIView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var uploadedFoodImageBtn: UIButton!
    @IBOutlet weak var detailReviewLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
