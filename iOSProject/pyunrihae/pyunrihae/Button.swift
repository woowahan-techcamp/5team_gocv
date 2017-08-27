//
//  Button.swift
//  pyunrihae
//
//  Created by woowabrothers on 2017. 8. 8..
//  Copyright © 2017년 busride. All rights reserved.
//
import Foundation
import UIKit
class Button{
    static func select(btn: UIButton){
        let color = UIColor(red: CGFloat(255.0 / 255.0), green: CGFloat(120.0 / 255.0),  blue: CGFloat(0.0 / 255.0), alpha: CGFloat(Float(1)))
        btn.isSelected = true
        btn.setTitleColor(color, for: .selected)
    }
    static func changeColor(btn: UIButton, color: UIColor, imageName: String){
        let origImage = UIImage(named: imageName);
        let tintedImage = origImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        btn.setImage(tintedImage, for: .normal)
        btn.tintColor = color
    }
    static func makeNormalBtn(btn: UIButton, text: String){
        let color = UIColor(red: CGFloat(255.0 / 255.0), green: CGFloat(120.0 / 255.0),  blue: CGFloat(0.0 / 255.0), alpha: CGFloat(Float(1)))
        btn.setTitle(text, for: .normal)
        btn.setTitleColor(color, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        btn.layer.borderColor = color.cgColor
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = btn.layer.frame.height/2
        btn.clipsToBounds = true
    }
    static func makeSelectedBtn(btn: UIButton) {
        let color = UIColor(red: CGFloat(255.0 / 255.0), green: CGFloat(120.0 / 255.0),  blue: CGFloat(0.0 / 255.0), alpha: CGFloat(Float(1)))
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor = color
        
    }
    static func makeDeselectedBtn(btn: UIButton) {
        let color = UIColor(red: CGFloat(255.0 / 255.0), green: CGFloat(120.0 / 255.0),  blue: CGFloat(0.0 / 255.0), alpha: CGFloat(Float(1)))
        btn.setTitleColor(color, for: .normal)
        btn.backgroundColor = UIColor.white
    }
    static func makeBorder(btn: UIButton) {
        let color = UIColor(red: CGFloat(255.0 / 255.0), green: CGFloat(120.0 / 255.0),  blue: CGFloat(0.0 / 255.0), alpha: CGFloat(Float(1)))
        btn.layer.borderWidth = 0.7
        btn.layer.borderColor = color.cgColor
        btn.layer.cornerRadius = btn.layer.frame.height/4
        btn.clipsToBounds = true
    }
    static func deleteBorder(btn: UIButton) {
        let color = UIColor.lightGray
        btn.layer.borderWidth = 0.7
        btn.layer.borderColor = color.cgColor
        btn.layer.cornerRadius = btn.layer.frame.height/4
        btn.clipsToBounds = true
    }
    static func selectCategory(view: UIView, previousIndex: Int, categoryBtns: [UIButton], selectedCategoryIndex: Int, categoryScrollView: UIScrollView, scrollBar: UILabel) {
        let width = view.frame.size.width
        categoryBtns[previousIndex].isSelected = false
        Button.select(btn: categoryBtns[selectedCategoryIndex])
        if selectedCategoryIndex == 0 || selectedCategoryIndex == 1 || selectedCategoryIndex == 2 {
            categoryScrollView.contentOffset.x = CGFloat(0)
        } else if selectedCategoryIndex == 6 || selectedCategoryIndex == 7 || selectedCategoryIndex == 8 {
            categoryScrollView.contentOffset.x = width / 5.0 * 9.0 - width
        } else {
            categoryScrollView.contentOffset.x = CGFloat(selectedCategoryIndex - 1) * width / 10.0
        }
        scrollBar.frame.origin.x = CGFloat(selectedCategoryIndex) * width / 5.0
    }
    static func addCategoryBtn(view: UIView, categoryScrollView: UIScrollView, category: [String], scrollBar: UILabel) -> [UIButton]{
        categoryScrollView.isScrollEnabled = true
        var categoryBtns = [UIButton]()
        let width = view.frame.size.width
        // 이 함수가 호출되는 시점에서는 categoryScrollView가 320의 width로 잡혀서 전체 뷰로 잡아줌.
        categoryScrollView.contentSize.width = CGFloat(width / 5.0 * CGFloat(category.count))
        // 버튼 하나하나는 기기 가로 크기의 1 / 5
        let color = UIColor(red: CGFloat(255.0 / 255.0), green: CGFloat(120.0 / 255.0),  blue: CGFloat(0.0 / 255.0), alpha: CGFloat(1.0))
        for index in 0..<category.count {
            let categoryBtn = UIButton(frame: CGRect(x: width / 5.0 * CGFloat(index), y: 0, width: width / 5.0, height: categoryScrollView.frame.height))
            categoryBtn.setTitle(category[index], for: .normal) // 카테고리 버튼 텍스트
            let color = UIColor(red: CGFloat(102.0 / 255.0), green: CGFloat(102.0 / 255.0),  blue: CGFloat(102.0 / 255.0), alpha: CGFloat(1.0))
            categoryBtn.setTitleColor(color, for: .normal) // 카테고리 버튼 텍스트 색깔
            categoryBtn.contentHorizontalAlignment = .center // 카테고리 버튼 중앙정렬
            categoryBtn.titleLabel?.font = categoryBtn.titleLabel?.font.withSize(13) // 카테고리 버튼 폰트 크기 13
            categoryBtn.tag = index // 버튼 태그 생성해주기
            categoryBtns.append(categoryBtn)
            categoryScrollView.addSubview(categoryBtn)
        }
        scrollBar.frame = CGRect(x: 0, y: categoryScrollView.frame.height - 4, width: width / 5.0, height: 2)
        scrollBar.backgroundColor = color
        categoryScrollView.addSubview(scrollBar)
        categoryScrollView.showsHorizontalScrollIndicator = false // 스크롤 바 없애기
        return categoryBtns
    }
    static func didPressUsefulBtn(sender: UIButton, reviewId: String, usefulNumLabel: UILabel, badNumLabel: UILabel, usefulBtn: UIButton, badBtn: UIButton, reviewList: [Review]){
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        var reviewStatus = appdelegate.user?.review_like_list[reviewId]
        let uid = appdelegate.user?.id
        if reviewStatus == nil { //유용해요 누른적이 없는 리뷰
            var useful = Int(usefulNumLabel.text!)
            useful = useful! + 1
            usefulNumLabel.text = String(describing: useful!)
            DataManager.updateUsefulReview(id: reviewId, uid: uid!)
            reviewStatus = 1
            Button.makeBorder(btn: usefulBtn)
            Button.deleteBorder(btn: badBtn)
            usefulNumLabel.textColor = UIColor.red
            badNumLabel.textColor = UIColor.lightGray
        } else if reviewStatus == 1 { // 유용해요 취소
            var useful = Int(usefulNumLabel.text!)
            useful = useful! - 1
            usefulNumLabel.text = String(describing: useful!)
            DataManager.updateCancleReview(id: reviewId, uid: uid!)
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
            DataManager.updateUsefulReview(id: reviewId, uid: uid!)
            reviewStatus = 1
            Button.makeBorder(btn: usefulBtn)
            Button.deleteBorder(btn: badBtn)
            usefulNumLabel.textColor = UIColor.red
            badNumLabel.textColor = UIColor.lightGray
        } else if reviewStatus == 0 { // 별로에요 취소 했다가 다시 누르기
            var useful = Int(usefulNumLabel.text!)
            useful = useful! + 1
            usefulNumLabel.text = String(describing: useful!)
            DataManager.updateUsefulReview(id: reviewId, uid: uid!)
            reviewStatus = 1
            Button.makeBorder(btn: usefulBtn)
            Button.deleteBorder(btn: badBtn)
            usefulNumLabel.textColor = UIColor.red
            badNumLabel.textColor = UIColor.lightGray
        }
        appdelegate.user?.review_like_list[reviewId] = reviewStatus
        for i in 0..<reviewList.count {
            if reviewList[i].id == reviewId {
                reviewList[i].useful = Int(usefulNumLabel.text!)!
                reviewList[i].bad = Int(badNumLabel.text!)!
                DataManager.tabUsefulBtn(id: reviewId, useful: Int(usefulNumLabel.text!)!)
                DataManager.tabBadBtn(id: reviewId, bad: Int(badNumLabel.text!)!)
            }
        }
    }
    static func didPressBadBtn(sender: UIButton, reviewId: String, usefulNumLabel: UILabel, badNumLabel: UILabel, usefulBtn: UIButton, badBtn: UIButton, reviewList: [Review]){
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let uid = appdelegate.user?.id
        var reviewStatus = appdelegate.user?.review_like_list[reviewId]
        if reviewStatus == nil { //별로에요 누른적이 없는 리뷰
            var bad = Int(badNumLabel.text!)
            bad = bad! + 1
            badNumLabel.text = String(describing: bad!)
            DataManager.updateBadReview(id: reviewId, uid: uid!)
            reviewStatus = -1
            Button.makeBorder(btn: badBtn)
            Button.deleteBorder(btn: usefulBtn)
            usefulNumLabel.textColor = UIColor.lightGray
            badNumLabel.textColor = UIColor.red
        } else if reviewStatus == -1 { // 별로에요 취소
            var bad = Int(badNumLabel.text!)
            bad = bad! - 1
            badNumLabel.text = String(describing: bad!)
            DataManager.updateCancleReview(id: reviewId, uid: uid!)
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
            DataManager.updateBadReview(id: reviewId, uid: uid!)
            reviewStatus = -1
            Button.makeBorder(btn: badBtn)
            Button.deleteBorder(btn: usefulBtn)
            usefulNumLabel.textColor = UIColor.lightGray
            badNumLabel.textColor = UIColor.red
        } else if reviewStatus == 0 { // 별로에요 취소 했다가 다시 누르기
            var bad = Int(badNumLabel.text!)
            bad = bad! + 1
            badNumLabel.text = String(describing: bad!)
            DataManager.updateBadReview(id: reviewId, uid: uid!)
            reviewStatus = -1
            Button.makeBorder(btn: badBtn)
            Button.deleteBorder(btn: usefulBtn)
            usefulNumLabel.textColor = UIColor.lightGray
            badNumLabel.textColor = UIColor.red
        }
        appdelegate.user?.review_like_list[reviewId] = reviewStatus
        for i in 0..<reviewList.count {
            if reviewList[i].id == reviewId {
                reviewList[i].useful = Int(usefulNumLabel.text!)!
                reviewList[i].bad = Int(badNumLabel.text!)!
                DataManager.tabUsefulBtn(id: reviewId, useful: Int(usefulNumLabel.text!)!)
                DataManager.tabBadBtn(id: reviewId, bad: Int(badNumLabel.text!)!)
            }
        }
    }
    static func validateUseful(review: Review, usefulBtn: UIButton, badBtn: UIButton, usefulNumLabel: UILabel, badNumLabel: UILabel) {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        if let userReviewLike = appdelegate.user?.review_like_list[review.id]{
            if userReviewLike == 1 {
                Button.makeBorder(btn: usefulBtn)
                Button.deleteBorder(btn: badBtn)
                usefulNumLabel.textColor = UIColor.red
                badNumLabel.textColor = UIColor.lightGray
            } else if userReviewLike == -1 {
                Button.makeBorder(btn: badBtn)
                Button.deleteBorder(btn: usefulBtn)
                usefulNumLabel.textColor = UIColor.lightGray
                badNumLabel.textColor = UIColor.red
            } else {
                Button.deleteBorder(btn: usefulBtn)
                Button.deleteBorder(btn: badBtn)
                usefulNumLabel.textColor = UIColor.lightGray
                badNumLabel.textColor = UIColor.lightGray
            }
        } else {
            Button.deleteBorder(btn: usefulBtn)
            Button.deleteBorder(btn: badBtn)
            usefulNumLabel.textColor = UIColor.lightGray
            badNumLabel.textColor = UIColor.lightGray
        }
    }
}
