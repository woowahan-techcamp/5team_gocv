//
//  ReviewTableViewCell.swift
//  pyunrihae
//
//  Created by woowabrothers on 2017. 8. 23..
//  Copyright © 2017년 busride. All rights reserved.
//

import UIKit

class ReviewTableViewCell: UITableViewCell {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var reviewView: UIView!
    @IBOutlet weak var badLabel: UILabel!
    @IBOutlet weak var usefulLabel: UILabel!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var reviewContentLabel: UILabel!
    @IBOutlet weak var starView: UIView!
    @IBOutlet weak var gradeLabel: UILabel!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
