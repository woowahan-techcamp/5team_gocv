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
    var selectedCategoryIndex: Int = 0 // 선택된 카테고리 인덱스, 초기값은 0 (전체)
    var categoryBtns = [UIButton]()
    let category = ["전체","도시락","김밥","베이커리","라면","즉석식품","스낵","유제품","음료"]
    let notiKey = NSNotification.Name(rawValue: "dataGetComplete")
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
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        NotificationCenter.default.addObserver(self, selector: #selector(selectCategory), name: NSNotification.Name("selectCategory"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(reloadCollectionView), name: notiKey, object: nil)
        categoryScrollView.backgroundColor = UIColor.white
        addCategoryBtn() // 카테고리 버튼 만들어서 스크롤 뷰에 붙이기
        Button.select(btn: categoryBtns[selectedCategoryIndex]) // 맨 처음 카테고리는 전체 선택된 것으로 나타나게 함
        didPressCategoryBtn(sender: categoryBtns[selectedCategoryIndex])
        reviewImageView.backgroundColor = UIColor.lightGray
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
    
//    func reloadCollectionView(){
//        collectionView.reloadData()
//    }
    
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
            //임의로 사진 넣어놨음
//                cell.foodImage.image = UIImage(named: "search.png")
                cell.foodImage.backgroundColor = UIColor.lightGray
            //
            cell.rankLabel.layer.cornerRadius = cell.rankLabel.frame.height/2
            cell.rankLabel.layer.masksToBounds = true
            if indexPath.row == 0{
                if productList.count > 0 {
                    // 리로드 시에 이미지가 있으면
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
