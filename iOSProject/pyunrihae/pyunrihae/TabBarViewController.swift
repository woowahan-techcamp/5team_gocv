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
    var mainViewController : UIViewController!
    var rankingViewController : UIViewController!
    var reviewViewController : UIViewController!
    var mypageViewController : UIViewController!
    var viewControllers : [UIViewController]! // 탭에 따른 뷰 컨트롤러
    var selectedTabIndex: Int = 0 // 선택된 뷰 컨트롤러 인덱스, 초기값은 0
    var selectedBrandIndex: Int = 0 // 선택된 브랜드 인덱스, 초기값은 0 (전체)
    let titleName = ["편리해","랭킹","리뷰","마이페이지"]
    @IBAction func didPressTabBtn(_ sender: UIButton) { // 탭 버튼 클릭
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
        } else {
            brandContentView.isHidden = false
        }
    }
    @IBAction func didPressBrandBtn(_ sender: UIButton) { // 브랜드 버튼 클릭 함수
        let previousBrandIndex = selectedBrandIndex
        selectedBrandIndex = sender.tag
        brandBtns[previousBrandIndex].isSelected = false
        Button.select(btn: sender) // 선택된 버튼에 따라 뷰 보여주기
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        mainViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController")
        rankingViewController = storyboard.instantiateViewController(withIdentifier: "RankingViewController")
        reviewViewController = storyboard.instantiateViewController(withIdentifier: "ReviewViewController")
        mypageViewController = storyboard.instantiateViewController(withIdentifier: "MypageViewController")
        viewControllers = [mainViewController,rankingViewController,reviewViewController,mypageViewController]
        Button.changeColor(btn: searchBtn, color: UIColor.white, imageName: "search.png") //서치 이미지 하얀색 틴트로 바꾸기
        Button.select(btn: brandBtns[selectedBrandIndex]) // 맨 처음 브랜드는 전체 선택된 것으로 나타나게 함
        didPressBrandBtn(brandBtns[selectedBrandIndex])
        Button.select(btn: tabBtns[selectedTabIndex])
        didPressTabBtn(tabBtns[selectedTabIndex])
        tabContentView.layer.zPosition = 10
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

