//
//  ProductReviewTableViewCell.swift
//  pyunrihae
//
//  Created by woowabrothers on 2017. 8. 10..
//  Copyright © 2017년 busride. All rights reserved.
//

import UIKit

class ProductReviewTableViewCell: UITableViewCell {
    @IBOutlet weak var usefulView: UIView!
    @IBOutlet weak var badView: UIView!
    @IBOutlet weak var commentTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var usefulBtn: UIButton!
    @IBOutlet weak var badBtn: UIButton!
    @IBOutlet weak var uploadedImageLoading: UIActivityIndicatorView!
    @IBOutlet weak var userImageLoading: UIActivityIndicatorView!
    @IBOutlet weak var noReviewView: UIView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var badNumLabel: UILabel!
    @IBOutlet weak var usefulNumLabel: UILabel!
    @IBOutlet weak var reviewBoxView: UIView!
    @IBOutlet weak var starView: UIView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var uploadedFoodImageBtn: UIButton!
    @IBOutlet weak var detailReviewLabel: UILabel!
    var productDetailViewController : ProductDetailViewController!
    @IBAction func tabUsefulBtn(_ sender: UIButton) {
        if appdelegate.user?.email != "" {
            let reviewStatus = appdelegate.user?.review_like_list[reviewId]
            let uid = appdelegate.user?.id
            if reviewStatus == nil { //유용해요 누른적이 없는 리뷰
                DataManager.tabUsefulBtn(id: reviewId)
                var useful = Int(usefulNumLabel.text!)
                useful = useful! + 1
                usefulNumLabel.text = String(describing: useful!)
                DataManager.updateUsefulReview(id: reviewId, uid: uid!)
                appdelegate.user?.review_like_list[reviewId] = 1
                Button.makeBorder(btn: usefulBtn)
                Button.deleteBorder(btn: badBtn)
                usefulNumLabel.textColor = UIColor.red
                badNumLabel.textColor = UIColor.lightGray
            } else if reviewStatus == 1 { // 유용해요 취소
                DataManager.cancleUsefulBtn(id: reviewId)
                var useful = Int(usefulNumLabel.text!)
                useful = useful! - 1
                usefulNumLabel.text = String(describing: useful!)
                DataManager.updateCancleReview(id: reviewId, uid: uid!)
                appdelegate.user?.review_like_list[reviewId] = 0
                Button.deleteBorder(btn: usefulBtn)
                Button.deleteBorder(btn: badBtn)
                usefulNumLabel.textColor = UIColor.lightGray
                badNumLabel.textColor = UIColor.lightGray
            } else if reviewStatus == -1 { // 별로에요 취소후 유용해요 누르기
                DataManager.tabUsefulBtn(id: reviewId)
                DataManager.cancleBadBtn(id: reviewId)
                var useful = Int(usefulNumLabel.text!)
                useful = useful! + 1
                usefulNumLabel.text = String(describing: useful!)
                var bad = Int(badNumLabel.text!)
                bad = bad! - 1
                badNumLabel.text = String(describing: bad!)
                DataManager.updateUsefulReview(id: reviewId, uid: uid!)
                appdelegate.user?.review_like_list[reviewId] = 1
                Button.makeBorder(btn: usefulBtn)
                Button.deleteBorder(btn: badBtn)
                usefulNumLabel.textColor = UIColor.red
                badNumLabel.textColor = UIColor.lightGray
            } else if reviewStatus == 0 { // 별로에요 취소 했다가 다시 누르기
                DataManager.tabUsefulBtn(id: reviewId)
                var useful = Int(usefulNumLabel.text!)
                useful = useful! + 1
                usefulNumLabel.text = String(describing: useful!)
                DataManager.updateUsefulReview(id: reviewId, uid: uid!)
                appdelegate.user?.review_like_list[reviewId] = 1
                Button.makeBorder(btn: usefulBtn)
                Button.deleteBorder(btn: badBtn)
                usefulNumLabel.textColor = UIColor.red
                badNumLabel.textColor = UIColor.lightGray
            }
        }
    }
    @IBAction func tabBadBtn(_ sender: UIButton) {
        if appdelegate.user?.email != "" {
            let uid = appdelegate.user?.id
            let reviewStatus = appdelegate.user?.review_like_list[reviewId]
            if reviewStatus == nil { //별로에요 누른적이 없는 리뷰
                DataManager.tabBadBtn(id: reviewId)
                var bad = Int(badNumLabel.text!)
                bad = bad! + 1
                badNumLabel.text = String(describing: bad!)
                DataManager.updateBadReview(id: reviewId, uid: uid!)
                appdelegate.user?.review_like_list[reviewId] = -1
                Button.makeBorder(btn: badBtn)
                Button.deleteBorder(btn: usefulBtn)
                usefulNumLabel.textColor = UIColor.lightGray
                badNumLabel.textColor = UIColor.red
            } else if reviewStatus == -1 { // 별로에요 취소
                DataManager.cancleBadBtn(id: reviewId)
                var bad = Int(badNumLabel.text!)
                bad = bad! - 1
                badNumLabel.text = String(describing: bad!)
                DataManager.updateCancleReview(id: reviewId, uid: uid!)
                appdelegate.user?.review_like_list[reviewId] = 0
                Button.deleteBorder(btn: usefulBtn)
                Button.deleteBorder(btn: badBtn)
                usefulNumLabel.textColor = UIColor.lightGray
                badNumLabel.textColor = UIColor.lightGray
            } else if reviewStatus == 1 { // 유용해요 취소후 별로에요 누르기
                DataManager.tabBadBtn(id: reviewId)
                DataManager.cancleUsefulBtn(id: reviewId)
                var bad = Int(badNumLabel.text!)
                bad = bad! + 1
                badNumLabel.text = String(describing: bad!)
                var useful = Int(usefulNumLabel.text!)
                useful = useful! - 1
                usefulNumLabel.text = String(describing: useful!)
                DataManager.updateBadReview(id: reviewId, uid: uid!)
                appdelegate.user?.review_like_list[reviewId] = -1
                Button.makeBorder(btn: badBtn)
                Button.deleteBorder(btn: usefulBtn)
                usefulNumLabel.textColor = UIColor.lightGray
                badNumLabel.textColor = UIColor.red
            } else if reviewStatus == 0 { // 별로에요 취소 했다가 다시 누르기
                DataManager.tabBadBtn(id: reviewId)
                var bad = Int(badNumLabel.text!)
                bad = bad! + 1
                badNumLabel.text = String(describing: bad!)
                DataManager.updateBadReview(id: reviewId, uid: uid!)
                appdelegate.user?.review_like_list[reviewId] = -1
                Button.makeBorder(btn: badBtn)
                Button.deleteBorder(btn: usefulBtn)
                usefulNumLabel.textColor = UIColor.lightGray
                badNumLabel.textColor = UIColor.red
            }
        }
    }
    var reviewId = ""
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
