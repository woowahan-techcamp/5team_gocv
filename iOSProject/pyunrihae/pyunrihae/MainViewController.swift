//
//  MainViewController.swift
//  pyunrihae
//
//  Created by woowabrothers on 2017. 8. 4..
//  Copyright © 2017년 busride. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire

class MainViewController: UIViewController {

    @IBOutlet weak var reviewImageView: UIScrollView!
    @IBOutlet weak var collectionView : UICollectionView!
    @IBOutlet weak var categoryScrollView: CategoryScrollView!
    

    var productList : [Product] = []
    var reviewList : [Review] = []
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
    
    var actInd: UIActivityIndicatorView = UIActivityIndicatorView()
    var categoryBtns = [UIButton]()
    let category = ["전체","도시락","김밥","베이커리","라면","즉석식품","스낵","유제품","음료"]
    
    func addCategoryBtn(){ // 카테고리 버튼 스크롤 뷰에 추가하기
        categoryScrollView.isScrollEnabled = true
        categoryScrollView.contentSize.width = CGFloat(64 * category.count)
        for index in 0..<category.count {
            let categoryBtn = UIButton(frame: CGRect(x: 64 * index, y: 5, width: 64, height: 32))
            let color = UIColor(red: CGFloat(102.0 / 255.0), green: CGFloat(102.0 / 255.0),  blue: CGFloat(102.0 / 255.0), alpha: CGFloat(1.0))
            categoryBtn.setTitle(category[index], for: .normal) // 카테고리 버튼 텍스트
            categoryBtn.setTitleColor(color, for: .normal) // 카테고리 버튼 텍스트 색깔
            categoryBtn.contentHorizontalAlignment = .center // 카테고리 버튼 중앙정렬
            categoryBtn.titleLabel?.font = categoryBtn.titleLabel?.font.withSize(13) // 카테고리 버튼 폰트 크기 13
            categoryBtn.tag = index // 버튼 태그 생성해주기
            categoryBtns.append(categoryBtn)
            categoryBtn.addTarget(self, action: #selector(didPressCategoryBtn), for: UIControlEvents.touchUpInside)
            categoryScrollView.addSubview(categoryBtn)
        }
        categoryScrollView.showsHorizontalScrollIndicator = false // 스크롤 바 없애기
    }
    
    func didPressCategoryBtn(sender: UIButton) { // 카테고리 버튼 클릭 함수
        let previousCategoryIndex = selectedCategoryIndex
        selectedCategoryIndex = sender.tag
        categoryBtns[previousCategoryIndex].isSelected = false
        Button.select(btn: sender) // 선택된 버튼에 따라 뷰 보여주기
        NotificationCenter.default.post(name: NSNotification.Name("showCategory"), object: self, userInfo: ["category" : selectedCategoryIndex])
    }
    func selectCategory(_ notification: Notification){
        let previousCategoryIndex = selectedCategoryIndex
        selectedCategoryIndex = notification.userInfo?["category"] as! Int
        categoryBtns[previousCategoryIndex].isSelected = false
        Button.select(btn: categoryBtns[selectedCategoryIndex])
    }
    
    func showActivityIndicatory() {
        self.actInd.frame = CGRect.init(x: 0.0, y: 0.0, width: 40.0, height: 40.0)
        self.actInd.center = view.superview?.center ?? view.center
        self.actInd.hidesWhenStopped = true
        self.actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(actInd)
        actInd.startAnimating()
    }
    
    func hideActivityIndicatory() {
        if view.subviews.contains(actInd){
            actInd.stopAnimating()
            view.willRemoveSubview(actInd)
        }
    }
    
    func getProductList(){
        
        var brand = ""
        
        switch selectedBrandIndexFromTab {
        case 0 : brand = ""
        case 1 : brand = "gs25"
        case 2 : brand = "CU"
        case 3 : brand = "7-eleven"
        default : break;
        }
        
        self.showActivityIndicatory()
        if selectedBrandIndexFromTab == 0  && selectedCategoryIndex == 0 { // 브랜드 : 전체 , 카테고리 : 전체 일때
            
            DataManager.getTop3Product() { (products) in
                self.productList = products
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.hideActivityIndicatory()
                }
            }
        } else if selectedBrandIndexFromTab == 0 { // 브랜드만 전체일 때
            
            if categoryBtns.count > 0 {
                DataManager.getTopProductBy(category: (categoryBtns[selectedCategoryIndex].titleLabel?.text)!) { (products) in
                    self.productList = products
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                        self.hideActivityIndicatory()
                    }
                }
            }
            
        } else if selectedCategoryIndex == 0 { // 카테고리만 전체일 때
            DataManager.getTopProductBy(brand: brand) { (products) in
                self.productList = products
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.hideActivityIndicatory()
                }
            }
        } else { // 브랜드도 카테고리도 전체가 아닐 때
            if categoryBtns.count > 0 {
                DataManager.getTopProductBy(brand: brand, category: (categoryBtns[selectedCategoryIndex].titleLabel?.text)!) { (products) in
                    self.productList = products
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                        self.hideActivityIndicatory()
                    }
                }
            }
        }
    }
    
    func setReviewScrollImages(){
        var brand = ""
        
        switch selectedBrandIndexFromTab {
        case 0 : brand = "전체"
        case 1 : brand = "gs25"
        case 2 : brand = "CU"
        case 3 : brand = "7-eleven"
        default : break;
        }
        showActivityIndicatory()
        DataManager.getTop3ReviewByBrand(brand: brand) { (reviews) in
            self.reviewList = reviews
            if self.reviewImageView != nil {
                let imageViewWidth = self.reviewImageView.frame.size.width;
                let imageViewHeight = self.reviewImageView.frame.size.height;
                var xPosition:CGFloat = 0;
                var scrollViewSize:CGFloat=0;
                var cnt = 0
                let scrollViewImageNum = 3
                
                for review in self.reviewList {
                    if cnt >= scrollViewImageNum {
                        break;
                    }
                    
                    let url = URL(string: review.p_image)
                    let myImageView:UIImageView = UIImageView()
                    let blackLayerView : UIView = UIView()
                    let barLabel : UILabel = UILabel()
                    let brandLabel : UILabel = UILabel()
                    let nameLabel : UILabel = UILabel()
                    let reviewLabel : UILabel = UILabel()
                    let moreLabel : UILabel = UILabel()
                    let hotReviewLabel : UILabel = UILabel()
                    let selectedCountLabel : UILabel = UILabel()
                    let totalCountLabel : UILabel = UILabel()
                    let starImageView : UIImageView = UIImageView()
                
                    
                    myImageView.af_setImage(withURL: url!)
                    myImageView.contentMode = UIViewContentMode.scaleAspectFill
                    
                    myImageView.frame.size.width = imageViewWidth
                    myImageView.frame.size.height = imageViewHeight
                    myImageView.frame.origin.x = xPosition
                    
                    blackLayerView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
                    blackLayerView.frame.size.width = imageViewWidth
                    blackLayerView.frame.size.height = imageViewHeight
                    blackLayerView.frame.origin.x = xPosition
                    
                    barLabel.text  = "|"
                    barLabel.textColor = UIColor.white.withAlphaComponent(0.4)
                    barLabel.frame.origin.x = 102 + scrollViewSize
                    barLabel.frame.origin.y = 172
                    barLabel.frame.size.width = 4
                    barLabel.frame.size.height = 10
                    
                    brandLabel.textColor = UIColor.white.withAlphaComponent(0.6)
                    brandLabel.text = review.brand
                    brandLabel.frame.size.width = 54
                    brandLabel.frame.size.height = 20
                    brandLabel.font = brandLabel.font.withSize(12)
                    brandLabel.frame.origin.x = 113 + scrollViewSize
                    brandLabel.frame.origin.y = 167
                    
                    nameLabel.textColor = UIColor.white
                    nameLabel.text = review.p_name
                    nameLabel.frame.size.width = imageViewWidth
                    nameLabel.frame.size.height = 28
                    nameLabel.font = nameLabel.font.withSize(22)
                    nameLabel.frame.origin.x = 20 + scrollViewSize
                    nameLabel.frame.origin.y = 77
                    nameLabel.textAlignment = .left
                    
                    hotReviewLabel.frame.origin.x = 20 + scrollViewSize
                    hotReviewLabel.frame.origin.y = 32
                    hotReviewLabel.backgroundColor = UIColor(red: CGFloat(255.0 / 255.0), green: CGFloat(120.0 / 255.0),  blue: CGFloat(0.0 / 255.0), alpha: CGFloat(Float(1)))
                    hotReviewLabel.frame.size.width = 64
                    hotReviewLabel.frame.size.height = 27
                    hotReviewLabel.text = "핫 리뷰"
                    hotReviewLabel.font = UIFont.boldSystemFont(ofSize: 12)
                    hotReviewLabel.textColor = UIColor.white
                    hotReviewLabel.textAlignment = .center
                    hotReviewLabel.layer.cornerRadius = 14
                    hotReviewLabel.layer.masksToBounds = true
                    hotReviewLabel.clipsToBounds = true
                    
                    // 리뷰를 줄간격을 16 + 글자색 흰색으로 바꾸는 코드
                    let style = NSMutableParagraphStyle()
                    let attrString = NSMutableAttributedString(string: review.comment)
                    style.minimumLineHeight = 20
                    attrString.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSRange(location: 0, length: review.comment.characters.count))
                    attrString.addAttribute(NSForegroundColorAttributeName, value: UIColor.white , range: NSRange(location: 0, length: review.comment.characters.count))
                    reviewLabel.attributedText = attrString
                    
                    reviewLabel.numberOfLines = 0
                    reviewLabel.frame.size.width = 316
                    reviewLabel.frame.size.height = 40
                    reviewLabel.font = reviewLabel.font?.withSize(14.0)
                    reviewLabel.frame.origin.x = 20 + scrollViewSize
                    reviewLabel.frame.origin.y = 111
                    reviewLabel.textAlignment = .left
                    reviewLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
                    
                    moreLabel.textColor = UIColor.white.withAlphaComponent(0.6)
                    let attributedText = NSMutableAttributedString(string: "자세히")
                    attributedText.addAttribute(NSUnderlineStyleAttributeName , value: NSUnderlineStyle.styleSingle.rawValue, range: NSRange(location: 0, length: "자세히".characters.count))
                    moreLabel.attributedText = attributedText
                    moreLabel.frame.size.width = 32
                    moreLabel.frame.size.height = 20
                    moreLabel.font = moreLabel.font.withSize(12)
                    moreLabel.frame.origin.x = 324 + scrollViewSize
                    moreLabel.frame.origin.y = 167
                    
                    selectedCountLabel.frame.origin.x = 334 + scrollViewSize
                    selectedCountLabel.frame.origin.y = 32
                    selectedCountLabel.font = UIFont.boldSystemFont(ofSize: 12)
                    selectedCountLabel.text = (cnt + 1).description
                    selectedCountLabel.frame.size.width = 9
                    selectedCountLabel.frame.size.height = 15
                    selectedCountLabel.textColor = UIColor.white
                    
                    totalCountLabel.frame.origin.x = 344 + scrollViewSize
                    totalCountLabel.frame.origin.y = 32
                    totalCountLabel.frame.size.width = 20
                    totalCountLabel.frame.size.height = 16
                    totalCountLabel.font = totalCountLabel.font.withSize(12)
                    totalCountLabel.textColor = UIColor.white.withAlphaComponent(0.6)
                    totalCountLabel.text = "/ " + scrollViewImageNum.description
                    
                    starImageView.frame.origin.x = 22 + scrollViewSize
                    starImageView.frame.origin.y = 170
                    starImageView.frame.size.width = 72
                    starImageView.frame.size.height = 12
                
                    
                    switch(review.grade) {
                    case 1 : starImageView.image = #imageLiteral(resourceName: "star1.png");
                    case 2: starImageView.image = #imageLiteral(resourceName: "star2.png");
                    case 3 : starImageView.image = #imageLiteral(resourceName: "star3.png");
                    case 4 : starImageView.image = #imageLiteral(resourceName: "star4.png");
                    case 5 : starImageView.image = #imageLiteral(resourceName: "star5.png");
                    default : starImageView.image = #imageLiteral(resourceName: "star3.png");
                    }
                    
                    
                    let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
                    
                    self.reviewImageView.addGestureRecognizer(tap)
                    
                    self.reviewImageView.isUserInteractionEnabled = true
                    
                    self.reviewImageView.addSubview(myImageView)
                    self.reviewImageView.addSubview(blackLayerView)
                    self.reviewImageView.addSubview(barLabel)
                    self.reviewImageView.addSubview(brandLabel)
                    self.reviewImageView.addSubview(nameLabel)
                    self.reviewImageView.addSubview(reviewLabel)
                    self.reviewImageView.addSubview(moreLabel)
                    self.reviewImageView.addSubview(hotReviewLabel)
                    self.reviewImageView.addSubview(selectedCountLabel)
                    self.reviewImageView.addSubview(totalCountLabel)
                    self.reviewImageView.addSubview(starImageView)
                 
                    xPosition += imageViewWidth
                    scrollViewSize += imageViewWidth
                    cnt = cnt + 1
                };
                self.hideActivityIndicatory()
                self.reviewImageView.contentSize = CGSize(width: scrollViewSize, height: 0.8);
                
            }
            NotificationCenter.default.post(name: NSNotification.Name("doneLoading"), object: self)
        }
        
    }
    
    func handleTap(_ sender: UITapGestureRecognizer) {
        NotificationCenter.default.post(name: NSNotification.Name("showReview"), object: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        NotificationCenter.default.addObserver(self, selector: #selector(selectCategory), name: NSNotification.Name("selectCategory"), object: nil)
        categoryScrollView.backgroundColor = UIColor.white
        addCategoryBtn() // 카테고리 버튼 만들어서 스크롤 뷰에 붙이기
        Button.select(btn: categoryBtns[selectedCategoryIndex]) // 맨 처음 카테고리는 전체 선택된 것으로 나타나게 함
        didPressCategoryBtn(sender: categoryBtns[selectedCategoryIndex])
        reviewImageView.backgroundColor = UIColor.lightGray
        reviewImageView.isPagingEnabled = true

        DataManager.getTop3Product() { (products) in
            self.productList = products
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

extension MainViewController: UICollectionViewDataSource { //메인화면에서 1,2,3위 상품 보여주기
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3;
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? MainRankCollectionViewCell {


            
            if (productList.count > 2) && (indexPath.item < 3) {
                cell.loading.startAnimating()
                cell.foodImage.af_setImage(withURL: URL(string: productList[indexPath.item].image)!, placeholderImage: UIImage(), imageTransition: .crossDissolve(0.2), completion:{ image in
                    cell.loading.stopAnimating()
                })
                
                for sub in cell.brandLabel.subviews {
                    sub.removeFromSuperview()
                }
                
                let imageview : UIImageView = UIImageView()
                switch (productList[indexPath.item].brand) {
                case "gs25":
                    imageview.image = #imageLiteral(resourceName: "logo_gs25.png")
                    imageview.frame.size.width = 35;
                    imageview.frame.size.height = 15;
                    imageview.center = CGPoint.init(x: cell.brandLabel.frame.size.width  / 2, y: cell.brandLabel.frame.size.height / 2);
                case "7-eleven":
                    imageview.image = #imageLiteral(resourceName: "logo_7eleven.png")
                    imageview.frame.size.width = 66;
                    imageview.frame.size.height = 12;
                    imageview.center = CGPoint.init(x: cell.brandLabel.frame.size.width  / 2, y: cell.brandLabel.frame.size.height / 2);
                case "CU":
                    imageview.image = #imageLiteral(resourceName: "logo_cu.png")
                    imageview.frame.size.width = 32;
                    imageview.frame.size.height = 14;
                    imageview.center = CGPoint.init(x: cell.brandLabel.frame.size.width  / 2, y: cell.brandLabel.frame.size.height / 2);
                default : break;
                }
                
                cell.brandLabel.addSubview(imageview)
                cell.nameLabel.text = productList[indexPath.item].name
                cell.rankLabel.text = (indexPath.item + 1).description
            }
            
            return cell
        }
        
        return MainRankCollectionViewCell()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! MainRankCollectionViewCell
        let indexRow = self.collectionView!.indexPath(for: cell)?.row
        if productList.count > 0 {
            let product = productList[indexRow!]
            NotificationCenter.default.post(name: NSNotification.Name("showProduct"), object: self, userInfo: ["product" : product])
        }
    }
}
extension MainViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
}
