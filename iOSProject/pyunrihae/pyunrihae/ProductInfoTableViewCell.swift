//
//  ProductInfoTableViewCell.swift
//  pyunrihae
//
//  Created by woowabrothers on 2017. 8. 10..
//  Copyright © 2017년 busride. All rights reserved.
//

import UIKit

class ProductInfoTableViewCell: UITableViewCell {
    @IBOutlet weak var manufacturerLabel: UILabel!
    @IBOutlet weak var foodImageBtn: UIButton!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var eventLabel: UILabel!
    @IBOutlet weak var capacityLabel: UILabel!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
