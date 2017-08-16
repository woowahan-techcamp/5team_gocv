//
//  TabBarViewController.swift
//  pyunrihae
//
//  Created by woowabrothers on 2017. 8. 7..
//  Copyright © 2017년 busride. All rights reserved.
//

import UIKit

class TabBarViewController: UIViewController {
    @IBOutlet var searchBtn : UIButton!
    @IBOutlet var titleLabel : UILabel!
    @IBOutlet var brandBtns : [UIButton]! // 브랜드 메뉴 버튼 4개
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var brandContentView: UIView!
    @IBOutlet weak var tabContentView: UIView!
    @IBOutlet var tabBtns : [UIButton]! // 탭 메뉴 버튼 4개
    var mainViewController : MainViewController!
    var rankingViewController : RankingViewController!
    var reviewViewController : ReviewViewController!
    var mypageViewController : MypageViewController!
    var productDetailViewController : ProductDetailViewController!
    var viewControllers : [UIViewController]! // 탭에 따른 뷰 컨트롤러
    var selectedTabIndex: Int = 0 // 선택된 뷰 컨트롤러 인덱스, 초기값은 0
    var selectedBrandIndex: Int = 0 // 선택된 브랜드 인덱스, 초기값은 0 (전체)
    let titleName = ["편리해","랭킹","리뷰","마이페이지"]
    let category = ["전체","도시락","김밥","베이커리","라면","즉석식품","스낵","유제품","음료"]
    var categoryIndex = 0
    @IBAction func didPressTabBtn(_ sender: UIButton) { // 탭 버튼 클릭
        NotificationCenter.default.post(name: NSNotification.Name("selectCategory"), object: self, userInfo: ["category" : categoryIndex])
        let previousIndex = selectedTabIndex // 기존의 탭 뷰 숨기기
        selectedTabIndex = sender.tag
        tabBtns[previousIndex].isSelected = false
        let previousVC = viewControllers[previousIndex]
        previousVC.willMove(toParentViewController: nil)
        previousVC.view.removeFromSuperview()
        previousVC.removeFromParentViewController()
        Button.select(btn: sender) // 선택된 탭 뷰 보여주기
        let vc = viewControllers[selectedTabIndex]
        addChildViewController(vc)
        vc.view.frame = contentView.bounds
        contentView.addSubview(vc.view)
        vc.didMove(toParentViewController: self)
        titleLabel.text = titleName[selectedTabIndex]
        if selectedTabIndex == 3 {
            brandContentView.isHidden = true
            vc.view.frame.origin.y -= 40
        } else {
            brandContentView.isHidden = false
        }
    }
    @IBAction func didPressBrandBtn(_ sender: UIButton) { // 브랜드 버튼 클릭 함수
        let previousBrandIndex = selectedBrandIndex
        selectedBrandIndex = sender.tag
        brandBtns[previousBrandIndex].isSelected = false
        Button.select(btn: sender) // 선택된 버튼에 따라 뷰 보여주기
        mainViewController.selectedBrandIndexFromTab = selectedBrandIndex // 선택된 브랜드 index를 main에 넘겨주기
        reviewViewController.selectedBrandIndexFromTab = selectedBrandIndex // 선택된 브랜드 index를 review 에 넘겨주기 
        rankingViewController.selectedBrandIndexFromTab = selectedBrandIndex // 선택된 브랜드 index를 ranking에 넘겨주기
    }

    func showRanking(_ notification: Notification){
        didPressTabBtn(tabBtns[1])
    }
    func showCategory(_ notification: Notification){
        categoryIndex = notification.userInfo?["category"] as! Int
    }
    func showReview(_ notification: Notification){
        didPressTabBtn(tabBtns[2])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        mainViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        mainViewController.selectedBrandIndexFromTab = selectedBrandIndex
        rankingViewController = storyboard.instantiateViewController(withIdentifier: "RankingViewController") as! RankingViewController
        rankingViewController.selectedBrandIndexFromTab = selectedBrandIndex
        
        reviewViewController = storyboard.instantiateViewController(withIdentifier: "ReviewViewController") as! ReviewViewController
        reviewViewController.selectedBrandIndexFromTab = selectedBrandIndex
        
        mypageViewController = storyboard.instantiateViewController(withIdentifier: "MypageViewController") as! MypageViewController
        productDetailViewController = storyboard.instantiateViewController(withIdentifier: "ProductDetailViewController") as! ProductDetailViewController
        productDetailViewController.addNotiObserver()
        rankingViewController.addNotiObserver()
        reviewViewController.addNotiObserver() // 옵저버 미리 등록시켜주기
        viewControllers = [mainViewController,rankingViewController,reviewViewController,mypageViewController]
        Button.select(btn: brandBtns[selectedBrandIndex]) // 맨 처음 브랜드는 전체 선택된 것으로 나타나게 함
        didPressBrandBtn(brandBtns[selectedBrandIndex])
        Button.select(btn: tabBtns[selectedTabIndex])
        didPressTabBtn(tabBtns[selectedTabIndex])
        tabContentView.layer.zPosition = 10
        NotificationCenter.default.addObserver(self, selector: #selector(showRanking), name: NSNotification.Name("showRanking"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showCategory), name: NSNotification.Name("showCategory"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showReview), name: NSNotification.Name("showReview"), object: nil)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

