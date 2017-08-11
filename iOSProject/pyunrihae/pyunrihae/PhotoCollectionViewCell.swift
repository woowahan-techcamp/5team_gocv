//
//  PhotoCollectionViewCell.swift
//  pyunrihae
//
//  Created by woowabrothers on 2017. 8. 11..
//  Copyright © 2017년 busride. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var flagForSelect: UIView!
    override var isSelected: Bool{
        didSet{
            if isSelected {
                flagForSelect.backgroundColor = UIColor.white.withAlphaComponent(0.7)
            } else {
                flagForSelect.backgroundColor = UIColor.white.withAlphaComponent(0)
            }
        }
    }
}
