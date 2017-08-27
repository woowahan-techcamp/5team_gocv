//
//  LikeProductTableViewCell.swift
//  pyunrihae
//
//  Created by woowabrothers on 2017. 8. 21..
//  Copyright © 2017년 busride. All rights reserved.
//
import UIKit
class LikeProductTableViewCell: UITableViewCell {
    @IBOutlet weak var moreImage: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
