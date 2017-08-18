//
//  RankingViewController.swift
//  pyunrihae
//
//  Created by woowabrothers on 2017. 8. 7..
//  Copyright © 2017년 busride. All rights reserved.
//

import UIKit

class RankingViewController: UIViewController {
    @IBOutlet weak var categoryScrollView: UIScrollView!
    @IBOutlet weak var productNumLabel: UILabel!
    @IBOutlet weak var sortingMethodLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBAction func tabDropDownBtn(_ sender: UIButton) {
        let alert = UIAlertController(title: "순서 정렬하기", message: "", preferredStyle: .actionSheet)
        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            
        }
        let orderByRanking = UIAlertAction(title: "랭킹순", style: .default) { action -> Void in
            DispatchQueue.main.async {
                self.sortingMethodLabel.text  = "랭킹순"
                self.setRankingListOrder()
            }
        }
        let orderByPrice = UIAlertAction(title: "낮은 가격순", style: .destructive) { action -> Void in
            DispatchQueue.main.async {
                self.sortingMethodLabel.text  = "낮은 가격순"
                self.setRankingListOrder()
            }
        }

        alert.addAction(cancelAction)
        alert.addAction(orderByRanking)
        alert.addAction(orderByPrice)
        present(alert, animated: true, completion: nil)
    }
    let priceLevelList = ["비싸다","비싼편","적당","싼편","싸다"]
    let flavorLevelList = ["노맛","별로","적당","괜춘","존맛"]
    let quantityLevelList = ["창렬","적음","적당","많음","혜자"]
    var isLoaded = false
    var selectedBrandIndexFromTab : Int = 0 {
        didSet{
            getRankingList()
        }
    }
    var selectedCategoryIndex: Int = 0 { // 선택된 카테고리 인덱스, 초기값은 0 (전체)
        didSet{
            getRankingList()
        }
    }
    var productList : [Product] = []
    var categoryBtns = [UIButton]()
    var actInd: UIActivityIndicatorView = UIActivityIndicatorView()
    let category = ["전체","도시락","김밥","베이커리","라면","즉석식품","스낵","유제품","음료"]
    func addCategoryBtn(){ // 카테고리 버튼 스크롤 뷰에 추가하기
        categoryScrollView.isScrollEnabled = true
        categoryScrollView.contentSize.width = CGFloat(80 * category.count)
        for index in 0..<category.count {
            let categoryBtn = UIButton(frame: CGRect(x: 80 * index, y: 5, width: 80, height: 40))
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
        if isLoaded {
            categoryBtns[previousCategoryIndex].isSelected = false
            Button.select(btn: categoryBtns[selectedCategoryIndex])
        }
    }
    func addNotiObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(selectCategory), name: NSNotification.Name("selectCategory"), object: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        categoryScrollView.backgroundColor = UIColor.white
        addCategoryBtn() // 카테고리 버튼 만들어서 스크롤 뷰에 붙이기
        Button.select(btn: categoryBtns[selectedCategoryIndex]) // 맨 처음 카테고리는 전체 선택된 것으로 나타나게 함
        didPressCategoryBtn(sender: categoryBtns[selectedCategoryIndex])
        isLoaded = true
        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showActivityIndicatory() {
        self.actInd.frame = CGRect.init(x: 0.0, y: 0.0, width: 40.0, height: 40.0)
        self.actInd.center = view.center
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
    
    func getRankingList(){
        
        var brand = ""
        
        switch selectedBrandIndexFromTab {
        case 0 : brand = ""
        case 1 : brand = "gs25"
        case 2 : brand = "CU"
        case 3 : brand = "7-eleven"
        default : break;
        }
        
        self.showActivityIndicatory()
        
        if collectionView != nil {
            if selectedBrandIndexFromTab == 0  && selectedCategoryIndex == 0 { // 브랜드 : 전체 , 카테고리 : 전체 일때
                
                DataManager.getProductAllInRank()  { (products) in
                    self.productList = products
                    DispatchQueue.main.async {
                        self.setRankingNum()
                        self.setRankingListOrder()
                        self.hideActivityIndicatory()
                    }
                }
            } else if selectedBrandIndexFromTab == 0 { // 브랜드만 전체일 때
                
                if categoryBtns.count > 0 {
                    DataManager.getTopProductBy(category: (categoryBtns[selectedCategoryIndex].titleLabel?.text)!) { (products) in
                        self.productList = products
                        DispatchQueue.main.async {
                            self.setRankingNum()
                            self.setRankingListOrder()
                            self.hideActivityIndicatory()
                        }
                    }
                }
                
            } else if selectedCategoryIndex == 0 { // 카테고리만 전체일 때
                DataManager.getTopProductBy(brand: brand) { (products) in
                    self.productList = products
                    DispatchQueue.main.async {
                        self.setRankingNum()
                        self.setRankingListOrder()
                        self.hideActivityIndicatory()
                    }
                }
            } else { // 브랜드도 카테고리도 전체가 아닐 때
                if categoryBtns.count > 0 {
                    DataManager.getTopProductBy(brand: brand, category: (categoryBtns[selectedCategoryIndex].titleLabel?.text)!) { (products) in
                        self.productList = products
                        DispatchQueue.main.async {
                            self.setRankingNum()
                            self.setRankingListOrder()
                            self.hideActivityIndicatory()
                        }
                    }
                }
            }
            
        }
        
    }
    
    func setRankingNum(){
        DispatchQueue.main.async{
            if self.productList.count > 0 {
                self.productNumLabel.text = self.productList.count.description + "개의 상품"
            }else{
                self.productNumLabel.text = "아직 상품이 없습니다."
            }
        }
    }
    
       
    func setRankingListOrder(){
        
        if sortingMethodLabel != nil {
            
            if sortingMethodLabel.text == "랭킹순"{
                self.productList = productList.sorted(by: { $0.grade_avg > $1.grade_avg })
            }else{
                // 멈출 위험이 있음.
                self.productList = productList.sorted(by: { Int($0.price)! < Int($1.price)! })
            }
            
            self.collectionView.reloadData()
        }
    }


    
}

extension RankingViewController: UICollectionViewDataSource { 
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productList.count;
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? RankingCollectionViewCell {
            let product = self.productList[indexPath.item]
            cell.foodImage.layer.cornerRadius = cell.foodImage.frame.height/2
            cell.foodImage.clipsToBounds = true
           
            cell.loading.startAnimating()
            
            if product.image != "" {
                cell.foodImage.af_setImage(withURL: URL(string: product.image)!, placeholderImage: UIImage(), imageTransition: .crossDissolve(0.2), completion:{ image in
                    cell.loading.stopAnimating()
                })
            }else{
                cell.foodImage.image = #imageLiteral(resourceName: "ic_default.png")
            }
           

            cell.orderNumLabel.text = (indexPath.item + 1).description
            cell.brandLabel.text = product.brand
            cell.PriceLabel.text = product.price.description + "원"
            cell.productNameLabel.text = product.name
            
            
            if product.event[0].characters.count > 2 {
                cell.EventLabel.isHidden = false
                cell.EventLabel.text = product.event[0]
            }else{
                cell.EventLabel.isHidden = true
            }
            
            for sub in cell.starView.subviews {
                sub.removeFromSuperview()
            }
            
//            let grade = product.grade_avg
            let numberOfPlaces = 2.0
            let multiplier = pow(10.0, numberOfPlaces)
            let grade = round(Double(product.grade_avg) * multiplier) / multiplier

            cell.gradeLabel.text = String(grade)
            for i in 0..<Int(grade) {
                let starImage = UIImage(named: "stars.png")
                let cgImage = starImage?.cgImage
                let croppedCGImage: CGImage = cgImage!.cropping(to: CGRect(x: 0, y: 10, width: (starImage?.size.width)! / 5, height: starImage!.size.height))!
                let uiImage = UIImage(cgImage: croppedCGImage)
                let imageView = UIImageView(image: uiImage)
                imageView.frame = CGRect(x: i*18, y: 0, width: 18, height: 15)
                cell.starView.addSubview(imageView)
            }
            if grade - Double(Int(grade)) >= 0.5 {
                let starImage = UIImage(named: "stars.png")
                let cgImage = starImage?.cgImage
                let croppedCGImage: CGImage = cgImage!.cropping(to: CGRect(x: (starImage?.size.width)! * 4 / 5, y: 10, width: (starImage?.size.width)!, height: starImage!.size.height))!
                let uiImage = UIImage(cgImage: croppedCGImage)
                let imageView = UIImageView(image: uiImage)
                imageView.frame = CGRect(x: Int(grade)*18 - 3, y: 0, width: 18, height: 15)
                cell.starView.addSubview(imageView)
            }
            Label.makeRoundLabel(label: cell.PriceLevelLabel, color: UIColor.gray)
            Label.makeRoundLabel(label: cell.QuantityLevelLabel, color: UIColor.gray)
            Label.makeRoundLabel(label: cell.FlavorLevelLabel, color: UIColor.gray)
            Label.makeRoundLabel(label: cell.EventLabel, color: UIColor(red: CGFloat(255.0 / 255.0), green: CGFloat(120.0 / 255.0),  blue: CGFloat(0.0 / 255.0), alpha: CGFloat(1.0)))
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
            cell.PriceLevelLabel.text = self.priceLevelList[maxPriceLevel - 1]
            cell.FlavorLevelLabel.text = self.flavorLevelList[maxFlavorLevel - 1]
            cell.QuantityLevelLabel.text = self.quantityLevelList[maxQuantityLevel - 1]
            
            return cell
        }
        return RankingCollectionViewCell()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! RankingCollectionViewCell
        let indexRow = self.collectionView!.indexPath(for: cell)?.row
        if productList.count > 0 {
            let product = productList[indexRow!]
            NotificationCenter.default.post(name: NSNotification.Name("showProduct"), object: self, userInfo: ["product" : product])
        }
    }
}
extension RankingViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
}
