//
//  WritingReviewViewController.swift
//  pyunrihae
//
//  Created by woowabrothers on 2017. 8. 9..
//  Copyright © 2017년 busride. All rights reserved.
//
import UIKit
import FirebaseDatabase
import Fusuma
import FirebaseAuth
class WritingReviewViewController: UIViewController, FusumaDelegate{
    @IBOutlet weak var completeBtn: UIButton!
    @IBOutlet weak var barBtn: UIButton!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var reviewTextView: UIView!
    @IBOutlet weak var detailReview: UITextView!
    @IBOutlet weak var placeholder: UILabel!
    @IBOutlet weak var addedImageView: UIView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var addImageBtn: UIButton!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var allergyListLabel: UILabel!
    @IBOutlet weak var starView: UIView!
    @IBOutlet weak var priceLevelView: UIView!
    @IBOutlet weak var flavorLevelView: UIView!
    @IBOutlet weak var quantityLevelView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    var reviewImage = UIImage()
    var checkGrade = false
    var checkPriceLevel = false
    var checkFlavorLevel = false
    var checkQuantityLevel = false
    var grade = 0
    var priceLevel = 0
    var flavorLevel = 0
    var quantityLevel = 0
    var allergy = [String]()
    var starBtns = [UIButton]()
    var priceLevelBtns = [UIButton]()
    var flavorLevelBtns = [UIButton]()
    var quantityLevelBtns = [UIButton]()
    var productId = ""
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addDoneButtonOnKeyboard()
        addImageBtn.layer.zPosition = 10
        scrollView.isScrollEnabled = true
        addStarBtn()
        addPriceLevelBtn()
        addFlavorLevelBtn()
        addQuantityLevelBtn()
        Image.makeCircleImage(image: productImage)
        loading.startAnimating()
        DataManager.getProductById(id: productId) { (product) in
            self.productNameLabel.text = product.name
            self.brandLabel.text = product.brand
            self.priceLabel.text = product.price + "원"
            self.productImage.af_setImage(withURL: URL(string: product.image)!, placeholderImage: UIImage(), imageTransition: .crossDissolve(0.2), completion:{ image in
                self.loading.stopAnimating()
            })
        }
        detailReview.layer.borderWidth = 0.7
        detailReview.layer.borderColor = UIColor.lightGray.cgColor
        detailReview.layer.cornerRadius = 5
        detailReview.clipsToBounds = true
        detailReview.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(chooseImage), name: NSNotification.Name("chooseImage"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showAllergyList), name: NSNotification.Name("selectAllergy"), object: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func tabBackBtn(_ sender: UIButton) {
        let productDetailViewController = self.navigationController?.viewControllers[1] as! ProductDetailViewController
        self.navigationController?.popToViewController(productDetailViewController, animated: true)
    }
    @IBAction func tabCompleteBtn(_ sender: UIButton) {
         var user_image = ""
        if User.sharedInstance.user_profile != "" {
            user_image = (User.sharedInstance.user_profile)
        }else{
            user_image = "http://item.kakaocdn.net/dw/4407092.title.png"
        }
        if checkGrade && checkPriceLevel && checkFlavorLevel && checkQuantityLevel {
            if detailReview.text.characters.count > 500 {
                let alert = UIAlertController(title: "알림", message: "500자 이내로 리뷰를 작성해주세요!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                let productDetailViewController = self.navigationController?.viewControllers[1] as! ProductDetailViewController
                self.navigationController?.popToViewController(productDetailViewController, animated: true)
                NotificationCenter.default.post(name: NSNotification.Name("startUploading"), object: self)
                User.sharedInstance.product_review_list.append(productId)
                DataManager.updateReviewList(id: productId, uid: (User.sharedInstance.id))
                DataManager.getProductById(id: productId) { (product) in
                    DataManager.getUserFromUID(uid: (Auth.auth().currentUser?.uid)!, completion: { (user) in
                        let userNickName =  user.nickname
                        DataManager.writeReview(brand: product.brand, category: product.category, grade: self.grade, priceLevel: self.priceLevel, flavorLevel: self.flavorLevel, quantityLevel: self.quantityLevel, allergy: self.allergy, review: self.detailReview.text, user: userNickName, user_image: user_image, p_id: product.id, p_image: self.reviewImage, product_image: product.image, p_name: product.name, p_price: Int(product.price)!){
                        }
                    })
                }
                DataManager.getProductById(id: productId) { (product) in
                    DataManager.updateProductInfo(p_id: product.id, grade: self.grade, priceLevel: self.priceLevel, flavorLevel: self.flavorLevel, quantityLevel: self.quantityLevel, allergy: self.allergy)
                }
            }
        } else {
            let alert = UIAlertController(title: "리뷰를 완성해주세요!", message: "\r별점 및 상세 평점을 모두 채워주세요 :)", preferredStyle: .alert)
            //Create and add the Cancel action
            let okAction: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
    }
    @IBAction func addImageBtn(_ sender: UIButton) {
        let fusuma = FusumaViewController()
        fusuma.delegate = self
        fusuma.cropHeightRatio = 0.7
        fusuma.defaultMode = .library
        fusuma.allowMultipleSelection = false
        fusumaSavesImage = false
        self.present(fusuma, animated: true, completion: nil)
    }
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode) {
        let imageView = UIImageView()
        reviewImage = image
        imageView.image = reviewImage
        imageView.frame = CGRect(origin: CGPoint(x: 0 ,y: 0), size: addedImageView.frame.size)
        imageView.layer.cornerRadius = 7
        imageView.clipsToBounds = true
        addedImageView.addSubview(imageView)
        addImageBtn.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        addImageBtn.layer.cornerRadius = 7
        addImageBtn.clipsToBounds = true
        addImageBtn.setTitle("사진 변경", for: .normal)
    }
    func fusumaMultipleImageSelected(_ images: [UIImage], source: FusumaMode) {
    }
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode, metaData: ImageMetadata) {
    }
    func fusumaVideoCompleted(withFileURL fileURL: URL) {
    }
    func fusumaDismissedWithImage(_ image: UIImage, source: FusumaMode) {
    }
    func fusumaCameraRollUnauthorized() {
        let alert = UIAlertController(title: "Access Requested",
                                      message: "Saving image needs to access your photo album",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Settings", style: .default))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        guard let vc = UIApplication.shared.delegate?.window??.rootViewController,
            let presented = vc.presentedViewController else {
                return
        }
        presented.present(alert, animated: true, completion: nil)
    }
    func addStarBtn() { //별 버튼 뷰에 붙이기
        for i in 0..<5 {
            let starBtn = UIButton()
            let startImg = UIImage(named: "ic_star.png")
            starBtn.frame = CGRect(x: i*45, y: 0, width: 24, height: 24)
            starBtn.setImage(startImg, for: .normal)
            starBtn.addTarget(self, action: #selector(didPressStarBtn), for: UIControlEvents.touchUpInside)
            starBtn.tag = i
            starBtns.append(starBtn)
            starView.addSubview(starBtn)
        }
    }
    func addPriceLevelBtn() { //가격 레벨 버튼 뷰에 붙이기
        let width = Int((self.view?.frame.size.width)!)
        for i in 0..<5 {
            let priceLevelBtn = UIButton()
            priceLevelBtn.frame = CGRect(x: (i * width / 15 * 2) + (width / 15 * i), y: 0, width: width / 7, height: 25)
            Button.makeNormalBtn(btn: priceLevelBtn, text: appdelegate.priceLevelList[i])
            priceLevelBtn.addTarget(self, action: #selector(didPressPriceLevelBtn), for: UIControlEvents.touchUpInside)
            priceLevelBtn.tag = i
            priceLevelBtns.append(priceLevelBtn)
            priceLevelView.addSubview(priceLevelBtn)
        }
    }
    func addFlavorLevelBtn() { //맛 레벨 버튼 뷰에 붙이기
        let width = Int((self.view?.frame.size.width)!)
        for i in 0..<5 {
            let flavorLevelBtn = UIButton()
            flavorLevelBtn.frame = CGRect(x: (i * width / 15 * 2) + (width / 15 * i), y: 0, width: width / 7, height: 25)
            Button.makeNormalBtn(btn: flavorLevelBtn, text: appdelegate.flavorLevelList[i])
            flavorLevelBtn.addTarget(self, action: #selector(didPressFlavorLevelBtn), for: UIControlEvents.touchUpInside)
            flavorLevelBtn.tag = i
            flavorLevelBtns.append(flavorLevelBtn)
            flavorLevelView.addSubview(flavorLevelBtn)
        }
    }
    func addQuantityLevelBtn() { //양 레벨 버튼 뷰에 붙이기
        let width = Int((self.view?.frame.size.width)!)
        for i in 0..<5 {
            let quantityLevelBtn = UIButton()
            quantityLevelBtn.frame = CGRect(x: (i * width / 15 * 2) + (width / 15 * i), y: 0, width: width / 7, height: 25)
            Button.makeNormalBtn(btn: quantityLevelBtn, text: appdelegate.quantityLevelList[i])
            quantityLevelBtn.addTarget(self, action: #selector(didPressQuantityLevelBtn), for: UIControlEvents.touchUpInside)
            quantityLevelBtn.tag = i
            quantityLevelBtns.append(quantityLevelBtn)
            quantityLevelView.addSubview(quantityLevelBtn)
        }
    }
    func didPressStarBtn (sender: UIButton) { //별 버튼 눌렸을 떄 별 색깔 채워주기
        for i in 0...sender.tag {
            let startImg = UIImage(named: "ic_star_filled.png")
            starBtns[i].setImage(startImg, for: .normal)
        }
        for i in (sender.tag + 1)..<5 {
            let startImg = UIImage(named: "ic_star.png")
            starBtns[i].setImage(startImg, for: .normal)
        }
        grade = sender.tag + 1
        checkGrade = true
    }
    func didPressPriceLevelBtn (sender: UIButton) { // 가격 레벨 버튼 눌렸을 때
        for i in 0..<5 {
            Button.makeDeselectedBtn(btn: priceLevelBtns[i])
        }
        Button.makeSelectedBtn(btn: sender)
        priceLevel = sender.tag + 1
        checkPriceLevel = true
    }
    func didPressFlavorLevelBtn (sender: UIButton) { // 맛 레벨 버튼 눌렸을 때
        for i in 0..<5 {
            Button.makeDeselectedBtn(btn: flavorLevelBtns[i])
        }
        Button.makeSelectedBtn(btn: sender)
        flavorLevel = sender.tag + 1
        checkFlavorLevel = true
    }
    func didPressQuantityLevelBtn (sender: UIButton) { // 양 레벨 버튼 눌렸을 때
        for i in 0..<5 {
            Button.makeDeselectedBtn(btn: quantityLevelBtns[i])
        }
        Button.makeSelectedBtn(btn: sender)
        quantityLevel = sender.tag + 1
        checkQuantityLevel = true
    }
    func chooseImage(_ notification: Notification) { // 선택된 이미지 보여주기
        reviewImage = notification.userInfo?["image"] as! UIImage
        let imageView = UIImageView(image: reviewImage)
        imageView.frame = CGRect(origin: CGPoint(x: 0 ,y: 0), size: addedImageView.frame.size)
        imageView.layer.cornerRadius = 7
        imageView.clipsToBounds = true
        addedImageView.addSubview(imageView)
        addImageBtn.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        addImageBtn.layer.cornerRadius = 7
        addImageBtn.clipsToBounds = true
        addImageBtn.setTitle("사진 변경", for: .normal)
    }
     func showAllergyList(_ notification: Notification) { // 선택된 알레르기 성분 보여주기
        allergy = notification.userInfo?["allergy"] as! [String]
        let allergyNum = allergy.count
        if allergyNum == 0 {
            allergyListLabel.text = "알레르기 성분을 선택해주세요."
        } else if allergyNum == 1 {
            allergyListLabel.text = allergy[0]
        } else {
            allergyListLabel.text = allergy[0] + " 외 " + String(allergyNum - 1) + "개의 성분"
        }
    }
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle = UIBarStyle.blackTranslucent
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(WritingReviewViewController.doneButtonAction))
        let items = NSMutableArray()
        items.add(flexSpace)
        items.add(done)
        doneToolbar.items = items as? [UIBarButtonItem]
        doneToolbar.sizeToFit()
        self.detailReview.inputAccessoryView = doneToolbar
    }
    func doneButtonAction() {
        self.detailReview.resignFirstResponder()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is AllergyViewController {
            let destination =  segue.destination as? AllergyViewController
            destination?.selectedAllergy = allergy
        }
    }
}
extension WritingReviewViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 3.0, initialSpringVelocity: 3.0, options: UIViewAnimationOptions.curveEaseInOut, animations: ({
            self.scrollView.frame.origin.y = self.scrollView.contentOffset.y - 350
            self.detailReview.frame.size.height = UIScreen.main.bounds.size.height * 3 / 11
        }), completion: nil)
        addedImageView.isHidden = true
        placeholder.isHidden = true
        barBtn.isHidden = true
        completeBtn.isHidden = true
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 3.0, initialSpringVelocity: 3.0, options: UIViewAnimationOptions.curveEaseInOut, animations: ({
            self.scrollView.frame.origin.y = 0
        }), completion: nil)
        addedImageView.isHidden = false
        barBtn.isHidden = false
        completeBtn.isHidden = false
        var frameRect = detailReview.frame
        frameRect.size.height = 30
        detailReview.frame = frameRect
        if detailReview.text == "" {
            placeholder.isHidden = false
        }
    }
}
