//
//  MainViewController.swift
//  pyunrihae
//
//  Created by woowabrothers on 2017. 8. 4..
//  Copyright © 2017년 busride. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet var searchBtn : UIButton!
    @IBOutlet var brandBtns : [UIButton]! // 브랜드 메뉴 버튼 4개
    @IBOutlet weak var showAllBtn: UIButton!
    @IBOutlet weak var reviewImageView: UIScrollView!
    @IBOutlet weak var collectionView : UICollectionView!
    @IBOutlet weak var categoryScrollView: CategoryScrollView!
    @IBAction func didPressBrandBtn(_ sender: UIButton) { // 브랜드 버튼 클릭 함수
        let previousBrandIndex = selectedBrandIndex
        selectedBrandIndex = sender.tag
        brandBtns[previousBrandIndex].isSelected = false
        Button.select(Btn: sender) // 선택된 버튼에 따라 뷰 보여주기
    }
    var selectedBrandIndex: Int = 0 // 선택된 브랜드 인덱스, 초기값은 0 (전체)
    var selectedCategoryIndex: Int = 0 // 선택된 카테고리 인덱스, 초기값은 0 (전체)
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
        Button.select(Btn: sender) // 선택된 버튼에 따라 뷰 보여주기
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        addCategoryBtn() // 카테고리 버튼 만들어서 스크롤 뷰에 붙이기
        searchBtn.changeColor(color: UIColor.white, imageName: "search.png") //서치 이미지 하얀색 틴트로 바꾸기
        Button.select(Btn: brandBtns[selectedBrandIndex]) // 맨 처음 브랜드는 전체 선택된 것으로 나타나게 함
        didPressBrandBtn(brandBtns[selectedBrandIndex])
        Button.select(Btn: categoryBtns[selectedCategoryIndex]) // 맨 처음 카테고리는 전체 선택된 것으로 나타나게 함
        didPressCategoryBtn(sender: categoryBtns[selectedCategoryIndex])
        reviewImageView.backgroundColor = UIColor.lightGray
        showAllBtn.layer.borderColor = UIColor.lightGray.cgColor
        showAllBtn.layer.borderWidth = 1
        categoryScrollView.backgroundColor = UIColor.white
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
            //임의로 사진 넣어놨음
                cell.foodImage.image = UIImage(named: "search.png")
                cell.foodImage.backgroundColor = UIColor.lightGray
            //
            cell.rankLabel.layer.cornerRadius = cell.rankLabel.frame.height/2
            cell.rankLabel.layer.masksToBounds = true
            if indexPath.row == 0{
                cell.rankLabel.text = "1위"
                cell.rankLabel.backgroundColor = UIColor.orange
                cell.rankLabel.textColor = UIColor.white
            } else if indexPath.row == 1{
                cell.rankLabel.text = "2위"
                cell.rankLabel.backgroundColor = UIColor.lightGray
                cell.rankLabel.textColor = UIColor.white
            } else {
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
extension UIButton {
    func changeColor(color: UIColor, imageName: String){
        let origImage = UIImage(named: imageName);
        let tintedImage = origImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        self.setImage(tintedImage, for: .normal)
        self.tintColor = color
    }
}
