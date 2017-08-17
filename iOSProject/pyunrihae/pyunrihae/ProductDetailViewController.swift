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
    let priceLevelList = ["비싸다","비싼편","적당","싼편","싸다"]
    let flavorLevelList = ["노맛","별로","적당","괜춘","존맛"]
    let quantityLevelList = ["창렬","적음","적당","많음","혜자"]
    var orderBy = "최신순"
    var productGrade = 0.0 //임의로 넣어놧음
    var usefulBtns = [UIButton]()
    var badBtns = [UIButton]()
    var usefulLabels = [UILabel]()
    var badLabels = [UILabel]()
    var reviewIdList = [String]()
    func didPressUsefulBtn(sender: UIButton) { //유용해요 버튼 누르기
        let index = sender.tag
        DataManager.tabUsefulBtn(id: reviewIdList[index])
        var useful = Int(usefulLabels[index].text!)
        useful = useful! + 1
        usefulLabels[index].text = String(describing: useful!)
    }
    func didPressBadBtn(sender: UIButton) { //별로에요 버튼 누르기
        let index = sender.tag
        DataManager.tabBadBtn(id: reviewIdList[index])
        var bad = Int(badLabels[index].text!)
        bad = bad! + 1
        badLabels[index].text = String(describing: bad!)
    }
    func showProduct(_ notification: Notification) { // 넘어온 product 정보 받아서 화면 구성
        let product = notification.userInfo?["product"] as! Product
        SelectedProduct.foodId = product.id
        SelectedProduct.reviewCount = 0
        DataManager.getReviewListBy(id: product.id) { (reviewList) in
            SelectedProduct.reviewCount = reviewList.count
            NotificationCenter.default.post(name: NSNotification.Name("complete"), object: self)
        }
    }
    func showReviewProduct(_ notification: Notification) { // 넘어온 product 정보 받아서 화면 구성
        let product = notification.userInfo?["product"] as! Review
        SelectedProduct.foodId = product.p_id
        SelectedProduct.reviewCount = 0
        DataManager.getReviewListBy(id: product.p_id) { (reviewList) in
            SelectedProduct.reviewCount = reviewList.count
            NotificationCenter.default.post(name: NSNotification.Name("complete"), object: self)
        }
    }
    func reload() {
        DispatchQueue.main.async {
            DataManager.getReviewListBy(id: SelectedProduct.foodId) { (reviewList) in
                SelectedProduct.reviewCount = reviewList.count
                self.usefulBtns = []
                self.badBtns = []
                self.usefulLabels = []
                self.badLabels = []
                self.reviewIdList = []
                self.tableView.reloadData()
            }
        }
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
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: NSNotification.Name("complete"), object: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is BigImageViewController {
            let destination =  segue.destination as? BigImageViewController
            if let button = sender as? UIButton{
                if let image = button.backgroundImage(for: .normal) {
                    destination?.image = image
                }
            }
        }
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
            if SelectedProduct.reviewCount == 0 {
                return 3
            }
            return SelectedProduct.reviewCount + 2 // 리뷰 수+2로 리턴해야 함
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath) as! ProductInfoTableViewCell
                DataManager.getProductById(id: SelectedProduct.foodId) { (product) in
                    cell.priceLabel.text = product.price + "원"
                    cell.brandLabel.text = product.brand
                    cell.foodNameLabel.text = product.name
                    
                    if product.event.count > 0 && product.event[0] != "\r" { //이벤트 데이터 베이스 수정 필요
                        cell.eventLabel.text = product.event[0]
                        Label.makeRoundLabel(label: cell.eventLabel, color: UIColor.red)
                        cell.eventLabel.textColor = UIColor.red
                    } else {
                        cell.eventLabel.isHidden = true
                    }
                    cell.loading.startAnimating()
                    let foodImage = UIImageView()
                    foodImage.af_setImage(withURL: URL(string: product.image)!, placeholderImage: UIImage(), completion:{ image in
                        cell.foodImageBtn.setBackgroundImage(foodImage.image, for: .normal)
                        cell.loading.stopAnimating()
                    })
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as! ProductDetailInfoTableViewCell
                // 제품 별점 보여주기
                DataManager.getProductById(id: SelectedProduct.foodId) { (product) in
                    let numberOfPlaces = 2.0
                    let multiplier = pow(10.0, numberOfPlaces)
                    self.productGrade = round(Double(product.grade_avg) * multiplier) / multiplier
                    cell.gradeLabel.text = String(self.productGrade)
                    for sub in cell.starView.subviews {
                        sub.removeFromSuperview()
                    }
                    var space = 0
                    if self.productGrade - Double(Int(self.productGrade)) >= 0.5 {
                        let starImage = UIImage(named: "stars.png")
                        let cgImage = starImage?.cgImage
                        let croppedCGImage: CGImage = cgImage!.cropping(to: CGRect(x: (starImage?.size.width)! * 4 / 5, y: 0, width: (starImage?.size.width)!, height: starImage!.size.height))!
                        let uiImage = UIImage(cgImage: croppedCGImage)
                        let imageView = UIImageView(image: uiImage)
                        space = (4 - Int(self.productGrade)) * 15
                        
                        imageView.frame = CGRect(x: Int(self.productGrade)*18 - 3 + space, y: 0, width: 18, height: 15)
                        cell.starView.addSubview(imageView)
                    } else{
                        space = (5 - Int(self.productGrade)) * 15
                    }
                    for i in 0..<Int(self.productGrade) {
                        let starImage = UIImage(named: "stars.png")
                        let cgImage = starImage?.cgImage
                        let croppedCGImage: CGImage = cgImage!.cropping(to: CGRect(x: 0, y: 0, width: (starImage?.size.width)! / 5, height: starImage!.size.height))!
                        let uiImage = UIImage(cgImage: croppedCGImage)
                        let imageView = UIImageView(image: uiImage)
                        imageView.frame = CGRect(x: i*18 + space, y: 0, width: 18, height: 15)
                        cell.starView.addSubview(imageView)
                    }
                    let allergyList = product.allergy
                    if allergyList.count != 0 {
                        let allergy = allergyList[0]
                        if allergyList.count == 1 {
                            cell.allergyBtn.isEnabled = false
                            cell.allergyBtn.setTitle(allergy, for: .normal)
                        } else {
                            cell.allergyBtn.isEnabled = true
                            let count = allergyList.count - 1
                            cell.allergyBtn.setTitle(allergy + "외 " + count.description + "개의 성분 >", for: .normal)
                        }
                    } else {
                        cell.allergyBtn.isEnabled = false
                        cell.allergyBtn.setTitle("알레르기 정보가 없습니다!", for: .normal)
                    }
                    let priceLevelDict = product.price_level
                    let flavorLevelDict = product.flavor_level
                    let quantityLevelDict = product.quantity_level
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
                        if priceLevelDict[p]! > maxPriceNum {
                            maxPriceLevel = i
                            maxPriceNum = priceLevelDict[p]!
                        }
                        if flavorLevelDict[f]! > maxFlavorNum {
                            maxFlavorLevel = i
                            maxFlavorNum = flavorLevelDict[f]!
                        }
                        if quantityLevelDict[q]! > maxQuantityNum {
                            maxQuantityLevel = i
                            maxQuantityNum = quantityLevelDict[q]!
                        }
                     }
                    cell.priceLevelLabel.text = self.priceLevelList[maxPriceLevel - 1]
                    cell.flavorLevelLabel.text = self.flavorLevelList[maxFlavorLevel - 1]
                    cell.quantityLevelLabel.text = self.quantityLevelList[maxQuantityLevel - 1]
                }
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ProductReviewTableViewCell
            if indexPath.row > 1 {
                cell.isHidden = false
                Image.makeCircleImage(image: cell.userImage)
                cell.reviewBoxView.layer.cornerRadius = 10
                let row = indexPath.row - 2
                if SelectedProduct.reviewCount != 0 {
                    cell.noReviewView.isHidden = true
                }
                DataManager.getReviewListBy(id: SelectedProduct.foodId) { (reviewList) in
                    if reviewList.count == SelectedProduct.reviewCount && reviewList.count > 0 {
                        cell.usefulBtn.tag = row
                        cell.badBtn.tag = row
                        self.usefulBtns.append(cell.usefulBtn)
                        self.badBtns.append(cell.badBtn)
                        self.reviewIdList.append(reviewList[row].id)
                        self.usefulLabels.append(cell.usefulNumLabel)
                        self.badLabels.append(cell.badNumLabel)
                        cell.usefulBtn.addTarget(self, action: #selector(self.didPressUsefulBtn), for: UIControlEvents.touchUpInside)
                        cell.badBtn.addTarget(self, action: #selector(self.didPressBadBtn), for: UIControlEvents.touchUpInside)
                        cell.badNumLabel.text = String(reviewList[row].bad)
                        cell.usefulNumLabel.text = String(reviewList[row].useful)
                        cell.detailReviewLabel.text = reviewList[row].comment
                        cell.userNameLabel.text = reviewList[row].user
                        cell.userImageLoading.startAnimating()
                        cell.userImage.af_setImage(withURL: URL(string: reviewList[row].user_image)!, placeholderImage: UIImage(), imageTransition: .crossDissolve(0.2), completion:{ image in
                            cell.userImageLoading.stopAnimating()
                        })
                        
                        if reviewList[row].p_image != "" {
                            cell.uploadedImageLoading.startAnimating()
                            let imageView = UIImageView()
                            imageView.af_setImage(withURL: URL(string: reviewList[row].p_image)!, placeholderImage: UIImage(), completion:{ image in
                                cell.uploadedFoodImageBtn.setBackgroundImage(imageView.image, for: .normal)
                                cell.uploadedImageLoading.stopAnimating()
                            })
                        } else {
                            cell.uploadedFoodImageBtn.isHidden = true
                        }
                        
                        for sub in cell.starView.subviews {
                            sub.removeFromSuperview()
                        }
                        
                        // 리뷰어 각각의 별점
                        for i in 0..<Int(reviewList[row].grade) {
                            let starImage = UIImage(named: "stars.png")
                            let cgImage = starImage?.cgImage
                            let croppedCGImage: CGImage = cgImage!.cropping(to: CGRect(x: 0, y: 0, width: (starImage?.size.width)! / 5, height: starImage!.size.height))!
                            let uiImage = UIImage(cgImage: croppedCGImage)
                            let imageView = UIImageView(image: uiImage)
                            imageView.frame = CGRect(x: i*18, y: 0, width: 18, height: 15)
                            cell.starView.addSubview(imageView)
                        }
                    }
                    
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
