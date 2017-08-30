//
//  ProductInfoTableViewCell.swift
//  pyunrihae
//
//  Created by woowabrothers on 2017. 8. 10..
//  Copyright © 2017년 busride. All rights reserved.
//
import UIKit
class ProductInfoTableViewCell: UITableViewCell {
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var manufacturerLabel: UILabel!
    @IBOutlet weak var foodImageBtn: UIButton!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var eventLabel: UILabel!
    @IBOutlet weak var capacityLabel: UILabel!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCellValue(productId: String) {
        DataManager.getProductById(id: productId) { (product) in
            self.priceLabel.text = product.price + "원"
            self.brandLabel.text = product.brand
            self.foodNameLabel.text = product.name
            self.capacityLabel.text = product.capacity
            self.manufacturerLabel.text = product.manufacturer
            if product.event != "\r" {
                self.eventLabel.text = product.event
                Label.makeRoundLabel(label: self.eventLabel, color: self.appdelegate.mainColor)
                self.eventLabel.textColor = self.appdelegate.mainColor
            }else{
                self.eventLabel.isHidden = true
            }
            self.loading.startAnimating()
            self.foodImage.contentMode = .scaleAspectFit
            self.foodImage.backgroundColor = UIColor.white
            self.foodImage.clipsToBounds = true
            

            self.foodImage.af_setImage(withURL: URL(string: product.image)!, placeholderImage: UIImage(), completion:{ image in
                self.foodImageBtn.setBackgroundImage(self.foodImage.image, for: .normal)
                self.loading.stopAnimating()
            })
        }
    }
}
