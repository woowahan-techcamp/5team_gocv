//
//  Image.swift
//  pyunrihae
//
//  Created by woowabrothers on 2017. 8. 10..
//  Copyright © 2017년 busride. All rights reserved.
//
import Foundation
import UIKit
class Image {
    static func makeCircleImage (image: UIImageView) {
        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius = image.layer.frame.height/2
        image.clipsToBounds = true
    }
    static func drawStar(numberOfPlaces: Double, grade_avg: Double, gradeLabel: UILabel, starView: UIImageView) {
        for sub in starView.subviews {
            sub.removeFromSuperview()
        }
        let multiplier = pow(10.0, numberOfPlaces)
        let grade = round(Double(grade_avg) * multiplier) / multiplier
        gradeLabel.text = String(grade)
        starView.contentMode = .scaleAspectFit
        if grade < 0.5 {
            starView.image = UIImage(named: "star0.png")
        } else if grade < 1.0 {
            starView.image = UIImage(named: "star5.png")
        } else if grade < 1.5 {
            starView.image = UIImage(named: "star1.png")
        } else if grade < 2.0 {
            starView.image = UIImage(named: "star15.png")
        } else if grade < 2.5 {
            starView.image = UIImage(named: "star2.png")
        } else if grade < 3.0 {
            starView.image = UIImage(named: "star25.png")
        } else if grade < 3.5 {
            starView.image = UIImage(named: "star3.png")
        } else if grade < 4.0 {
            starView.image = UIImage(named: "star35.png")
        } else if grade < 4.5 {
            starView.image = UIImage(named: "star4.png")
        } else if grade < 5.0 {
            starView.image = UIImage(named: "star45.png")
        } else if grade == 5.0 {
            starView.image = UIImage(named: "star5.png")
        }
    }
}
