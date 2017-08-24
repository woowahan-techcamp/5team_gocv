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

    @IBOutlet weak var reviewScrollView: UIScrollView!
    @IBOutlet weak var collectionView : UICollectionView!
    @IBOutlet weak var categoryScrollView: CategoryScrollView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    

    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    
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
    let category = ["전체","도시락","김밥","베이커리","라면","식품","스낵","아이스크림","음료"]
    var scrollBar = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        reviewScrollView.translatesAutoresizingMaskIntoConstraints = true
        reviewScrollView.frame.size.width = view.frame.size.width
        collectionView.translatesAutoresizingMaskIntoConstraints = true
        collectionView.frame.size.width = view.frame.size.width
        categoryScrollView.translatesAutoresizingMaskIntoConstraints = true
        categoryScrollView.frame.size.width = view.frame.size.width
        NotificationCenter.default.addObserver(self, selector: #selector(selectCategory), name: NSNotification.Name("selectCategory"), object: nil)
        categoryScrollView.backgroundColor = UIColor.white
        addCategoryBtn() // 카테고리 버튼 만들어서 스크롤 뷰에 붙이기
        Button.select(btn: categoryBtns[selectedCategoryIndex]) // 맨 처음 카테고리는 전체 선택된 것으로 나타나게 함
        didPressCategoryBtn(sender: categoryBtns[selectedCategoryIndex])
        reviewScrollView.backgroundColor = UIColor.lightGray
        reviewScrollView.isPagingEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        
        self.reviewScrollView.addGestureRecognizer(tap)
        
        self.reviewScrollView.isUserInteractionEnabled = true
        
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
    
    // 카테고리 버튼 스크롤 뷰에 추가하기
    func addCategoryBtn(){
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
        scrollBar.frame = CGRect(x: 15, y: 40, width: 34, height: 2)
        let color = UIColor(red: CGFloat(255.0 / 255.0), green: CGFloat(120.0 / 255.0),  blue: CGFloat(0.0 / 255.0), alpha: CGFloat(Float(1)))
        scrollBar.backgroundColor = color
        categoryScrollView.addSubview(scrollBar)
        categoryScrollView.showsHorizontalScrollIndicator = false // 스크롤 바 없애기
    }
    
    // 카테고리 버튼 클릭 이벤트 함수
    func didPressCategoryBtn(sender: UIButton) {
        let previousCategoryIndex = selectedCategoryIndex
        selectedCategoryIndex = sender.tag
        categoryBtns[previousCategoryIndex].isSelected = false
        Button.select(btn: sender) // 선택된 버튼에 따라 뷰 보여주기
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut,animations: {
            if sender.tag == 0 || sender.tag == 1 || sender.tag == 2 {
                self.categoryScrollView.contentOffset.x = CGFloat(0)
            } else if sender.tag == 6 || sender.tag == 7 || sender.tag == 8 {
                self.categoryScrollView.contentOffset.x = CGFloat(64 * self.category.count) - self.view.frame.size.width
            } else {
                self.categoryScrollView.contentOffset.x = CGFloat((sender.tag - 1) * 32)
            }
            self.scrollBar.frame.origin.x = CGFloat(self.selectedCategoryIndex * 64 + 15)
        },completion: nil)
        NotificationCenter.default.post(name: NSNotification.Name("showCategory"), object: self, userInfo: ["category" : selectedCategoryIndex])
    }
    
    // 카테고리를 선택했을 때 함수
    func selectCategory(_ notification: Notification){
        let previousCategoryIndex = selectedCategoryIndex
        selectedCategoryIndex = notification.userInfo?["category"] as! Int
        categoryBtns[previousCategoryIndex].isSelected = false
        Button.select(btn: categoryBtns[selectedCategoryIndex])
        if selectedCategoryIndex == 0 || selectedCategoryIndex == 1 || selectedCategoryIndex == 2 {
            categoryScrollView.contentOffset.x = CGFloat(0)
        } else if selectedCategoryIndex == 6 || selectedCategoryIndex == 7 || selectedCategoryIndex == 8 {
            categoryScrollView.contentOffset.x = CGFloat(7 * 32)
        } else {
            categoryScrollView.contentOffset.x = CGFloat((selectedCategoryIndex - 1) * 32)
        }
        scrollBar.frame.origin.x = CGFloat(selectedCategoryIndex * 64 + 15)
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
        default : break;
        }
        
        self.showActivityIndicatory()
        if selectedBrandIndexFromTab == 0  && selectedCategoryIndex == 0 { // 브랜드 : 전체 , 카테고리 : 전체 일때
            
            if self.appdelegate.productList.count > 0 { // global product list가 저장된 후
                self.productList = self.appdelegate.productList
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.hideActivityIndicatory()
                }
            }else{ // global product list가 없다면
                DataManager.getTop3Product() { (products) in
                    self.productList = products
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
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
                    self.collectionView.reloadData()
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
                self.collectionView.reloadData()
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
                    self.collectionView.reloadData()
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
        default : break;
        }
//        indicatorView.startAnimating()
        DataManager.getTop3ReviewByBrand(brand: brand) { (reviews) in
            self.reviewList = reviews
            if self.reviewScrollView != nil {
                let imageViewWidth = self.reviewScrollView.frame.size.width;
                let imageViewHeight = self.reviewScrollView.frame.size.height;
                var xPosition:CGFloat = 0;
                var scrollViewSize:CGFloat=0;
                var cnt = 0
                let scrollViewImageNum = 3
                self.reviewScrollView.contentSize = CGSize(width: imageViewWidth*CGFloat(3), height: imageViewHeight);

                for review in self.reviewList {
                    if cnt >= scrollViewImageNum {
                        break;
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
                    hotReviewLabel?.layer.cornerRadius = 14
                    hotReviewLabel?.layer.masksToBounds = true
                    hotReviewLabel?.clipsToBounds = true
                    //리뷰를 줄간격을 16 + 글자색 흰색으로 바꾸는 코드
                    let style = NSMutableParagraphStyle()
                    let attrString = NSMutableAttributedString(string: review.comment)
                    style.minimumLineHeight = 20
                    attrString.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSRange(location: 0, length: review.comment.characters.count))
                    attrString.addAttribute(NSForegroundColorAttributeName, value: UIColor.white , range: NSRange(location: 0, length: review.comment.characters.count))
                    reviewLabel?.attributedText = attrString
                    reviewLabel?.lineBreakMode = NSLineBreakMode.byTruncatingTail
                    selectedCountLabel?.text = (cnt + 1).description
                    totalCountLabel?.text = scrollViewImageNum.description
                
                    
                    switch(review.grade) {
                    case 1 : starImageView?.image = #imageLiteral(resourceName: "star1.png");
                    case 2: starImageView?.image = #imageLiteral(resourceName: "star2.png");
                    case 3 : starImageView?.image = #imageLiteral(resourceName: "star3.png");
                    case 4 : starImageView?.image = #imageLiteral(resourceName: "star4.png");
                    case 5 : starImageView?.image = #imageLiteral(resourceName: "star5.png");
                    default : starImageView?.image = #imageLiteral(resourceName: "star3.png");
                    }
                    
                    
                    self.reviewScrollView.addSubview(reviewView)
                    xPosition += imageViewWidth
                    scrollViewSize += imageViewWidth
                    cnt = cnt + 1
                }
                
                
            }
            
        }
        
        
    }
    
    // 리뷰 스크롤을 눌렀을 때 전환하는 함수
    func handleTap(_ sender: UITapGestureRecognizer) {
        NotificationCenter.default.post(name: NSNotification.Name("showReview"), object: self)
    }
    
    // 변할때
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        reviewScrollView.translatesAutoresizingMaskIntoConstraints = true
        reviewScrollView.frame.size.width = size.width
        collectionView.translatesAutoresizingMaskIntoConstraints = true
        collectionView.frame.size.width = size.width
        categoryScrollView.translatesAutoresizingMaskIntoConstraints = true
        categoryScrollView.frame.size.width = size.width
        
        collectionView.reloadData()
        setReviewScrollImages()
    }
    
}

extension MainViewController: UICollectionViewDataSource { //메인화면에서 1,2,3위 상품 보여주기
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.bounds.width < 375 {
            return 2;
        }else if collectionView.bounds.width < 414{
            return 3;
        }else if collectionView.bounds.width < 667{
            return 4;
        }else{
            return 5;
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? MainRankCollectionViewCell {


            
            if (productList.count > 2) && (indexPath.item < 5) {
                cell.loading.startAnimating()
                cell.foodImage.af_setImage(withURL: URL(string: productList[indexPath.item].image)!, placeholderImage: UIImage(), imageTransition: .crossDissolve(0.2), completion:{ image in
                    cell.loading.stopAnimating()
                })
                
                for sub in cell.brandLabel.subviews {
                    sub.removeFromSuperview()
                }
                
                let imageview : UIImageView = UIImageView()
                switch (productList[indexPath.item].brand) {
                case "GS25":
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
                default :
                    imageview.image = #imageLiteral(resourceName: "ic_common.png")
                    imageview.frame.size.width = 50;
                    imageview.frame.size.height = 20;
                    imageview.center = CGPoint.init(x: cell.brandLabel.frame.size.width  / 2, y: cell.brandLabel.frame.size.height / 2);

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
