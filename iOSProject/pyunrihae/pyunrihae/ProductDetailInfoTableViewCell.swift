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
    @IBOutlet weak var gradeLabel: UILabel!
    @IBOutlet weak var quantityLevelLabel: UILabel!
    @IBOutlet weak var flavorLevelLabel: UILabel!
    @IBOutlet weak var priceLevelLabel: UILabel!
    @IBOutlet weak var starImageView: UIImageView!
    var product = Product()
    var productId = ""
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    @IBAction func tabAllergyBtn(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name("showAllergy"), object: self, userInfo: ["productId" : productId])
    }
    func setCellValue(productId: String) {
        self.productId = productId
        DataManager.getProductById(id: productId) { (product) in
            Image.drawStar(numberOfPlaces: 2.0, grade_avg: Double(product.grade_avg), gradeLabel: self.gradeLabel, starView: self.starImageView)
            let allergyList = product.allergy
            if allergyList.count != 0 {
                let allergy = allergyList[0]
                if allergyList.count == 1 {
                    self.allergyBtn.isEnabled = false
                    self.allergyBtn.setTitle(allergy, for: .normal)
                } else {
                    self.allergyBtn.isEnabled = true
                    let count = allergyList.count - 1
                    self.allergyBtn.setTitle(allergy + " 외 " + count.description + "개의 성분 >", for: .normal)
                }
            } else {
                self.allergyBtn.isEnabled = false
                self.allergyBtn.setTitle("알레르기 정보가 없습니다!", for: .normal)
            }
            Label.showLevel(PriceLevelLabel: self.priceLevelLabel, FlavorLevelLabel: self.flavorLevelLabel, QuantityLevelLabel: self.quantityLevelLabel, priceLevelDict: product.price_level, flavorLevelDict: product.flavor_level, quantityLevelDict: product.quantity_level)
        }
    }
}
