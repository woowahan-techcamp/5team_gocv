//
//  ProductDetailInfoTableViewCell.swift
//  pyunrihae
//
//  Created by woowabrothers on 2017. 8. 10..
//  Copyright © 2017년 busride. All rights reserved.
//
import UIKit
class ProductDetailInfoTableViewCell: UITableViewCell {
    @IBOutlet weak var allergyBtn: UIButton!
    @IBOutlet weak var starView: UIView!
    @IBOutlet weak var gradeLabel: UILabel!
    @IBOutlet weak var quantityLevelLabel: UILabel!
    @IBOutlet weak var flavorLevelLabel: UILabel!
    @IBOutlet weak var priceLevelLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
