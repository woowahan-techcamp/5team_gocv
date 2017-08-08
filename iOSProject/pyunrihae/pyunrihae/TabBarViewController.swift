//
//  TabBarViewController.swift
//  pyunrihae
//
//  Created by woowabrothers on 2017. 8. 7..
//  Copyright © 2017년 busride. All rights reserved.
//

import UIKit

class TabBarViewController: UIViewController {

    @IBOutlet var contentView: UIView!
    @IBOutlet var tabBtns : [UIButton]! // 탭 메뉴 버튼 4개
    var mainViewController : UIViewController!
    var rankingViewController : UIViewController!
    var reviewViewController : UIViewController!
    var mypageViewController : UIViewController!
    var viewControllers : [UIViewController]! // 탭에 따른 뷰 컨트롤러
    var selectedIndex: Int = 0 // 선택된 뷰 컨트롤러 인덱스, 초기값은 0
    @IBAction func didPressTabBtn(_ sender: UIButton) { // 탭 버튼 클릭
        let previousIndex = selectedIndex // 기존의 탭 뷰 숨기기
        selectedIndex = sender.tag
        tabBtns[previousIndex].isSelected = false
        let previousVC = viewControllers[previousIndex]
        previousVC.willMove(toParentViewController: nil)
        previousVC.view.removeFromSuperview()
        previousVC.removeFromParentViewController()
        Button.select(Btn: sender) // 선택된 탭 뷰 보여주기
        let vc = viewControllers[selectedIndex]
        addChildViewController(vc)
        vc.view.frame = contentView.bounds
        contentView.addSubview(vc.view)
        vc.didMove(toParentViewController: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        mainViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController")
        rankingViewController = storyboard.instantiateViewController(withIdentifier: "RankingViewController")
        reviewViewController = storyboard.instantiateViewController(withIdentifier: "ReviewViewController")
        mypageViewController = storyboard.instantiateViewController(withIdentifier: "MypageViewController")
        viewControllers = [mainViewController,rankingViewController,reviewViewController,mypageViewController]
        Button.select(Btn: tabBtns[selectedIndex])
        didPressTabBtn(tabBtns[selectedIndex])
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

