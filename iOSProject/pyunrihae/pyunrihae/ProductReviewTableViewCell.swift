//
//  ProductReviewTableViewCell.swift
//  pyunrihae
//
//  Created by woowabrothers on 2017. 8. 10..
//  Copyright © 2017년 busride. All rights reserved.
//
import UIKit
class ProductReviewTableViewCell: UITableViewCell {
    @IBOutlet weak var starImageView: UIImageView!
    @IBOutlet weak var uploadedFoodImage: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var commentTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var uploadedImageLoading: UIActivityIndicatorView!
    @IBOutlet weak var userImageLoading: UIActivityIndicatorView!
    @IBOutlet weak var btnsView: UIView!
    @IBOutlet weak var noReviewView: UIView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var reviewBoxView: UIView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var uploadedFoodImageBtn: UIButton!
    @IBOutlet weak var detailReviewLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func setCellValue(review: Review, reviewList: [Review]) {
        self.userNameLabel.text = ""
        self.detailReviewLabel.text = ""
        self.userImage.image = UIImage(named: "user_default.png")
        self.uploadedFoodImageBtn.setBackgroundImage(UIImage(), for: .normal)
        if reviewList.count > 0 {
            Label.showWrittenTime(timestamp: review.timestamp, timeLabel: self.timeLabel)
            let btns = UsefulBadBtnView.instanceFromNib() as! UsefulBadBtnView
            btns.reviewId = review.id
            btns.reviewList = reviewList
            btns.frame = self.btnsView.frame
            btns.frame.origin.x = 0
            btns.frame.origin.y = 0
            for sub in self.btnsView.subviews {
                sub.removeFromSuperview()
            }
            self.btnsView.addSubview(btns)
            btns.backgroundColor = UIColor.white.withAlphaComponent(0)
            btns.badBtn.isEnabled = false
            btns.usefulBtn.isEnabled = false
            DataManager.getReviewBy(id: review.id){ (review) in
                btns.badNumLabel.text = String(review.bad)
                btns.usefulNumLabel.text = String(review.useful)
                Button.validateUseful(review: review, usefulBtn: btns.usefulBtn, badBtn: btns.badBtn, usefulNumLabel: btns.usefulNumLabel, badNumLabel: btns.badNumLabel)
                btns.badBtn.isEnabled = true
                btns.usefulBtn.isEnabled = true
            }
            self.detailReviewLabel.text = review.comment
            let height = Label.heightForView(text: review.comment, font: self.detailReviewLabel.font, width: self.detailReviewLabel.frame.width)
            self.detailReviewLabel.frame.size.height = height
            self.userNameLabel.text = review.user
            self.userImageLoading.startAnimating()
            Image.makeCircleImage(image: self.userImage)
            self.userImage.contentMode = .scaleAspectFill
            self.userImage.clipsToBounds = true
            self.userImage.af_setImage(withURL: URL(string: review.user_image)!, placeholderImage: UIImage(), imageTransition: .crossDissolve(0.2), completion:{ image in
                self.userImageLoading.stopAnimating()
            })
            self.detailReviewLabel.frame.origin.y = 130
            self.commentTopConstraint.constant = 8
            self.reviewBoxView.layer.cornerRadius = 10
            self.uploadedFoodImageBtn.isHidden = true
            self.uploadedFoodImage.isHidden = true
            self.detailReviewLabel.isHidden = true
            if review.p_image != "" {
                self.uploadedFoodImageBtn.isHidden = false
                self.uploadedFoodImage.isHidden = false
                self.detailReviewLabel.isHidden = false
                self.reviewBoxView.frame.size.height = height + 135
                self.uploadedImageLoading.startAnimating()
                self.uploadedFoodImage.contentMode = .scaleAspectFill
                self.uploadedFoodImage.clipsToBounds = true
                let color = UIColor(red: CGFloat(230.0 / 255.0), green: CGFloat(230.0 / 255.0),  blue: CGFloat(230.0 / 255.0), alpha: CGFloat(Float(1)))
                self.uploadedFoodImage.backgroundColor = color
                self.uploadedFoodImage.af_setImage(withURL: URL(string: review.p_image)!, placeholderImage: UIImage(), completion:{ image in
                    self.uploadedFoodImageBtn.setBackgroundImage(self.uploadedFoodImage.image, for: .normal)
                    self.uploadedImageLoading.stopAnimating()
                })
            } else {
                if self.detailReviewLabel.text == "" { // 사진 글 모두 없는 경우
                    self.reviewBoxView.frame.size.height = 90
                }else { // 사진만 없는 경우
                    self.detailReviewLabel.isHidden = false
                    self.reviewBoxView.frame.size.height = height + 90
                    self.commentTopConstraint.constant -= 60
                }
            }
            for sub in self.starImageView.subviews {
                sub.removeFromSuperview()
            }
            self.starImageView.contentMode = .scaleAspectFit
            switch(review.grade) {
            case 1 : self.starImageView?.image = #imageLiteral(resourceName: "star1.png")
            case 2: self.starImageView?.image = #imageLiteral(resourceName: "star2.png")
            case 3 : self.starImageView?.image = #imageLiteral(resourceName: "star3.png")
            case 4 : self.starImageView?.image = #imageLiteral(resourceName: "star4.png")
            case 5 : self.starImageView?.image = #imageLiteral(resourceName: "star5.png")
            default : self.starImageView?.image = #imageLiteral(resourceName: "star3.png")
            }
        }
    }
}
