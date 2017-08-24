//
//  RankingViewController.swift
//  pyunrihae
//
//  Created by woowabrothers on 2017. 8. 7..
//  Copyright © 2017년 busride. All rights reserved.
//

import UIKit

class RankingViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var categoryScrollView: UIScrollView!
    @IBOutlet weak var productNumLabel: UILabel!
    @IBOutlet weak var sortingMethodLabel: UILabel!
    @IBAction func tabDropDownBtn(_ sender: UIButton) {
        let alert = UIAlertController(title: "\r순서 정렬하기", message: "", preferredStyle: .actionSheet)
        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            
        }
        let orderByRanking = UIAlertAction(title: "평점순", style: .default) { action -> Void in
            DispatchQueue.main.async {
                self.sortingMethodLabel.text  = "평점순"
                self.setRankingListOrder()
            }
        }
        let orderByPrice = UIAlertAction(title: "낮은 가격순", style: .default) { action -> Void in
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
    
    let appdelegate = UIApplication.shared.delegate as! AppDelegate

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
    var scrollBar = UILabel()
    var actInd: UIActivityIndicatorView = UIActivityIndicatorView()
    let category = ["전체","도시락","김밥","베이커리","라면","식품","스낵","아이스크림","음료"]
    func addCategoryBtn(){ // 카테고리 버튼 스크롤 뷰에 추가하기
        categoryScrollView.isScrollEnabled = true
        categoryScrollView.contentSize.width = CGFloat(70 * category.count)
        for index in 0..<category.count {
            let categoryBtn = UIButton(frame: CGRect(x: 70 * index, y: 5, width: 70, height: 40))
            categoryBtn.setTitle(category[index], for: .normal) // 카테고리 버튼 텍스트
            categoryBtn.setTitleColor(UIColor.darkGray, for: .normal) // 카테고리 버튼 텍스트 색깔
            categoryBtn.contentHorizontalAlignment = .center // 카테고리 버튼 중앙정렬
            categoryBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15) // 카테고리 버튼 폰트 크기 15
            categoryBtn.tag = index // 버튼 태그 생성해주기
            categoryBtns.append(categoryBtn)
            categoryBtn.addTarget(self, action: #selector(didPressCategoryBtn), for: UIControlEvents.touchUpInside)
            categoryScrollView.addSubview(categoryBtn)
        }
        scrollBar.frame = CGRect(x: 15, y: 40, width: 40, height: 2)
        let color = UIColor(red: CGFloat(255.0 / 255.0), green: CGFloat(120.0 / 255.0),  blue: CGFloat(0.0 / 255.0), alpha: CGFloat(Float(1)))
        scrollBar.backgroundColor = color
        categoryScrollView.addSubview(scrollBar)
        categoryScrollView.showsHorizontalScrollIndicator = false // 스크롤 바 없애기
    }
    func didPressCategoryBtn(sender: UIButton) { // 카테고리 버튼 클릭 함수
        let previousCategoryIndex = selectedCategoryIndex
        selectedCategoryIndex = sender.tag
        categoryBtns[previousCategoryIndex].isSelected = false
        Button.select(btn: sender) // 선택된 버튼에 따라 뷰 보여주기
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut,animations: {
            if sender.tag == 0 || sender.tag == 1 || sender.tag == 2 {
                self.categoryScrollView.contentOffset.x = CGFloat(0)
            } else if sender.tag == 6 || sender.tag == 7 || sender.tag == 8 {
                self.categoryScrollView.contentOffset.x = CGFloat(70 * self.category.count) - self.view.frame.size.width
            } else {
                self.categoryScrollView.contentOffset.x = CGFloat((sender.tag - 1) * 40)
            }
            self.scrollBar.frame.origin.x = CGFloat(self.selectedCategoryIndex * 70 + 15)
        },completion: nil)
        NotificationCenter.default.post(name: NSNotification.Name("showCategory"), object: self, userInfo: ["category" : selectedCategoryIndex])
    }
    func selectCategory(_ notification: Notification){
        let previousCategoryIndex = selectedCategoryIndex
        selectedCategoryIndex = notification.userInfo?["category"] as! Int
        if isLoaded {
            categoryBtns[previousCategoryIndex].isSelected = false
            Button.select(btn: categoryBtns[selectedCategoryIndex])
            if selectedCategoryIndex == 0 || selectedCategoryIndex == 1 || selectedCategoryIndex == 2 {
                categoryScrollView.contentOffset.x = CGFloat(0)
            } else if selectedCategoryIndex == 6 || selectedCategoryIndex == 7 || selectedCategoryIndex == 8 {
                categoryScrollView.contentOffset.x = CGFloat(7 * 35)
            } else {
                categoryScrollView.contentOffset.x = CGFloat((selectedCategoryIndex - 1) * 40)
            }
            scrollBar.frame.origin.x = CGFloat(selectedCategoryIndex * 70 + 15)
        }
    }
    func addNotiObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(selectCategory), name: NSNotification.Name("selectCategory"), object: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
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
        case 1 : brand = "GS25"
        case 2 : brand = "CU"
        case 3 : brand = "7-eleven"
        default : break;
        }
        
        self.showActivityIndicatory()
        
        if tableView != nil {
            if selectedBrandIndexFromTab == 0  && selectedCategoryIndex == 0 { // 브랜드 : 전체 , 카테고리 : 전체 일때
                self.productList = []
                self.productList = self.appdelegate.productList
                DispatchQueue.main.async {
                    self.setRankingNum()
                    self.setRankingListOrder()
                    self.hideActivityIndicatory()
                }
                }
            else if selectedBrandIndexFromTab == 0 { // 브랜드만 전체일 때
                self.productList = []
                if categoryBtns.count > 0 {
                    for product in self.appdelegate.productList {
                        if product.category == categoryBtns[selectedCategoryIndex].titleLabel?.text!{
                            self.productList.append(product)
                        }
                    }
                    DispatchQueue.main.async {
                        self.setRankingNum()
                        self.setRankingListOrder()
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
                    self.setRankingNum()
                    self.setRankingListOrder()
                    self.hideActivityIndicatory()
                }

            } else { // 브랜드도 카테고리도 전체가 아닐 때
                self.productList = []
                for product in self.appdelegate.productList {
                    if product.category == categoryBtns[selectedCategoryIndex].titleLabel?.text! && product.brand == brand{
                        self.productList.append(product)
                    }
                }
                DispatchQueue.main.async {
                    self.setRankingNum()
                    self.setRankingListOrder()
                    self.hideActivityIndicatory()
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
            
            if sortingMethodLabel.text == "평점순"{
                self.productList = productList.sorted(by: { $0.grade_avg > $1.grade_avg })
            }else{
                // 멈출 위험이 있음.
                for product in productList {
                    if product.price == ""{
                        return
                    }
                }
                
                self.productList = productList.sorted(by: { Int($0.price)! < Int($1.price)! })
            }
            
            self.tableView.reloadData()
        }
    }


    
}

extension RankingViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productList.count;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell =  tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? RankingTableViewCell {
            cell.selectionStyle = UITableViewCellSelectionStyle.none
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
            
            
            if product.event != "\r" {
                cell.EventLabel.isHidden = false
                cell.EventLabel.text = product.event

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
                if priceLevelDict.count > 0  && priceLevelDict[p]! > maxPriceNum {
                    maxPriceLevel = i
                    maxPriceNum = priceLevelDict[p]!
                }
                if  flavorLevelDict.count > 0  && flavorLevelDict[f]! > maxFlavorNum {
                    maxFlavorLevel = i
                    maxFlavorNum = flavorLevelDict[f]!
                }
                if  quantityLevelDict.count > 0  && quantityLevelDict[q]! > maxQuantityNum {
                    maxQuantityLevel = i
                    maxQuantityNum = quantityLevelDict[q]!
                }
            }
            cell.PriceLevelLabel.text = self.priceLevelList[maxPriceLevel - 1]
            cell.FlavorLevelLabel.text = self.flavorLevelList[maxFlavorLevel - 1]
            cell.QuantityLevelLabel.text = self.quantityLevelList[maxQuantityLevel - 1]
            
            return cell
        }
        return RankingTableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! RankingTableViewCell
        let indexRow = self.tableView!.indexPath(for: cell)?.row
        if productList.count > 0 {
            let product = productList[indexRow!]
            NotificationCenter.default.post(name: NSNotification.Name("showProduct"), object: self, userInfo: ["product" : product])
        }
    }
}
