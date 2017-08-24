//
//  TabBarViewController.swift
//  pyunrihae
//
//  Created by woowabrothers on 2017. 8. 7..
//  Copyright © 2017년 busride. All rights reserved.
//

import UIKit
import FirebaseAuth
import NVActivityIndicatorView

class TabBarViewController: UIViewController,NVActivityIndicatorViewable {
    @IBOutlet weak var watingView: UIView!
    @IBOutlet weak var waitingImage: UIImageView!
    @IBOutlet weak var pyunrihaeImage: UIImageView!
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
    let category = ["전체","도시락","김밥","베이커리","라면","식품","스낵","아이스크림","음료"]
    var categoryIndex = 0
    var done = false
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
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
        reviewViewController.tableView.contentOffset.y = 0
        rankingViewController.selectedBrandIndexFromTab = selectedBrandIndex // 선택된 브랜드 index를 ranking에 넘겨주기
        rankingViewController.tableView.contentOffset.y = 0
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
    func animateView(){
        UIView.animate(withDuration: 2,delay: 1, animations: {
            self.pyunrihaeImage.alpha -= 1
        }, completion: { (complete:Bool) in
            if complete == true{
                self.pyunrihaeImage.isHidden = true
                if !self.done {
                    self.startAnimating()
                }
            }
        })
    }
    func doneLoading() {
        done = true
        brandContentView.isHidden = false
        tabContentView.isHidden = false
        self.stopAnimating()
        UIView.animate(withDuration: 0.5, delay: 0, animations: {
            self.waitingImage.alpha -= 1
            self.watingView.alpha -= 0.35
        }, completion: { (complete:Bool) in
            self.watingView.isHidden = true
            self.waitingImage.isHidden = true
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        brandContentView.isHidden = true
        tabContentView.isHidden = true
        saveProductListToGlobal()
        NVActivityIndicatorView.DEFAULT_BLOCKER_BACKGROUND_COLOR = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        NVActivityIndicatorView.DEFAULT_TYPE = .pacman
        NVActivityIndicatorView.DEFAULT_BLOCKER_MESSAGE = "편리해 정보를 받아오는 중입니다..."
        NotificationCenter.default.addObserver(self, selector: #selector(showRanking), name: NSNotification.Name("showRanking"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showCategory), name: NSNotification.Name("showCategory"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showReview), name: NSNotification.Name("showReview"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(doneLoading), name: NSNotification.Name("doneLoading"), object: nil)
        watingView.layer.zPosition = 15
        waitingImage.layer.zPosition = 10
        pyunrihaeImage.layer.zPosition = 20
        animateView()
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
        
        // Do any additional setup after loading the view.
        if Auth.auth().currentUser != nil {
            DataManager.getUserFromUID(uid: (Auth.auth().currentUser?.uid)!, completion: { (user) in
               self.appdelegate.user = user
            })
        } else {
            appdelegate.user = User()
        }
    }
    
    func saveProductListToGlobal(){
        DataManager.getProductAllInRank(){ (products) in
            self.appdelegate.productList = products.sorted(by: {$0.grade_avg > $1.grade_avg})
            NotificationCenter.default.post(name: NSNotification.Name("doneLoading"), object: self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

