//
//  WritingReviewViewController.swift
//  pyunrihae
//
//  Created by woowabrothers on 2017. 8. 9..
//  Copyright © 2017년 busride. All rights reserved.
//

import UIKit

class WritingReviewViewController: UIViewController {

    @IBAction func startEditing(_ sender: UITextField) {
        
        UIView.animate(withDuration: 1.5, delay: 0.0, usingSpringWithDamping: 5.0, initialSpringVelocity: 5.0, options: UIViewAnimationOptions.curveEaseInOut, animations: ({
            self.scrollView.frame.origin.y -= 389
        }), completion: nil)
        
        addedImageView.isHidden = true
    }
    @IBOutlet weak var detailReview: UITextField!
    
    @IBOutlet weak var reviewTextView: UIView!
    @IBAction func endEditing(_ sender: Any) {
        UIView.animate(withDuration: 1.5, delay: 0.0, usingSpringWithDamping: 5.0, initialSpringVelocity: 5.0, options: UIViewAnimationOptions.curveEaseInOut, animations: ({
            self.scrollView.frame.origin.y += 389
        }), completion: nil)
        
        addedImageView.isHidden = false
    }
    @IBOutlet weak var addedImageView: UIView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var starView: UIView!
    @IBOutlet weak var priceLevelView: UIView!
    @IBOutlet weak var flavorLevelView: UIView!
    @IBOutlet weak var quantityLevelView: UIView!
    @IBAction func tabBackBtn(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func tabCompleteBtn(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    @IBOutlet weak var scrollView: UIScrollView!
    
    let priceLevel = ["비싸다","비싼편","적당","싼편","싸다"]
    let flavorLevel = ["노맛","별로","적당","괜춘","존맛"]
    let quantityLevel = ["창렬","적음","적당","많음","혜자"]
    var allergy = [String]()
    var starBtns = [UIButton]()
    var priceLevelBtns = [UIButton]()
    var flavorLevelBtns = [UIButton]()
    var quantityLevelBtns = [UIButton]()
    func addStarBtn() { //별 버튼 뷰에 붙이기
        for i in 0..<5 {
            let starBtn = UIButton()
            starBtn.frame = CGRect(x: i*45, y: 0, width: 25, height: 25)
            Button.changeColor(btn: starBtn, color: UIColor.lightGray, imageName: "star.png")
            starBtn.addTarget(self, action: #selector(didPressStarBtn), for: UIControlEvents.touchUpInside)
            starBtn.tag = i
            starBtns.append(starBtn)
            starView.addSubview(starBtn)
        }
    }
    func addPriceLevelBtn() { //가격 레벨 버튼 뷰에 붙이기
        for i in 0..<5 {
            let priceLevelBtn = UIButton()
            priceLevelBtn.frame = CGRect(x: i*70, y: 0, width: 50, height: 25)
            Button.makeNormalBtn(btn: priceLevelBtn, text: priceLevel[i])
            priceLevelBtn.addTarget(self, action: #selector(didPressPriceLevelBtn), for: UIControlEvents.touchUpInside)
            priceLevelBtn.tag = i
            priceLevelBtns.append(priceLevelBtn)
            priceLevelView.addSubview(priceLevelBtn)
        }
    }
    func addFlavorLevelBtn() { //맛 레벨 버튼 뷰에 붙이기
        for i in 0..<5 {
            let flavorLevelBtn = UIButton()
            flavorLevelBtn.frame = CGRect(x: i*70, y: 0, width: 50, height: 25)
            Button.makeNormalBtn(btn: flavorLevelBtn, text: flavorLevel[i])
            flavorLevelBtn.addTarget(self, action: #selector(didPressFlavorLevelBtn), for: UIControlEvents.touchUpInside)
            flavorLevelBtn.tag = i
            flavorLevelBtns.append(flavorLevelBtn)
            flavorLevelView.addSubview(flavorLevelBtn)
        }
    }
    func addQuantityLevelBtn() { //양 레벨 버튼 뷰에 붙이기
        for i in 0..<5 {
            let quantityLevelBtn = UIButton()
            quantityLevelBtn.frame = CGRect(x: i*70, y: 0, width: 50, height: 25)
            Button.makeNormalBtn(btn: quantityLevelBtn, text: quantityLevel[i])
            quantityLevelBtn.addTarget(self, action: #selector(didPressQuantityLevelBtn), for: UIControlEvents.touchUpInside)
            quantityLevelBtn.tag = i
            quantityLevelBtns.append(quantityLevelBtn)
            quantityLevelView.addSubview(quantityLevelBtn)
        }
    }
    func didPressStarBtn (sender: UIButton) { //별 버튼 눌렸을 떄 별 색깔 채워주기
        for i in 0...sender.tag {
            Button.changeColor(btn: starBtns[i], color: UIColor.orange, imageName: "star.png")
        }
        for i in (sender.tag + 1)..<5 {
            Button.changeColor(btn: starBtns[i], color: UIColor.lightGray, imageName: "star.png")
        }
    }
    func didPressPriceLevelBtn (sender: UIButton) { // 가격 레벨 버튼 눌렸을 때
        for i in 0..<5 {
            Button.makeDeselectedBtn(btn: priceLevelBtns[i])
        }
        Button.makeSelectedBtn(btn: sender)
    }
    func didPressFlavorLevelBtn (sender: UIButton) { // 맛 레벨 버튼 눌렸을 때
        for i in 0..<5 {
            Button.makeDeselectedBtn(btn: flavorLevelBtns[i])
        }
        Button.makeSelectedBtn(btn: sender)
    }
    func didPressQuantityLevelBtn (sender: UIButton) { // 양 레벨 버튼 눌렸을 때
        for i in 0..<5 {
            Button.makeDeselectedBtn(btn: quantityLevelBtns[i])
        }
        Button.makeSelectedBtn(btn: sender)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.isScrollEnabled = true
        addStarBtn()
        addPriceLevelBtn()
        addFlavorLevelBtn()
        addQuantityLevelBtn()
        Image.makeCircleImage(image: productImage)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
