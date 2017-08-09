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
    @IBOutlet weak var showAllBtn: UIButton!
    @IBOutlet weak var reviewImageView: UIScrollView!
    @IBOutlet weak var collectionView : UICollectionView!
    @IBOutlet weak var categoryScrollView: CategoryScrollView!
    
    @IBAction func didPressshowAllBtn(_ sender: UIButton){
        NotificationCenter.default.post(name: NSNotification.Name("showRanking"), object: self)
    }
    
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
    
    var categoryBtns = [UIButton]()
    let category = ["전체","도시락","김밥","베이커리","라면","즉석식품","스낵","유제품","음료"]
    
    func addCategoryBtn(){ // 카테고리 버튼 스크롤 뷰에 추가하기
        categoryScrollView.isScrollEnabled = true
        categoryScrollView.contentSize.width = CGFloat(80 * category.count)
        for index in 0..<category.count {
            let categoryBtn = UIButton(frame: CGRect(x: 80 * index, y: 10, width: 80, height: 40))
            categoryBtn.setTitle(category[index], for: .normal) // 카테고리 버튼 텍스트
            categoryBtn.setTitleColor(UIColor.darkGray, for: .normal) // 카테고리 버튼 텍스트 색깔
            categoryBtn.contentHorizontalAlignment = .center // 카테고리 버튼 중앙정렬
            categoryBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15) // 카테고리 버튼 폰트 크기 15
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
    func getProductList(){
        
        var brand = ""
        
        switch selectedBrandIndexFromTab {
        case 0 : brand = ""
        case 1 : brand = "gs25"
        case 2 : brand = "CU"
        case 3 : brand = "7-eleven"
        default : break;
        }
        
        if selectedBrandIndexFromTab == 0  && selectedCategoryIndex == 0 { // 브랜드 : 전체 , 카테고리 : 전체 일때
            
            DataManager.getTop3Product() { (products) in
                self.productList = products
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        } else if selectedBrandIndexFromTab == 0 { // 브랜드만 전체일 때
            
            if categoryBtns.count > 0 {
                DataManager.getTop3ProductBy(category: (categoryBtns[selectedCategoryIndex].titleLabel?.text)!) { (products) in
                    self.productList = products
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            }
            
        } else if selectedCategoryIndex == 0 { // 카테고리만 전체일 때
            DataManager.getTop3ProductBy(brand: brand) { (products) in
                self.productList = products
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        } else { // 브랜드도 카테고리도 전체가 아닐 때
            if categoryBtns.count > 0 {
                DataManager.getTop3ProductBy(brand: brand, category: (categoryBtns[selectedCategoryIndex].titleLabel?.text)!) { (products) in
                    self.productList = products
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
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
        
        DataManager.getTop3ReviewByBrand(brand: brand) { (reviews) in
            self.reviewList = reviews
            if self.reviewImageView != nil {
                let imageViewWidth = self.reviewImageView.frame.size.width;
                let imageViewHeight = self.reviewImageView.frame.size.height;
                var xPosition:CGFloat = 0;
                var scrollViewSize:CGFloat=0;
                var cnt = 3
                
                for review in self.reviewList {
                    if cnt <= 0 {
                        break;
                    }
                    let url = URL(string: review.p_image)
                    let myImageView:UIImageView = UIImageView()
                    let blackLayerView : UIView = UIView()
                    let brandLabel : UILabel = UILabel()
                    let nameLabel : UILabel = UILabel()
                    let reviewTextView : UITextView = UITextView()
                    let moreLabel : UILabel = UILabel()
                
                    myImageView.af_setImage(withURL: url!)
                    myImageView.contentMode = UIViewContentMode.scaleAspectFill
                    
                    myImageView.frame.size.width = imageViewWidth
                    myImageView.frame.size.height = imageViewHeight
                    myImageView.frame.origin.x = xPosition
                    
                    blackLayerView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
                    blackLayerView.frame.size.width = imageViewWidth
                    blackLayerView.frame.size.height = imageViewHeight
                    blackLayerView.frame.origin.x = xPosition
                    
                    brandLabel.textColor = UIColor.white
                    brandLabel.text = review.brand
                    brandLabel.frame.size.width = imageViewWidth
                    brandLabel.frame.size.height = imageViewHeight
                    brandLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
                    brandLabel.frame.origin.x = xPosition + 12
                    brandLabel.frame.origin.y = 60
                    
                    nameLabel.textColor = UIColor.white
                    nameLabel.text = review.p_name
                    nameLabel.frame.size.width = imageViewWidth
                    nameLabel.frame.size.height = imageViewHeight
                    nameLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
                    nameLabel.frame.origin.x = xPosition + 12
                    nameLabel.frame.origin.y = 80
                    
                    
                    // 리뷰를 줄간격을 16 + 글자색 흰색으로 바꾸는 코드
                    let style = NSMutableParagraphStyle()
                    let attrString = NSMutableAttributedString(string: review.comment)
                    style.lineSpacing = 16
                    style.minimumLineHeight = 16
                    attrString.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSRange(location: 0, length: review.comment.characters.count))
                    attrString.addAttribute(NSForegroundColorAttributeName, value: UIColor.white , range: NSRange(location: 0, length: review.comment.characters.count))
                    reviewTextView.attributedText = attrString
                    
                    reviewTextView.frame.size.width = imageViewWidth / 2 - 20
                    reviewTextView.frame.size.height = imageViewHeight - 40
                    reviewTextView.font = reviewTextView.font?.withSize(16.0)
                    reviewTextView.frame.origin.x = xPosition + imageViewWidth / 2 + 10
                    reviewTextView.frame.origin.y = 20
                    reviewTextView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
                    
                    moreLabel.textColor = UIColor.white
                    moreLabel.text = "더보기 >"
                    moreLabel.frame.size.width = imageViewWidth
                    moreLabel.frame.size.height = imageViewHeight
                    moreLabel.font = UIFont.boldSystemFont(ofSize: 12.0)
                    moreLabel.frame.origin.x = xPosition + imageViewWidth - 60
                    moreLabel.frame.origin.y = 84

                    self.reviewImageView.addSubview(myImageView)
                    self.reviewImageView.addSubview(blackLayerView)
                    self.reviewImageView.addSubview(brandLabel)
                    self.reviewImageView.addSubview(nameLabel)
                    self.reviewImageView.addSubview(reviewTextView)
                    self.reviewImageView.addSubview(moreLabel)
                   

                    xPosition += imageViewWidth
                    scrollViewSize += imageViewWidth
                    cnt = cnt - 1
                };
                self.reviewImageView.contentSize = CGSize(width: scrollViewSize, height: 0.8);
                
            }
            
        }
        
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
        showAllBtn.layer.borderColor = UIColor.lightGray.cgColor
        showAllBtn.layer.borderWidth = 1
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
            cell.foodImage.layer.cornerRadius = cell.foodImage.frame.height/2
            cell.foodImage.clipsToBounds = true
            cell.foodImage.backgroundColor = UIColor.lightGray
            cell.rankLabel.layer.cornerRadius = cell.rankLabel.frame.height/2
            cell.rankLabel.layer.masksToBounds = true
            
            if indexPath.row == 0{
                if productList.count > 0 {
                    cell.foodImage.af_setImage(withURL: URL(string: productList[0].image)!)
                    cell.brandLabel.text  = productList[0].brand
                    cell.nameLabel.text = productList[0].name
                }
                
                cell.rankLabel.text = "1위"
                cell.rankLabel.backgroundColor = UIColor.orange
                cell.rankLabel.textColor = UIColor.white
            } else if indexPath.row == 1{
                if productList.count > 0 {
                    Alamofire.request(productList[1].image).responseImage { response in
                        
                        if let image = response.result.value {
                            cell.foodImage.image = image
                        }
                    }
                    cell.brandLabel.text  = productList[1].brand
                    cell.nameLabel.text = productList[1].name
                }
                cell.rankLabel.text = "2위"
                cell.rankLabel.backgroundColor = UIColor.lightGray
                cell.rankLabel.textColor = UIColor.white
            } else {
                if productList.count > 0 {
                    Alamofire.request(productList[2].image).responseImage { response in
                        
                        if let image = response.result.value {
                            cell.foodImage.image = image
                        }
                    }
                    cell.brandLabel.text  = productList[2].brand
                    cell.nameLabel.text = productList[2].name
                }
                cell.rankLabel.text = "3위"
                cell.rankLabel.backgroundColor = UIColor.brown
                cell.rankLabel.textColor = UIColor.white
            }
            
            return cell
        }
        
        return MainRankCollectionViewCell()
    }
}
extension MainViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
}
