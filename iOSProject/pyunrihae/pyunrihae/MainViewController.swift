//
//  MainViewController.swift
//  pyunrihae
//
//  Created by woowabrothers on 2017. 8. 4..
//  Copyright © 2017년 busride. All rights reserved.
//
import UIKit
class MainViewController: UIViewController {
    @IBOutlet weak var reviewScrollView: UIScrollView!
    @IBOutlet weak var categoryScrollView: UIScrollView!
    @IBOutlet weak var productScrollView: UIScrollView!
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    var productList : [Product] = []
    var reviewList : [Review] = []
    var review = Review()
    var actInd: UIActivityIndicatorView = UIActivityIndicatorView()
    var categoryBtns = [UIButton]()
    var scrollBar = UILabel()
    var usefulNumLabel = UILabel()
    var badNumLabel = UILabel()
    var usefulBtn = UIButton()
    var badBtn = UIButton()
    var popup = ReviewPopupView()
    var selectedBrandIndexFromTab : Int = 0 {
        didSet{
            getProductList()
            setReviewScrollImages()
        }
    }
    var selectedCategoryIndex: Int = 0 { // 선택된 카테고리 인덱스, 초기값은 0 (전체)
        didSet{
            getProductList()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Notification Observer
        NotificationCenter.default.addObserver(self, selector: #selector(getProductList), name: NSNotification.Name("productListChanged"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(selectCategory), name: NSNotification.Name("selectCategory"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showDetailProduct), name: NSNotification.Name("showDetailProduct"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showLoginPopup), name: NSNotification.Name("showLoginPopup"), object: nil)
        categoryScrollView.backgroundColor = UIColor.white
        addCategoryBtn() // 카테고리 버튼 만들어서 스크롤 뷰에 붙이기
        Button.select(btn: categoryBtns[selectedCategoryIndex]) // 맨 처음 카테고리는 전체 선택된 것으로 나타나게 함
        didPressCategoryBtn(sender: categoryBtns[selectedCategoryIndex])
        reviewScrollView.backgroundColor = UIColor.lightGray
        reviewScrollView.isPagingEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        reviewScrollView.addGestureRecognizer(tap)
        reviewScrollView.isUserInteractionEnabled = true

        DataManager.getTop3Product() { (products) in
            self.productList = products
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: NSNotification.Name("doneLoading"), object: self)
//                self.collectionView.reloadData()
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func showLoginPopup(_ notification: Notification) {
        Pyunrihae.showLoginOptionPopup(_ : self)
    }
    func showDetailProduct(_ notification: Notification) {
        if notification.userInfo?["validator"] as! Int == 0{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ProductDetailViewController") as! ProductDetailViewController
            self.navigationController?.pushViewController(vc, animated: true)
            vc.productId = review.p_id
        }
    }
    // 카테고리 버튼 스크롤 뷰에 추가하기
    func addCategoryBtn(){
        categoryBtns = Button.addCategoryBtn(view: self.view, categoryScrollView: categoryScrollView, category: appdelegate.category, scrollBar: scrollBar)
        for i in 0..<categoryBtns.count {
            categoryBtns[i].addTarget(self, action: #selector(didPressCategoryBtn), for: UIControlEvents.touchUpInside)
        }
    }
    // 카테고리 버튼 클릭 이벤트 함수
    func didPressCategoryBtn(sender: UIButton) {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut,animations: {
            Button.selectCategory(view: self.view, previousIndex: self.selectedCategoryIndex, categoryBtns: self.categoryBtns, selectedCategoryIndex: sender.tag, categoryScrollView: self.categoryScrollView, scrollBar: self.scrollBar)
            self.selectedCategoryIndex = sender.tag
        },completion: nil)
        NotificationCenter.default.post(name: NSNotification.Name("showCategory"), object: self, userInfo: ["category" : selectedCategoryIndex])
        productScrollView.contentOffset.x = 0
    }
    // 카테고리를 선택했을 때 함수
    func selectCategory(_ notification: Notification){
        popup.tabView(self)
        Button.selectCategory(view: self.view, previousIndex: selectedCategoryIndex, categoryBtns: categoryBtns, selectedCategoryIndex: notification.userInfo?["category"] as! Int, categoryScrollView: categoryScrollView, scrollBar: scrollBar)
        selectedCategoryIndex = notification.userInfo?["category"] as! Int
        productScrollView.contentOffset.x = 0
    }
    // 로딩 인디케이터 보이는 함수 DEPRECATED
    func showActivityIndicatory() {
        self.actInd.frame = CGRect.init(x: 0.0, y: 0.0, width: 40.0, height: 40.0)
        self.actInd.center = view.superview?.center ?? view.center
        self.actInd.hidesWhenStopped = true
        self.actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(actInd)
        actInd.startAnimating()
    }
    // 로딩 인디케이터 숨기는 함수 DEPRECATED
    func hideActivityIndicatory() {
        if view.subviews.contains(actInd){
            actInd.stopAnimating()
            view.willRemoveSubview(actInd)
        }
    }
    // productList를 받아오는 함수
    func getProductList(){
        var brand = ""
        switch selectedBrandIndexFromTab {
        case 0 : brand = ""
        case 1 : brand = "GS25"
        case 2 : brand = "CU"
        case 3 : brand = "7-eleven"
        default : break
        }
        self.showActivityIndicatory()
        if selectedBrandIndexFromTab == 0  && selectedCategoryIndex == 0 { // 브랜드 : 전체 , 카테고리 : 전체 일때
            if self.appdelegate.productList.count > 0 { // global product list가 저장된 후
                self.productList = self.appdelegate.productList
                DispatchQueue.main.async {
                    self.setProductScrollView()
                    self.hideActivityIndicatory()
                }
            }else{ // global product list가 없다면
                DataManager.getTop3Product() { (products) in
                    self.productList = products
                    DispatchQueue.main.async {
                        self.setProductScrollView()
                        self.hideActivityIndicatory()
                    }
                }
            }
        } else if selectedBrandIndexFromTab == 0 { // 브랜드만 전체일 때
            if categoryBtns.count > 0 {
                self.productList = []
                for product in self.appdelegate.productList {
                    if product.category == categoryBtns[selectedCategoryIndex].titleLabel?.text!{
                        self.productList.append(product)
                    }
                }
                DispatchQueue.main.async {
                    self.setProductScrollView()
                    self.hideActivityIndicatory()
                }
            }
        } else if selectedCategoryIndex == 0 { // 카테고리만 전체일 때
            self.productList = []
            for product in self.appdelegate.productList {
                if product.brand == brand{
                    self.productList.append(product)
                }
            }
            DispatchQueue.main.async {
                self.setProductScrollView()
                self.hideActivityIndicatory()
            }
        } else { // 브랜드도 카테고리도 전체가 아닐 때
            if categoryBtns.count > 0 {
                self.productList = []
                for product in self.appdelegate.productList {
                    if product.brand == brand && product.category == categoryBtns[selectedCategoryIndex].titleLabel?.text!{
                        self.productList.append(product)
                    }
                }
                DispatchQueue.main.async {
                    self.setProductScrollView()
                    self.hideActivityIndicatory()
                }
            }
        }
    }
    // 리뷰의 스크롤 이미지를 가져오는 함수
    func setReviewScrollImages(){
        
        var brand = ""
        switch selectedBrandIndexFromTab {
            case 0 : brand = "전체"
            case 1 : brand = "GS25"
            case 2 : brand = "CU"
            case 3 : brand = "7-eleven"
            default : break
        }
        DataManager.getTop3ReviewByBrand(brand: brand) { (reviews) in
            self.reviewList = reviews
            if self.reviewScrollView != nil {
                let imageViewWidth = self.reviewScrollView.frame.size.width;
                let imageViewHeight = self.reviewScrollView.frame.size.height;
                var xPosition:CGFloat = 0;
                var scrollViewSize:CGFloat=0
                var cnt = 0
                let scrollViewImageNum = 3
                self.reviewScrollView.contentSize = CGSize(width: imageViewWidth*CGFloat(3), height: imageViewHeight)
                self.reviewScrollView.contentOffset.y = 0
                for review in self.reviewList {
                    if cnt >= scrollViewImageNum {
                        break
                    }
                    let url = URL(string: review.p_image)
                    let reviewView = MainReviewView.instanceFromNib()
                    reviewView.translatesAutoresizingMaskIntoConstraints = true
                    reviewView.frame = CGRect(x: xPosition, y: 0, width: imageViewWidth, height: imageViewHeight)
                    let myImageView = reviewView.myImageView
                    let brandLabel =  reviewView.brandLabel
                    let nameLabel =  reviewView.nameLabel
                    let reviewLabel = reviewView.reviewLabel
                    let hotReviewLabel = reviewView.hotReviewLabel
                    let selectedCountLabel = reviewView.selectedCountLabel
                    let totalCountLabel = reviewView.totalCountLabel
                    let starImageView = reviewView.starImageView
                    // 기본이미지 있어야함
                    if url != nil {
                        myImageView?.af_setImage(withURL: url!)
                    }else{
                        myImageView?.af_setImage(withURL: URL(string: "https://firebasestorage.googleapis.com/v0/b/pyeonrehae.appspot.com/o/ic_background_default.png?alt=media&token=09d05950-5f8a-4a73-95b3-a74faee4cad3")!)
                    }
                    myImageView?.contentMode = UIViewContentMode.scaleAspectFill
                    brandLabel?.text = review.brand
                    nameLabel?.text = review.p_name
                    if imageViewWidth < 375 {
                        hotReviewLabel?.layer.cornerRadius = 12
                    }else if imageViewWidth > 1024{
                        hotReviewLabel?.layer.cornerRadius = 20
                    }else{
                         hotReviewLabel?.layer.cornerRadius = 14
                    }
                    hotReviewLabel?.layer.masksToBounds = true
                    hotReviewLabel?.clipsToBounds = true
                    //리뷰를 줄간격을 16 + 글자색 흰색으로 바꾸는 코드
                    let style = NSMutableParagraphStyle()
                    let attrString = NSMutableAttributedString(string: review.comment)
                    style.minimumLineHeight = (reviewLabel?.font.pointSize)! * 1.6
                    attrString.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSRange(location: 0, length: review.comment.characters.count))
                    attrString.addAttribute(NSForegroundColorAttributeName, value: UIColor.white , range: NSRange(location: 0, length: review.comment.characters.count))
                    reviewLabel?.attributedText = attrString
                    selectedCountLabel?.text = (cnt + 1).description
                    totalCountLabel?.text = scrollViewImageNum.description
                    switch(review.grade) {
                        case 1 : starImageView?.image = #imageLiteral(resourceName: "star1.png")
                        case 2: starImageView?.image = #imageLiteral(resourceName: "star2.png")
                        case 3 : starImageView?.image = #imageLiteral(resourceName: "star3.png")
                        case 4 : starImageView?.image = #imageLiteral(resourceName: "star4.png")
                        case 5 : starImageView?.image = #imageLiteral(resourceName: "star5.png")
                        default : starImageView?.image = #imageLiteral(resourceName: "star3.png")
                    }
                    self.reviewScrollView.addSubview(reviewView)
                    xPosition += imageViewWidth
                    scrollViewSize += imageViewWidth
                    cnt += 1
                }
            }
        }
    }
    func setProductScrollView(){
        
        // 기존에 붙어있던 subview를 제거
        for subview in self.productScrollView.subviews {
            subview.removeFromSuperview()
        }
        
        
        self.productScrollView.contentOffset.x = 0
        
        if self.productScrollView != nil {
            let imageViewWidth = self.productScrollView.frame.size.width;
            let imageViewHeight = self.productScrollView.frame.size.height;
            var xPosition:CGFloat = 0;
            var cnt = 0
            let scrollViewNum = 10
            self.productScrollView.contentSize = CGSize(width: imageViewWidth / 3.0 * CGFloat(scrollViewNum), height: imageViewHeight);
            if productList.count < 10 {
                for _ in 1...(10-productList.count){
                    let product = Product.init()
                    productList.append(product)
                }
            }
            for product in productList {
                if cnt >= scrollViewNum {
                    break;
                }
                let url = URL(string: product.image)
                let productView = MainProduct.instanceFromNib()
                productView.translatesAutoresizingMaskIntoConstraints = true
                productView.frame = CGRect(x: xPosition, y: 0, width: imageViewWidth / 3.0, height: imageViewWidth / 3.0)
                productView.center.y = imageViewHeight / 2.0
                // productView들어감
                if product.name != "" {
                    productView.productImageview.contentMode = .scaleAspectFit
                    productView.productImageview.af_setImage(withURL: url!)
                }else{
                    productView.productImageview.contentMode = .scaleAspectFit
                    productView.productImageview.image = #imageLiteral(resourceName: "ic_default_product.png")
                }
                
                productView.rankLabel.text = (cnt + 1).description
                switch (product.brand) {
                    case "GS25": productView.logoImageView.image = #imageLiteral(resourceName: "logo_gs25.png")
                    case "7-eleven": productView.logoImageView.image = #imageLiteral(resourceName: "logo_7eleven.png")
                    case "CU": productView.logoImageView.image = #imageLiteral(resourceName: "logo_cu.png")
                    default : productView.logoImageView.image = #imageLiteral(resourceName: "ic_common.png")
                }
                productView.nameLabel.text = product.name
                productView.tag = cnt
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.showProduct(_:)))
                productView.addGestureRecognizer(tap)
                productView.isUserInteractionEnabled = true
                self.productScrollView.addSubview(productView)
                xPosition += imageViewWidth / 3.0
                cnt += 1
            }
        }
    }
    // 리뷰 스크롤을 눌렀을 때 전환하는 함수
    func handleTap(_ sender: UITapGestureRecognizer) {
        popup = UINib(nibName: "ReviewPopupView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! ReviewPopupView
        popup.validator = 0
        var index = 0
        if reviewScrollView.contentOffset.x != 0{
            index = 2 - Int(reviewScrollView.frame.width / reviewScrollView.contentOffset.x)
        }
        review = reviewList[index]
        Popup.showPopup(popup: popup, index: index, reviewList: reviewList, review: review, view: self.view, validator: popup.validator)
        // 카카오톡 공유 버튼 누르기
        popup.kakaoShareBtn.addTarget(self, action: #selector(self.didPressKakaoShareBtn), for: UIControlEvents.touchUpInside)
    }
    func didPressKakaoShareBtn(sender: UIButton) { //카카오톡 공유 버튼 클릭 이벤트
        DataManager.sendLinkFeed(review: review)
    }
     // 상품을 눌렀을 때 상세를 보여주는 함수
    func showProduct(_ sender: UITapGestureRecognizer) {
        if productList.count > 0 {
            let product = productList[(sender.view?.tag)!]
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ProductDetailViewController") as! ProductDetailViewController
            vc.productId = product.id
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
