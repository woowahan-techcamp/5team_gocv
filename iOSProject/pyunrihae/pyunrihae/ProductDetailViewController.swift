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
    var usefulBtns = [UIButton]()
    var badBtns = [UIButton]()
    var usefulLabels = [UILabel]()
    var badLabels = [UILabel]()
    var reviewList = [Review]()
    var reviewIdList = [String]()
    var product = Product()
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        writingReviewBtn.isHidden = true
        let user = appdelegate.user
        if user?.email != "" {
            if (user?.wish_product_list.contains(SelectedProduct.foodId))!{
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
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.view.addGestureRecognizer(tap)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    @IBAction func closeNavViewBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: NSNotification.Name("reloadReview"), object: self)
    }
    @IBAction func tabWishBtn(_ sender: UIButton) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let user = appDelegate.user
        if user?.email != "" {
            uploadingView.isHidden = false
            if wishBtn.backgroundImage(for: .normal) == UIImage(named: "ic_like.png") {
                alertMessageLabel.text = "위시리스트에 추가되었습니다!"
                wishBtn.setBackgroundImage(UIImage(named: "ic_like_filled.png"), for: .normal)
                reviewUpload()
            } else if wishBtn.backgroundImage(for: .normal) == UIImage(named: "ic_like_filled.png") {
                alertMessageLabel.text = "위시리스트에서 제거되었습니다."
                wishBtn.setBackgroundImage(UIImage(named: "ic_like.png"), for: .normal)
                reviewUpload()
            }
            DataManager.updateWishList(id: SelectedProduct.foodId, uid: (user?.id)!)
        } else {
            let alert = UIAlertController(title: "로그인 후 이용해주세요!", message: "", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func didPressallergyBtn(sender: UIButton){ // 알러지 리스트 누르기
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ProductAllergyViewController") as! ProductAllergyViewController
        for product in appdelegate.productList {
            if product.id == SelectedProduct.foodId{
                vc.allergyList = product.allergy
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    func didPressUsefulBtn(sender: UIButton) { //유용해요 버튼 누르기
        if appdelegate.user?.email == "" {
            let alert = UIAlertController(title: "로그인 후 이용해주세요!", message: "", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            Button.didPressUsefulBtn(sender: sender, reviewId: reviewIdList[sender.tag], usefulNumLabel: usefulLabels[sender.tag], badNumLabel: badLabels[sender.tag], usefulBtn: usefulBtns[sender.tag], badBtn: badBtns[sender.tag], reviewList: reviewList)
        }
    }
    func didPressBadBtn(sender: UIButton) { //별로에요 버튼 누르기
        if appdelegate.user?.email == "" {
            let alert = UIAlertController(title: "로그인 후 이용해주세요!", message: "", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            Button.didPressBadBtn(sender: sender, reviewId: reviewIdList[sender.tag], usefulNumLabel: usefulLabels[sender.tag], badNumLabel: badLabels[sender.tag], usefulBtn: usefulBtns[sender.tag], badBtn: badBtns[sender.tag], reviewList: reviewList)
        }
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
    func showReviewProduct(_ notification: Notification) { // 넘어온 review 정보 받아서 화면 구성
        let product = notification.userInfo?["product"] as! Review
        print(product.p_id)
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
                self.reviewList = reviewList
                self.setReviewListOrder()
                self.reviewIdList = []
                self.usefulLabels = []
                self.badLabels = []
                self.usefulBtns = []
                self.badBtns = []
                self.tableView.reloadData()
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
    func addNotiObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(showProduct), name: NSNotification.Name("showProduct"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showReviewProduct), name: NSNotification.Name("showReviewProduct"), object: nil)
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
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let user = appDelegate.user
            if user?.email == "" {
                let alert = UIAlertController(title: "로그인 후 이용해주세요!", message: "", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            if (user?.product_review_list.contains(SelectedProduct.foodId))!{
                let alert = UIAlertController(title: "이미 리뷰한 상품입니다 :)", message: "", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) { // 밑으로 내리면 리뷰작성 버튼 사라지고, 올리면 다시 뜸
        if velocity.y > 0 {
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
            if SelectedProduct.reviewCount == 0 {
                return 3
            }
            return SelectedProduct.reviewCount + 2
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath) as! ProductInfoTableViewCell
                cell.frame.size.width = tableView.frame.size.width
                DataManager.getProductById(id: SelectedProduct.foodId) { (product) in
                    self.writingReviewBtn.isHidden = false
                    cell.priceLabel.text = product.price + "원"
                    cell.brandLabel.text = product.brand
                    cell.foodNameLabel.text = product.name
                    cell.capacityLabel.text = product.capacity
                    cell.manufacturerLabel.text = product.manufacturer
                    if product.event != "\r" { 
                        cell.eventLabel.text = product.event
                        Label.makeRoundLabel(label: cell.eventLabel, color: self.appdelegate.mainColor)
                        cell.eventLabel.textColor = self.appdelegate.mainColor
                    }else{
                        cell.eventLabel.isHidden = true
                    }
                    cell.loading.startAnimating()
                    cell.foodImage.contentMode = .scaleAspectFill
                    cell.foodImage.clipsToBounds = true
                    cell.foodImage.af_setImage(withURL: URL(string: product.image)!, placeholderImage: UIImage(), completion:{ image in
                        cell.foodImageBtn.setBackgroundImage(cell.foodImage.image, for: .normal)
                        cell.loading.stopAnimating()
                    })
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as! ProductDetailInfoTableViewCell
                // 제품 별점 보여주기
                DataManager.getProductById(id: SelectedProduct.foodId) { (product) in
                    Image.drawStar(numberOfPlaces: 2.0, grade_avg: Double(product.grade_avg), gradeLabel: cell.gradeLabel, starView: cell.starView, needSpace: true)
                    let allergyList = product.allergy
                    if allergyList.count != 0 {
                        let allergy = allergyList[0]
                        if allergyList.count == 1 {
                            cell.allergyBtn.isEnabled = false
                            cell.allergyBtn.setTitle(allergy, for: .normal)
                        } else {
                            cell.allergyBtn.isEnabled = true
                            let count = allergyList.count - 1
                            cell.allergyBtn.setTitle(allergy + " 외 " + count.description + "개의 성분 >", for: .normal)
                            cell.allergyBtn.addTarget(self, action: #selector(self.didPressallergyBtn), for: .touchUpInside)
                        }
                    } else {
                        cell.allergyBtn.isEnabled = false
                        cell.allergyBtn.setTitle("알레르기 정보가 없습니다!", for: .normal)
                    }
                    Label.showLevel(PriceLevelLabel: cell.priceLevelLabel, FlavorLevelLabel: cell.flavorLevelLabel, QuantityLevelLabel: cell.quantityLevelLabel, priceLevelDict: product.price_level, flavorLevelDict: product.flavor_level, quantityLevelDict: product.quantity_level)
                }
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ProductReviewTableViewCell
            if indexPath.row > 1 {
                cell.usefulView.layer.zPosition = 10
                cell.badView.layer.zPosition = 10
                cell.isHidden = false
                cell.uploadedFoodImageBtn.isHidden = false
                cell.detailReviewLabel.isHidden = false
                cell.detailReviewLabel.frame.origin.y = 130
                cell.commentTopConstraint.constant = 8
                Image.makeCircleImage(image: cell.userImage)
                cell.reviewBoxView.layer.cornerRadius = 10
                let row = indexPath.row - 2
                if SelectedProduct.reviewCount != 0 {
                    cell.noReviewView.isHidden = true
                }
                cell.userNameLabel.text = ""
                cell.detailReviewLabel.text = ""
                cell.usefulNumLabel.text = "0"
                cell.badNumLabel.text = "0"
                cell.userImage.image = UIImage(named: "user_default.png")
                cell.uploadedFoodImageBtn.setBackgroundImage(UIImage(), for: .normal)
                if reviewList.count == SelectedProduct.reviewCount && reviewList.count > 0 {
                    Label.showWrittenTime(timestamp: reviewList[row].timestamp, timeLabel: cell.timeLabel)
                    usefulBtns.append(cell.usefulBtn)
                    badBtns.append(cell.badBtn)
                    reviewIdList.append(reviewList[row].id)
                    usefulLabels.append(cell.usefulNumLabel)
                    badLabels.append(cell.badNumLabel)
                    cell.usefulBtn.addTarget(self, action: #selector(self.didPressUsefulBtn), for: UIControlEvents.touchUpInside)
                    cell.badBtn.addTarget(self, action: #selector(self.didPressBadBtn), for: UIControlEvents.touchUpInside)
                    cell.badNumLabel.text = String(reviewList[row].bad)
                    cell.usefulNumLabel.text = String(reviewList[row].useful)
                    Button.validateUseful(review: reviewList[row], usefulBtn: cell.usefulBtn, badBtn: cell.badBtn, usefulNumLabel: cell.usefulNumLabel, badNumLabel: cell.badNumLabel)
                    cell.detailReviewLabel.text = reviewList[row].comment
                    let height = Label.heightForView(text: reviewList[row].comment, font: cell.detailReviewLabel.font, width: cell.detailReviewLabel.frame.width)
                    cell.detailReviewLabel.frame.size.height = height
                    cell.userNameLabel.text = reviewList[row].user
                    cell.userImageLoading.startAnimating()
                    cell.usefulBtn.tag = usefulBtns.count - 1
                    cell.badBtn.tag = badBtns.count - 1
                    cell.userImage.contentMode = .scaleAspectFit
                    cell.userImage.af_setImage(withURL: URL(string: reviewList[row].user_image)!, placeholderImage: UIImage(), imageTransition: .crossDissolve(0.2), completion:{ image in
                        cell.userImageLoading.stopAnimating()
                    })
                    if reviewList[row].p_image != "" {
                        cell.reviewBoxView.frame.size.height = cell.detailReviewLabel.frame.height + 135
                        cell.uploadedImageLoading.startAnimating()
                        cell.uploadedFoodImage.contentMode = .scaleAspectFit
                        let color = UIColor(red: CGFloat(230.0 / 255.0), green: CGFloat(230.0 / 255.0),  blue: CGFloat(230.0 / 255.0), alpha: CGFloat(Float(1)))
                        cell.uploadedFoodImage.backgroundColor = color
                        cell.uploadedFoodImage.af_setImage(withURL: URL(string: reviewList[row].p_image)!, placeholderImage: UIImage(), completion:{ image in
                            cell.uploadedFoodImageBtn.setBackgroundImage(cell.uploadedFoodImage.image, for: .normal)
                            cell.uploadedImageLoading.stopAnimating()
                        })
                    } else {
                        if cell.detailReviewLabel.text == "" { // 사진 글 모두 없는 경우
                            cell.detailReviewLabel.isHidden = true
                            cell.reviewBoxView.frame.size.height = 90
                        }else { // 사진만 없는 경우
                            cell.reviewBoxView.frame.size.height = cell.detailReviewLabel.frame.height + 90
                            cell.commentTopConstraint.constant -= 60
                        }
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
            } else {
                cell.isHidden = true
            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            if indexPath.row == 0 {
                return 187
            }
        }
        return 150
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
                    let font =  UIFont(name: "AppleSDGothicNeo-Thin", size: 13)
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
                self.setReviewListOrder()
            }
        }
        let orderByPrice = UIAlertAction(title: "유용순", style: .default) { action -> Void in
            DispatchQueue.main.async {
                self.orderBy  = "유용순"
                self.setReviewListOrder()
            }
        }
        alert.addAction(cancelAction)
        alert.addAction(orderByRanking)
        alert.addAction(orderByPrice)
        present(alert, animated: true, completion: nil)
    }
    func setReviewListOrder(){
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
        }else{
            self.reviewList = reviewList.sorted(by: { $0.useful > $1.useful })
        }
        DispatchQueue.main.async {
            self.reviewIdList = []
            self.usefulLabels = []
            self.badLabels = []
            self.usefulBtns = []
            self.badBtns = []
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
