//
//  Label.swift
//  pyunrihae
//
//  Created by woowabrothers on 2017. 8. 9..
//  Copyright © 2017년 busride. All rights reserved.
//
import Foundation
import UIKit
class Label{
    static func makeRoundLabel(label: UILabel, color: UIColor){
        label.layer.borderWidth = 0.7
        label.layer.borderColor = color.cgColor
        label.layer.cornerRadius = label.layer.frame.height/2
        label.clipsToBounds = true
    }
    static func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        
        return label.frame.height
    }
    static func showLevel(PriceLevelLabel: UILabel, FlavorLevelLabel: UILabel, QuantityLevelLabel: UILabel, priceLevelDict: [String: Int], flavorLevelDict: [String: Int],quantityLevelDict: [String: Int]) {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        var maxPriceLevel = 3
        var maxFlavorLevel = 3
        var maxQuantityLevel = 3
        var maxPriceNum = 0
        var maxFlavorNum = 0
        var maxQuantityNum = 0
        for i in 1...5 {
            let p = "p" + i.description
            let f = "f" + i.description
            let q = "q" + i.description
            if priceLevelDict.count > 0  && priceLevelDict[p]! > maxPriceNum {
                maxPriceLevel = i
                maxPriceNum = priceLevelDict[p]!
            }
            if  flavorLevelDict.count > 0  && flavorLevelDict[f]! > maxFlavorNum {
                maxFlavorLevel = i
                maxFlavorNum = flavorLevelDict[f]!
            }
            if  quantityLevelDict.count > 0  && quantityLevelDict[q]! > maxQuantityNum {
                maxQuantityLevel = i
                maxQuantityNum = quantityLevelDict[q]!
            }
        }
        PriceLevelLabel.text = appdelegate.priceLevelList[maxPriceLevel - 1]
        FlavorLevelLabel.text = appdelegate.flavorLevelList[maxFlavorLevel - 1]
        QuantityLevelLabel.text = appdelegate.quantityLevelList[maxQuantityLevel - 1]
    }
    static func showWrittenTime(timestamp: String, timeLabel: UILabel){
        let format = DateFormatter()
        format.locale = Locale(identifier: "ko_kr")
        format.timeZone = TimeZone(abbreviation: "KST")
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let writtenDate = format.date(from: timestamp) {
            if writtenDate.timeIntervalSinceNow >= -5 * 24 * 60 * 60 {
                if writtenDate.timeIntervalSinceNow <= -1 * 24 * 60 * 60 {
                    let daysAgo = Int(-writtenDate.timeIntervalSinceNow / 24 / 60 / 60)
                    timeLabel.text = String(daysAgo) + "일 전"
                } else if writtenDate.timeIntervalSinceNow <= -1 * 60 * 60 {
                    let hoursAgo = Int(-writtenDate.timeIntervalSinceNow / 60 / 60)
                    timeLabel.text = String(hoursAgo) + "시간 전"
                } else if writtenDate.timeIntervalSinceNow <= -1 * 60{
                    let minutesAgo = Int(-writtenDate.timeIntervalSinceNow / 60)
                    timeLabel.text = String(minutesAgo) + "분 전"
                } else{
                    timeLabel.text = "방금"
                }
            } else {
                timeLabel.text = timestamp.components(separatedBy: " ")[0]
            }
        }
    }
}

