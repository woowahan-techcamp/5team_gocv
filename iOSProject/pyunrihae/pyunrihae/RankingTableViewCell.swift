//
//  RankingTableViewCell.swift
//  pyunrihae
//
//  Created by woowabrothers on 2017. 8. 23..
//  Copyright © 2017년 busride. All rights reserved.
//

import UIKit

class RankingTableViewCell: UITableViewCell {
    @IBOutlet weak var orderNumLabel: UILabel!
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var EventLabel: UILabel!
    @IBOutlet weak var PriceLabel: UILabel!
    @IBOutlet weak var PriceLevelLabel: UILabel!
    @IBOutlet weak var FlavorLevelLabel: UILabel!
    @IBOutlet weak var QuantityLevelLabel: UILabel!
    @IBOutlet weak var gradeLabel: UILabel!
    @IBOutlet weak var starView: UIImageView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
