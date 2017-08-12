//
//  ProductDetailViewController.swift
//  pyunrihae
//
//  Created by woowabrothers on 2017. 8. 9..
//  Copyright © 2017년 busride. All rights reserved.
//

import UIKit
import Alamofire

class ProductDetailViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var writingReviewBtn: UIButton!
    

    @IBAction func closeNavViewBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    var orderBy = "최신순"
    var productGrade = 4.6 //임의로 넣어놧음
    var userGrade = 3 //임의로 넣어놨음
    
    func showProduct(_ notification: Notification) { // 넘어온 product 정보 받아서 화면 구성
        let product = notification.userInfo?["product"] as! Product
        SelectedProduct.foodId = product.id
        SelectedProduct.brandName = product.brand
        SelectedProduct.foodName = product.name
    }
    func showReviewProduct(_ notification: Notification) { // 넘어온 product 정보 받아서 화면 구성
        let product = notification.userInfo?["product"] as! Review
        SelectedProduct.foodId = product.p_id
        SelectedProduct.brandName = product.brand
        SelectedProduct.foodName = product.p_name
    }
    func addNotiObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(showProduct), name: NSNotification.Name("showProduct"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showReviewProduct), name: NSNotification.Name("showReviewProduct"), object: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        writingReviewBtn.layer.zPosition = 10
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension ProductDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else {
            return 5 // 리뷰 수+2로 리턴해야 함
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath) as! ProductInfoTableViewCell
                Label.makeRoundLabel(label: cell.eventLabel, color: UIColor.red)
                cell.eventLabel.textColor = UIColor.red
                Image.makeCircleImage(image: cell.foodImage)
                DataManager.getProductById(id: SelectedProduct.foodId) { (product) in
                    Alamofire.request(product.image).responseImage { response in
                        if let image = response.result.value {
                            cell.foodImage.image = image
                        }
                    }
                }
                cell.brandLabel.text = SelectedProduct.brandName
                cell.foodNameLabel.text = SelectedProduct.foodName
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as! ProductDetailInfoTableViewCell
                // 제품 별점 보여주기
                cell.gradeLabel.text = String(productGrade)
                for i in 0..<Int(productGrade) {
                    let starImage = UIImage(named: "stars.png")
                    let cgImage = starImage?.cgImage
                    let croppedCGImage: CGImage = cgImage!.cropping(to: CGRect(x: 0, y: 0, width: (starImage?.size.width)! / 5, height: starImage!.size.height))!
                    let uiImage = UIImage(cgImage: croppedCGImage)
                    let imageView = UIImageView(image: uiImage)
                    imageView.frame = CGRect(x: i*18, y: 0, width: 18, height: 15)
                    cell.starView.addSubview(imageView)
                }
                if productGrade - Double(Int(productGrade)) >= 0.5 {
                    let starImage = UIImage(named: "stars.png")
                    let cgImage = starImage?.cgImage
                    let croppedCGImage: CGImage = cgImage!.cropping(to: CGRect(x: (starImage?.size.width)! * 4 / 5, y: 0, width: (starImage?.size.width)!, height: starImage!.size.height))!
                    let uiImage = UIImage(cgImage: croppedCGImage)
                    let imageView = UIImageView(image: uiImage)
                    imageView.frame = CGRect(x: Int(productGrade)*18 - 3, y: 0, width: 18, height: 15)
                    cell.starView.addSubview(imageView)
                }
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ProductReviewTableViewCell
            if indexPath.row > 1 {
                cell.isHidden = false
                Image.makeCircleImage(image: cell.userImage)
                // 리뷰어 각각의 별점
                for i in 0..<Int(productGrade) {
                    let starImage = UIImage(named: "stars.png")
                    let cgImage = starImage?.cgImage
                    let croppedCGImage: CGImage = cgImage!.cropping(to: CGRect(x: 0, y: 0, width: (starImage?.size.width)! / 5, height: starImage!.size.height))!
                    let uiImage = UIImage(cgImage: croppedCGImage)
                    let imageView = UIImageView(image: uiImage)
                    imageView.frame = CGRect(x: i*18, y: 0, width: 18, height: 15)
                    cell.starView.addSubview(imageView)
                }
            } else {
                cell.isHidden = true
            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.section == 0{
            if indexPath.row == 0 {
                return 187
            }
            else {
                return 154
            }
        }
        else {
            if indexPath.row == 0 {
                return 0
            } else if indexPath.row == 1{
                return 0
            } else {
                return 230 // 각 리뷰 대화창 높이에 맞게 커스터마이징 해야함
            }
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let orderReviewView = UIView()
        if section == 1 {
            let headerText = UILabel()
            headerText.text = "소비자 리뷰"
            headerText.textColor = UIColor.darkGray
            headerText.frame = CGRect(x: 20, y: 10, width: 70, height: 25)
            headerText.font = UIFont.systemFont(ofSize: 14)
            orderReviewView.addSubview(headerText)
            orderReviewView.layer.backgroundColor = UIColor.white.cgColor
            
            // 소비자 리뷰 정렬 텍스트
            let orderLabel = UILabel()
            orderLabel.text = orderBy
            orderLabel.textColor = UIColor.darkGray
            orderLabel.frame = CGRect(x: 300, y: 10, width: 50, height: 25)
            orderLabel.font = UIFont.systemFont(ofSize: 13)
            orderReviewView.addSubview(orderLabel)
            
            // 소비자 리뷰 정렬 버튼
            let orderBtn = UIButton()
            orderBtn.setImage(UIImage(named: "dropdown.png"), for: .normal)
            orderBtn.frame = CGRect(x: 340, y: 17, width: 15, height: 11)
            orderBtn.addTarget(self, action: #selector(tabDropDownBtn), for: UIControlEvents.touchUpInside)
            orderReviewView.addSubview(orderBtn)
            
            // 헤더 경계선 생성
            let color = UIColor(red: CGFloat(Float(0xee) / 255.0), green: CGFloat(Float(0xee) / 255.0),  blue: CGFloat(Float(0xee) / 255.0), alpha: CGFloat(Float(1)))
            
            let topBorder = UILabel()
            topBorder.layer.backgroundColor = color.cgColor
            topBorder.frame = CGRect(x: 10, y: 0, width: 355, height: 1)
            orderReviewView.addSubview(topBorder)
            
            let bottomBorder = UILabel()
            bottomBorder.layer.backgroundColor = color.cgColor
            bottomBorder.frame = CGRect(x: 10, y: 44, width: 355, height: 1)
            orderReviewView.addSubview(bottomBorder)
        }
        return orderReviewView
    }
    func tabDropDownBtn(_ sender: UIButton) {
        let alert = UIAlertController(title: "순서 정렬하기", message: "", preferredStyle: .actionSheet)
        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            
        }
        let orderByRanking = UIAlertAction(title: "최신순", style: .default) { action -> Void in
            
        }
        
        let orderByPrice = UIAlertAction(title: "유용순", style: .destructive) { action -> Void in
            
        }
        
        alert.addAction(cancelAction)
        alert.addAction(orderByRanking)
        alert.addAction(orderByPrice)
        present(alert, animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else {
            return 45
        }
    }
}
