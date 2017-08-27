//
//  Popup.swift
//  pyunrihae
//
//  Created by woowabrothers on 2017. 8. 27..
//  Copyright © 2017년 busride. All rights reserved.
//
import Foundation
import UIKit
class Popup{
    static func showPopup(popup: ReviewPopupView, index: Int, reviewList: [Review],review: Review, view: UIView){
        let frame = view.frame
        popup.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        popup.frame = frame
        popup.view.layer.borderColor = UIColor.gray.cgColor
        popup.view.layer.borderWidth = 0.3
        popup.view.layer.cornerRadius = 10
        popup.view.layer.cornerRadius = 10
        popup.comment.text = review.comment
        popup.comment.isEditable = false
        popup.comment.layer.cornerRadius = 10
        popup.comment.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10)
        popup.userNameLabel.text = review.user
        popup.foodNameLabel.text = review.p_name
        view.addSubview(popup)
        Image.makeCircleImage(image: popup.userImage)
        popup.userImage.contentMode = .scaleAspectFit
        popup.userImage.layer.borderColor = UIColor.gray.cgColor
        popup.userImage.layer.borderWidth = 0.3
        if URL(string: review.user_image) != nil{
            popup.userImage.af_setImage(withURL: URL(string: review.user_image)!)
        } else {
            popup.userImage.image = UIImage(named: "user_default.png")
        }
        popup.uploadedImage.contentMode = .scaleAspectFill
        popup.uploadedImage.clipsToBounds = true
        if URL(string: review.p_image) != nil{
            popup.uploadedImage.af_setImage(withURL: URL(string: review.p_image)!)
        } else {
            popup.uploadedImage.af_setImage(withURL: URL(string: "https://firebasestorage.googleapis.com/v0/b/pyeonrehae.appspot.com/o/ic_background_default.png?alt=media&token=09d05950-5f8a-4a73-95b3-a74faee4cad3")!)
        }
        popup.brand.contentMode = .scaleAspectFit
        if review.brand == "CU" {
            popup.brand.image = UIImage(named: "logo_cu.png")
        } else if review.brand == "GS25" {
            popup.brand.image = UIImage(named: "logo_gs25.png")
        } else if review.brand == "7-eleven" {
            popup.brand.image = UIImage(named: "logo_7eleven.png")
        } else {
            popup.brand.image = UIImage(named: "ic_common.png")
        }
        switch(review.grade) {
            case 1 : popup.starView.image = #imageLiteral(resourceName: "star1.png")
            case 2: popup.starView.image = #imageLiteral(resourceName: "star2.png")
            case 3 : popup.starView.image = #imageLiteral(resourceName: "star3.png")
            case 4 : popup.starView.image = #imageLiteral(resourceName: "star4.png")
            case 5 : popup.starView.image = #imageLiteral(resourceName: "star5.png")
            default : popup.starView.image = #imageLiteral(resourceName: "star3.png")
        }
        popup.starView.contentMode = .scaleAspectFit
        Label.showWrittenTime(timestamp: review.timestamp, timeLabel: popup.timeLabel)
    }
}
