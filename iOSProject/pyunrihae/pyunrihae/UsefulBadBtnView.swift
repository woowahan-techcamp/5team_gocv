//
//  UsefulBadBtnView.swift
//  pyunrihae
//
//  Created by woowabrothers on 2017. 8. 29..
//  Copyright © 2017년 busride. All rights reserved.
//
import UIKit
class UsefulBadBtnView: UIView {
    @IBOutlet weak var usefulBtn: UIButton!
    @IBOutlet weak var badBtn: UIButton!
    @IBOutlet weak var usefulNumLabel: UILabel!
    @IBOutlet weak var badNumLabel: UILabel!
    var reviewList = [Review]()
    var reviewId = ""
    var validator = 0
    @IBAction func tabUsefulBtn(_ sender: UIButton) {
        if User.sharedInstance.email == "" {
            NotificationCenter.default.post(name: NSNotification.Name("showLoginPopup"), object: self, userInfo: ["validator": validator])
        } else {
            var reviewStatus = User.sharedInstance.review_like_list[reviewId]
            let uid = User.sharedInstance.id
            if reviewStatus == nil { //유용해요 누른적이 없는 리뷰
                var useful = Int(usefulNumLabel.text!)
                useful = useful! + 1
                usefulNumLabel.text = String(describing: useful!)
                DataManager.updateUsefulReview(id: reviewId, uid: uid)
                reviewStatus = 1
                Button.makeBorder(btn: usefulBtn)
                Button.deleteBorder(btn: badBtn)
                usefulNumLabel.textColor = UIColor.red
                badNumLabel.textColor = UIColor.lightGray
            } else if reviewStatus == 1 { // 유용해요 취소
                var useful = Int(usefulNumLabel.text!)
                useful = useful! - 1
                usefulNumLabel.text = String(describing: useful!)
                DataManager.updateCancleReview(id: reviewId, uid: uid)
                reviewStatus = 0
                Button.deleteBorder(btn: usefulBtn)
                Button.deleteBorder(btn: badBtn)
                usefulNumLabel.textColor = UIColor.lightGray
                badNumLabel.textColor = UIColor.lightGray
            } else if reviewStatus == -1 { // 별로에요 취소후 유용해요 누르기
                var useful = Int(usefulNumLabel.text!)
                useful = useful! + 1
                usefulNumLabel.text = String(describing: useful!)
                var bad = Int(badNumLabel.text!)
                bad = bad! - 1
                badNumLabel.text = String(describing: bad!)
                DataManager.updateUsefulReview(id: reviewId, uid: uid)
                reviewStatus = 1
                Button.makeBorder(btn: usefulBtn)
                Button.deleteBorder(btn: badBtn)
                usefulNumLabel.textColor = UIColor.red
                badNumLabel.textColor = UIColor.lightGray
            } else if reviewStatus == 0 { // 별로에요 취소 했다가 다시 누르기
                var useful = Int(usefulNumLabel.text!)
                useful = useful! + 1
                usefulNumLabel.text = String(describing: useful!)
                DataManager.updateUsefulReview(id: reviewId, uid: uid)
                reviewStatus = 1
                Button.makeBorder(btn: usefulBtn)
                Button.deleteBorder(btn: badBtn)
                usefulNumLabel.textColor = UIColor.red
                badNumLabel.textColor = UIColor.lightGray
            }
            User.sharedInstance.review_like_list[reviewId] = reviewStatus
            for i in 0..<reviewList.count {
                if reviewList[i].id == reviewId {
                    reviewList[i].useful = Int(usefulNumLabel.text!)!
                    reviewList[i].bad = Int(badNumLabel.text!)!
                    DataManager.tabUsefulBtn(id: reviewId, useful: Int(usefulNumLabel.text!)!)
                    DataManager.tabBadBtn(id: reviewId, bad: Int(badNumLabel.text!)!)
                }
            }
            NotificationCenter.default.post(name: NSNotification.Name("reloadReview"), object: self)
        }
    }
    @IBAction func tabBadBtn(_ sender: UIButton) {
        if User.sharedInstance.email == "" {
            NotificationCenter.default.post(name: NSNotification.Name("showLoginPopup"), object: self, userInfo: ["validator": validator])
        } else {
            let uid = User.sharedInstance.id
            var reviewStatus = User.sharedInstance.review_like_list[reviewId]
            if reviewStatus == nil { //별로에요 누른적이 없는 리뷰
                var bad = Int(badNumLabel.text!)
                bad = bad! + 1
                badNumLabel.text = String(describing: bad!)
                DataManager.updateBadReview(id: reviewId, uid: uid)
                reviewStatus = -1
                Button.makeBorder(btn: badBtn)
                Button.deleteBorder(btn: usefulBtn)
                usefulNumLabel.textColor = UIColor.lightGray
                badNumLabel.textColor = UIColor.red
            } else if reviewStatus == -1 { // 별로에요 취소
                var bad = Int(badNumLabel.text!)
                bad = bad! - 1
                badNumLabel.text = String(describing: bad!)
                DataManager.updateCancleReview(id: reviewId, uid: uid)
                reviewStatus = 0
                Button.deleteBorder(btn: usefulBtn)
                Button.deleteBorder(btn: badBtn)
                usefulNumLabel.textColor = UIColor.lightGray
                badNumLabel.textColor = UIColor.lightGray
            } else if reviewStatus == 1 { // 유용해요 취소후 별로에요 누르기
                var bad = Int(badNumLabel.text!)
                bad = bad! + 1
                badNumLabel.text = String(describing: bad!)
                var useful = Int(usefulNumLabel.text!)
                useful = useful! - 1
                usefulNumLabel.text = String(describing: useful!)
                DataManager.updateBadReview(id: reviewId, uid: uid)
                reviewStatus = -1
                Button.makeBorder(btn: badBtn)
                Button.deleteBorder(btn: usefulBtn)
                usefulNumLabel.textColor = UIColor.lightGray
                badNumLabel.textColor = UIColor.red
            } else if reviewStatus == 0 { // 별로에요 취소 했다가 다시 누르기
                var bad = Int(badNumLabel.text!)
                bad = bad! + 1
                badNumLabel.text = String(describing: bad!)
                DataManager.updateBadReview(id: reviewId, uid: uid)
                reviewStatus = -1
                Button.makeBorder(btn: badBtn)
                Button.deleteBorder(btn: usefulBtn)
                usefulNumLabel.textColor = UIColor.lightGray
                badNumLabel.textColor = UIColor.red
            }
            User.sharedInstance.review_like_list[reviewId] = reviewStatus
            for i in 0..<reviewList.count {
                if reviewList[i].id == reviewId {
                    reviewList[i].useful = Int(usefulNumLabel.text!)!
                    reviewList[i].bad = Int(badNumLabel.text!)!
                    DataManager.tabUsefulBtn(id: reviewId, useful: Int(usefulNumLabel.text!)!)
                    DataManager.tabBadBtn(id: reviewId, bad: Int(badNumLabel.text!)!)
                }
            }
            NotificationCenter.default.post(name: NSNotification.Name("reloadReview"), object: self)
        }
    }
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "UsefulBadBtn", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
}
