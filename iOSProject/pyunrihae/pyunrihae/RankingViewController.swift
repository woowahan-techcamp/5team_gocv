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
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    var isLoaded = false
    var productList : [Product] = []
    var categoryBtns = [UIButton]()
    var scrollBar = UILabel()
    var actInd: UIActivityIndicatorView = UIActivityIndicatorView()
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
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        categoryScrollView.backgroundColor = UIColor.white
        addCategoryBtn() // 카테고리 버튼 만들어서 스크롤 뷰에 붙이기
        Button.select(btn: categoryBtns[selectedCategoryIndex]) // 맨 처음 카테고리는 전체 선택된 것으로 나타나게 함
        didPressCategoryBtn(sender: categoryBtns[selectedCategoryIndex])
        isLoaded = true
        NotificationCenter.default.addObserver(self, selector: #selector(getRankingList), name: NSNotification.Name("productListChanged"), object: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func tabDropDownBtn(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel)
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
    func addCategoryBtn(){ // 카테고리 버튼 스크롤 뷰에 추가하기
        categoryBtns = Button.addCategoryBtn(view: self.view, categoryScrollView: categoryScrollView, category: appdelegate.category, scrollBar: scrollBar)
        for i in 0..<categoryBtns.count {
            categoryBtns[i].addTarget(self, action: #selector(didPressCategoryBtn), for: UIControlEvents.touchUpInside)
        }
    }
    func didPressCategoryBtn(sender: UIButton) { // 카테고리 버튼 클릭 함수
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut,animations: {
            Button.selectCategory(view: self.view, previousIndex: self.selectedCategoryIndex, categoryBtns: self.categoryBtns, selectedCategoryIndex: sender.tag, categoryScrollView: self.categoryScrollView, scrollBar: self.scrollBar)
            self.selectedCategoryIndex = sender.tag
        },completion: nil)
        NotificationCenter.default.post(name: NSNotification.Name("showCategory"), object: self, userInfo: ["category" : selectedCategoryIndex])
        tableView.contentOffset.y = 0
    }
    func selectCategory(_ notification: Notification){
        Button.selectCategory(view: self.view, previousIndex: selectedCategoryIndex, categoryBtns: categoryBtns, selectedCategoryIndex: notification.userInfo?["category"] as! Int, categoryScrollView: categoryScrollView, scrollBar: scrollBar)
        selectedCategoryIndex = notification.userInfo?["category"] as! Int
        self.tableView.contentOffset.y = 0
    }
    func addNotiObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(selectCategory), name: NSNotification.Name("selectCategory"), object: nil)
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
            default : break
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
            } else if selectedBrandIndexFromTab == 0 { // 브랜드만 전체일 때
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
            Image.makeCircleImage(image: cell.foodImage)
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
            Image.drawStar(numberOfPlaces: 2.0, grade_avg: Double(product.grade_avg), gradeLabel: cell.gradeLabel, starView: cell.starView)
            Label.makeRoundLabel(label: cell.PriceLevelLabel, color: UIColor.gray)
            Label.makeRoundLabel(label: cell.QuantityLevelLabel, color: UIColor.gray)
            Label.makeRoundLabel(label: cell.FlavorLevelLabel, color: UIColor.gray)
            Label.makeRoundLabel(label: cell.EventLabel, color: appdelegate.mainColor)
            Label.showLevel(PriceLevelLabel: cell.PriceLevelLabel, FlavorLevelLabel: cell.FlavorLevelLabel, QuantityLevelLabel: cell.QuantityLevelLabel, priceLevelDict: product.price_level, flavorLevelDict: product.flavor_level, quantityLevelDict: product.quantity_level)
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
