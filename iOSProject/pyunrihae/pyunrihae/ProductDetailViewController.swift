//
//  ProductDetailViewController.swift
//  pyunrihae
//
//  Created by woowabrothers on 2017. 8. 9..
//  Copyright © 2017년 busride. All rights reserved.
//
import UIKit
class ProductDetailViewController: UIViewController {
    @IBOutlet weak var uploadingView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var writingReviewBtn: UIButton!
    @IBOutlet weak var alertMessageLabel: UILabel!
    @IBOutlet weak var wishBtn: UIButton!
    var hidden = false
    var sortingMethodLabel = UILabel()
    var orderBy = "최신순"
    var productGrade = 0.0
    var reviewList = [Review]()
    var reviewCount: Int = 0
    var productId = ""
    var product = Product()
    var reviewUploadingNow = false
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        if User.sharedInstance.email != "" {
            if (User.sharedInstance.wish_product_list.contains(productId)){
                wishBtn.setBackgroundImage(UIImage(named: "ic_like_filled.png"), for: .normal)
            } else {
                wishBtn.setBackgroundImage(UIImage(named: "ic_like.png"), for: .normal)
            }
        } else {
            wishBtn.setBackgroundImage(UIImage(named: "ic_like.png"), for: .normal)
        }
        let titleAttributes = [
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: 16)
        ]
        self.navigationController?.navigationBar.titleTextAttributes = titleAttributes
        uploadingView.isHidden = true
        writingReviewBtn.layer.zPosition = 10
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: NSNotification.Name("complete"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reviewUpload), name: NSNotification.Name("reviewUpload"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(startUploading), name: NSNotification.Name("startUploading"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showAllergy), name: NSNotification.Name("showAllergy"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showLoginPopup), name: NSNotification.Name("showLoginPopup"), object: nil)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.view.addGestureRecognizer(tap)
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        reviewCount = 0
        reload()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
                case UISwipeGestureRecognizerDirection.right: close()
                default: break
            }
        }
    }
    func showLoginPopup(_ notification: Notification) {
        Pyunrihae.showLoginOptionPopup(_ : self)
    }
    func handleTap(_ sender: UITapGestureRecognizer) { // 탭해주면 리뷰 작성 버튼 뜸
        if hidden == true {
            writingReviewBtn.isHidden = false
            hidden = false
            UIView.animate(withDuration: 0.7, delay: 0, animations: {
                self.writingReviewBtn.frame.origin.y -= 100
            })
        }
    }
    func close() {
        self.navigationController?.popToRootViewController(animated: true)
        NotificationCenter.default.post(name: NSNotification.Name("getReviewList"), object: self)
    }
    @IBAction func closeNavViewBtn(_ sender: UIButton) {
        close()
    }
    @IBAction func tabWishBtn(_ sender: UIButton) {
        let user = User.sharedInstance
        if (user.email != "" && productId != "") {
            uploadingView.isHidden = false
            if wishBtn.backgroundImage(for: .normal) == UIImage(named: "ic_like.png") {
                if !reviewUploadingNow {
                    alertMessageLabel.text = "즐겨찾기에 추가되었습니다!"
                    reviewUpload()
                }
                wishBtn.setBackgroundImage(UIImage(named: "ic_like_filled.png"), for: .normal)
            } else if wishBtn.backgroundImage(for: .normal) == UIImage(named: "ic_like_filled.png") {
                if !reviewUploadingNow {
                    alertMessageLabel.text = "즐겨찾기에서 제거되었습니다."
                    reviewUpload()
                }
                wishBtn.setBackgroundImage(UIImage(named: "ic_like.png"), for: .normal)
            }
            DataManager.updateWishList(id: productId, uid: (user.id))
        } else {
            Pyunrihae.showLoginOptionPopup(_ : self)
        }
    }
    func showAllergy(_ notification: Notification){ // 알러지 리스트 보여주기
        let productId = notification.userInfo?["productId"] as! String
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ProductAllergyViewController") as! ProductAllergyViewController
        for product in appdelegate.productList {
            if product.id == productId{
                vc.allergyList = product.allergy
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    func reload() {
        DispatchQueue.main.async {
            DataManager.getReviewListBy(id: self.productId) { (reviewList) in
                self.setReviewListOrder(reviewList: reviewList)
                self.reviewUploadingNow = false
            }
        }
    }
    func reviewUpload() {
        uploadingView.alpha = 1
        UIView.animate(withDuration: 2.0, animations: {
            self.uploadingView.alpha = 0
        })
    }
    func startUploading(){
        alertMessageLabel.text = "리뷰 업로드 중입니다..."
        uploadingView.isHidden = false
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is BigImageViewController { // 사진 확대 화면
            let destination =  segue.destination as? BigImageViewController
            if let button = sender as? UIButton{
                if let image = button.backgroundImage(for: .normal) {
                    destination?.image = image
                }
            }
        } else if segue.destination is WritingReviewViewController { // 리뷰 작성 화면
            let user = User.sharedInstance
            if user.email == "" {
                Pyunrihae.showLoginOptionPopup(_ : self)
            } else if (user.product_review_list.contains(productId) && productId != ""){
                let alert = UIAlertController(title: "이미 리뷰한 상품입니다 :)", message: "", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                let destination =  segue.destination as! WritingReviewViewController
                destination.productId = productId
            }
        }
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) { // 밑으로 내리면 리뷰작성 버튼 사라지고, 올리면 다시 뜸
        if velocity.y >= 0 {
            if hidden == false {
                hidden = true
                UIView.animate(withDuration: 0.7, delay: 0, animations: {
                    self.writingReviewBtn.frame.origin.y += 100
                }, completion: { (complete:Bool) in
                    self.writingReviewBtn.isHidden = true
                })
            }
        } else {
            if hidden == true {
                writingReviewBtn.isHidden = false
                hidden = false
                UIView.animate(withDuration: 0.7, delay: 0, animations: {
                    self.writingReviewBtn.frame.origin.y -= 100
                })
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
            if reviewCount == 0 {
                return 3
            }
            return reviewCount + 2
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath) as! ProductInfoTableViewCell
                cell.frame.size.width = tableView.frame.size.width
                cell.setCellValue(productId: productId)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as! ProductDetailInfoTableViewCell
                // 제품 별점 보여주기
                cell.setCellValue(productId: productId)
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ProductReviewTableViewCell
            if indexPath.row > 1 {
                cell.isHidden = false
                let row = indexPath.row - 2
                if reviewCount != 0 {
                    cell.noReviewView.isHidden = true
                    if row >= 0{
                        cell.setCellValue(review: reviewList[row], reviewList: reviewList)
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
            if indexPath.row == 0 || indexPath.row == 1 {
                return 0
            } else {
                var returnHeight : CGFloat = 0.0
                if reviewList.count > 0 {
                    let row = indexPath.row - 2
                    let font =  UIFont(name: "AppleSDGothicNeo-Regular", size: 13)
                    let width = (tableView.superview?.frame.size.width)! - 110
                    let height = Label.heightForView(text: reviewList[row].comment, font: font!, width: width)
                    if reviewList[row].p_image != "" {
                        if reviewList[row].comment == "" {
                            returnHeight = 180 // 사진만 있는 경우
                        }else {
                            returnHeight = height + 170 // 사진과 글 모두 있는 경우
                        }
                    } else {
                        if reviewList[row].comment == "" {
                            returnHeight = 120 // 둘다 없는 경우
                        }else {
                            returnHeight = height + 120 // 글만 있는 경우
                        }
                    }
                } else {
                    returnHeight = 205
                }
                return returnHeight
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
            let width = tableView.superview?.frame.size.width
            // 소비자 리뷰 정렬 텍스트
            sortingMethodLabel.text = orderBy
            sortingMethodLabel.textColor = UIColor.darkGray
            sortingMethodLabel.frame = CGRect(x: width! - 73, y: 10, width: 50, height: 25)
            sortingMethodLabel.font = UIFont.systemFont(ofSize: 13)
            orderReviewView.addSubview(sortingMethodLabel)
            // 소비자 리뷰 정렬 버튼
            let orderBtn = UIButton()
            orderBtn.setImage(UIImage(named: "ic_dropdown.png"), for: .normal)
            orderBtn.frame = CGRect(x: width! - 33, y: 13, width: 15, height: 15)
            orderBtn.addTarget(self, action: #selector(tabDropDownBtn), for: UIControlEvents.touchUpInside)
            orderReviewView.addSubview(orderBtn)
            // 헤더 경계선 생성
            let color = UIColor(red: CGFloat(Float(0xee) / 255.0), green: CGFloat(Float(0xee) / 255.0),  blue: CGFloat(Float(0xee) / 255.0), alpha: CGFloat(Float(1)))
            let topBorder = UILabel()
            topBorder.layer.backgroundColor = color.cgColor
            topBorder.frame = CGRect(x: 10, y: 0, width: width! - 20, height: 1)
            orderReviewView.addSubview(topBorder)
            let bottomBorder = UILabel()
            bottomBorder.layer.backgroundColor = color.cgColor
            bottomBorder.frame = CGRect(x: 10, y: 44, width: width! - 20, height: 1)
            orderReviewView.addSubview(bottomBorder)
        }
        return orderReviewView
    }
    func tabDropDownBtn(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel)
        let orderByRanking = UIAlertAction(title: "최신순", style: .default) { action -> Void in
            DispatchQueue.main.async {
                self.orderBy  = "최신순"
                self.setReviewListOrder(reviewList: self.reviewList)
            }
        }
        let orderByPrice = UIAlertAction(title: "유용순", style: .default) { action -> Void in
            DispatchQueue.main.async {
                self.orderBy  = "유용순"
                self.setReviewListOrder(reviewList: self.reviewList)
            }
        }
        alert.addAction(cancelAction)
        alert.addAction(orderByRanking)
        alert.addAction(orderByPrice)
        present(alert, animated: true, completion: nil)
    }
    func setReviewListOrder(reviewList: [Review]){
        let format = DateFormatter()
        format.locale = Locale(identifier: "ko_kr")
        format.timeZone = TimeZone(abbreviation: "KST")
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if orderBy == "최신순"{
            self.reviewList = reviewList.sorted(by: { (review1, review2) in
                if format.date(from: review1.timestamp) != nil && format.date(from: review2.timestamp) != nil {
                    return format.date(from: review1.timestamp)! > format.date(from: review2.timestamp)!
                }else{
                    return review1.id > review2.id
                }
            })
            self.reviewCount = reviewList.count
        }else{
            self.reviewList = reviewList.sorted(by: { $0.useful > $1.useful })
            self.reviewCount = reviewList.count
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else {
            return 45
        }
    }
}
