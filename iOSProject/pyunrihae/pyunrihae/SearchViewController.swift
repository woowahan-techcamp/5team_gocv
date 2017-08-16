//
//  SearchViewController.swift
//  pyunrihae
//
//  Created by woowabrothers on 2017. 8. 14..
//  Copyright © 2017년 busride. All rights reserved.
//

import UIKit


class SearchViewController: YNSearchViewController,YNSearchDelegate {

    @IBAction func onBackBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let demoCategories = ["도시락","김밥","베이커리","라면","즉석식품","스낵","유제품","음료"]
        
        let ynSearch = YNSearch()
        let historyList = ynSearch.getSearchHistories()
        ynSearch.setCategories(value: demoCategories)
        ynSearch.setSearchHistories(value: historyList!)
        

        self.ynSearchinit()
        
        self.delegate = self
        
        self.ynSearchView.ynSearchMainView.redrawSearchHistoryButtons()
        
        var db : [YNSearchModel] = []
        
        DataManager.getProductAllInRank()  { (products) in
            
            for product in products {
                let searchModel  = YNSearchModel.init(key: product.name,id : product.id)
                db.append(searchModel)
            }
            DispatchQueue.main.async {
                self.initData(database: db)
                self.setYNCategoryButtonType(type: YNCategoryButtonType.border)
            }
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func ynSearchListViewDidScroll() {
        self.ynSearchTextfieldView.ynSearchTextField.endEditing(true)
    }
    
    
    func ynSearchHistoryButtonClicked(text: String) {
        // 검색 history가 카테고리와 같으면 카테고리로 보냄
        
        let demoCategories = ["도시락","김밥","베이커리","라면","즉석식품","스낵","유제품","음료"]
        
        for category in demoCategories {
            if text == category {
                pushRankingController(text: text)
            }
        }
        
        pushViewControllerFromProductName(text : text)
  
    }
    
    
    func ynCategoryButtonClicked(text: String) {
       pushRankingController(text: text)
    }
    
    func ynSearchListViewClicked(key: String) {
        self.pushViewController(text: key)
    }
    
    func ynSearchListViewClicked(object: Any) {
    }
    
    func ynSearchListView(_ ynSearchListView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.ynSearchView.ynSearchListView.dequeueReusableCell(withIdentifier: YNSearchListViewCell.ID) as! YNSearchListViewCell
        if let ynmodel = self.ynSearchView.ynSearchListView.searchResultDatabase[indexPath.row] as? YNSearchModel {
            cell.searchLabel.text = ynmodel.key
        }
        
        return cell
    }
    
    func ynSearchListView(_ ynSearchListView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let ynmodel = self.ynSearchView.ynSearchListView.searchResultDatabase[indexPath.row] as? YNSearchModel, let key = ynmodel.key {
            let id = ynmodel.id!
            self.ynSearchView.ynSearchListView.ynSearchListViewDelegate?.ynSearchListViewClicked(key: id)
            self.ynSearchView.ynSearchListView.ynSearchListViewDelegate?.ynSearchListViewClicked(object: self.ynSearchView.ynSearchListView.database[indexPath.row])
            self.ynSearchView.ynSearchListView.ynSearch.appendSearchHistories(value: key)
        }
    }
    
    func pushViewController(text:String) {
        SelectedProduct.foodId = text
        SelectedProduct.reviewCount = 0
        DataManager.getReviewListBy(id: text) { (reviewList) in
            SelectedProduct.reviewCount = reviewList.count
            NotificationCenter.default.post(name: NSNotification.Name("complete"), object: self)
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "mainNavigationController") as! UINavigationController
        self.present(vc, animated: true, completion: nil)
    }
    
    func pushRankingController(text : String) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
        switch (text){
        case "도시락" : vc.categoryIndex = 1
        case "김밥" : vc.categoryIndex = 2
        case "베이커리" : vc.categoryIndex = 3
        case "라면": vc.categoryIndex = 4
        case "즉석식품" : vc.categoryIndex = 5
        case "스낵" : vc.categoryIndex = 6
        case "유제품" : vc.categoryIndex = 7
        case "음료" : vc.categoryIndex = 8
        default : vc.categoryIndex = 0
        }
        
        vc.selectedTabIndex = 1
        self.present(vc, animated: true, completion : nil )
    }
    
    func pushViewControllerFromProductName(text : String) {
        DataManager.getProductId(from: text) { (productId) in
            SelectedProduct.foodId = productId
            SelectedProduct.reviewCount = 0
            DataManager.getReviewListBy(id: text) { (reviewList) in
                SelectedProduct.reviewCount = reviewList.count
                NotificationCenter.default.post(name: NSNotification.Name("complete"), object: self)
            }
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "mainNavigationController") as! UINavigationController
            self.present(vc, animated: true, completion: nil)
        }
    }
}
