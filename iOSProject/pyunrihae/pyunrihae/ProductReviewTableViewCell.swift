//
//  ProductReviewTableViewCell.swift
//  pyunrihae
//
//  Created by woowabrothers on 2017. 8. 10..
//  Copyright © 2017년 busride. All rights reserved.
//

import UIKit

class ProductReviewTableViewCell: UITableViewCell {
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var badNumLabel: UILabel!
    @IBOutlet weak var usefulNumLabel: UILabel!
    @IBOutlet weak var reviewBoxView: UIView!
    @IBOutlet weak var starView: UIView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var uploadedFoodImage: UIImageView!
    @IBOutlet weak var detailReviewLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
