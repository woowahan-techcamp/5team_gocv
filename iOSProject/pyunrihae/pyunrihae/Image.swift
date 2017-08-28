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
    static func drawStar(numberOfPlaces: Double, grade_avg: Double, gradeLabel: UILabel, starView: UIView, needSpace: Bool) {
        for sub in starView.subviews {
            sub.removeFromSuperview()
        }
        let multiplier = pow(10.0, numberOfPlaces)
        let grade = round(Double(grade_avg) * multiplier) / multiplier
        gradeLabel.text = String(grade)
        var space = 0
        if grade - Double(Int(grade)) >= 0.5 {
            let starImage = UIImage(named: "stars.png")
            let cgImage = starImage?.cgImage
            let croppedCGImage: CGImage = cgImage!.cropping(to: CGRect(x: (starImage?.size.width)! * 4 / 5, y: 10, width: (starImage?.size.width)!, height: starImage!.size.height))!
            let uiImage = UIImage(cgImage: croppedCGImage)
            let imageView = UIImageView(image: uiImage)
            if needSpace {
                space = (4 - Int(grade)) * 15
            }
            imageView.frame = CGRect(x: Int(grade) * 18 - 3 + space, y: 0, width: 18, height: 15)
            starView.addSubview(imageView)
            for i in (5 - Int(grade)..<5) {
                let emptyStarImage =  UIImage(named: "empty_star.png")
                let imageView = UIImageView(image: emptyStarImage)
                imageView.contentMode = .scaleAspectFit
                imageView.frame = CGRect(x: i * 18 - 3 + space, y: 0, width: 18, height: 15)
                starView.addSubview(imageView)
            }
        } else{
            if needSpace{
                space = (5 - Int(grade)) * 15
            }
            for i in Int(grade)..<5 {
                let emptyStarImage =  UIImage(named: "empty_star.png")
                let imageView = UIImageView(image: emptyStarImage)
                imageView.contentMode = .scaleAspectFit
                imageView.frame = CGRect(x: i * 18 - 3 + space, y: 0, width: 18, height: 15)
                starView.addSubview(imageView)
            }
        }
        for i in 0..<Int(grade) {
            let starImage = UIImage(named: "stars.png")
            let cgImage = starImage?.cgImage
            let croppedCGImage: CGImage = cgImage!.cropping(to: CGRect(x: 0, y: 10, width: (starImage?.size.width)! / 5, height: starImage!.size.height))!
            let uiImage = UIImage(cgImage: croppedCGImage)
            let imageView = UIImageView(image: uiImage)
            imageView.frame = CGRect(x: i * 18 + space, y: 0, width: 18, height: 15)
            starView.addSubview(imageView)
        }
    }
}
