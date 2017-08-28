//
//  ReviewViewController.swift
//  pyunrihae
//
//  Created by woowabrothers on 2017. 8. 7..
//  Copyright © 2017년 busride. All rights reserved.
//
import UIKit
class ReviewViewController: UIViewController {
    @IBOutlet weak var categoryScrollView: UIScrollView!
    @IBOutlet weak var reviewNumLabel: UILabel!
    @IBOutlet weak var sortingMethodLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    var scrollBar = UILabel()
    var reviewList : [Review] = []
    var review = Review()
    var categoryBtns = [UIButton]()
    var usefulNumLabel = UILabel()
    var badNumLabel = UILabel()
    var usefulBtn = UIButton()
    var badBtn = UIButton()
    var isLoaded = false
    var actInd: UIActivityIndicatorView = UIActivityIndicatorView()
    var selectedReview = Review()
    var selectedBrandIndexFromTab : Int = 0 {
        didSet{
            getReviewList()
        }
    }
    var selectedCategoryIndex: Int = 0 { // 선택된 카테고리 인덱스, 초기값은 0 (전체)
        didSet {
            getReviewList()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = true
        tableView.separatorStyle = .none
        categoryScrollView.backgroundColor = UIColor.white
        addCategoryBtn() // 카테고리 버튼 만들어서 스크롤 뷰에 붙이기
        Button.select(btn: categoryBtns[selectedCategoryIndex]) // 맨 처음 카테고리는 전체 선택된 것으로 나타나게 함
        didPressCategoryBtn(sender: categoryBtns[selectedCategoryIndex])
        isLoaded = true
        NotificationCenter.default.addObserver(self, selector: #selector(showDetailProduct), name: NSNotification.Name("showDetailProduct"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getReviewList), name: NSNotification.Name("reloadReview"), object: nil)
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func showDetailProduct(_ notification: Notification) {
        if notification.userInfo?["validator"] as! Int == 1{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "mainNavigationController") as! UINavigationController
            let transition = CATransition()
            transition.duration = 0.4
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromRight
            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            self.view.window!.layer.add(transition, forKey: kCATransition)
            self.present(vc, animated: false, completion: nil)
            NotificationCenter.default.post(name: NSNotification.Name("showReviewProduct"), object: self, userInfo: ["product" : review])
        }
    }
    @IBAction func tabDropDownBtn(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel)
        let orderByUpdate = UIAlertAction(title: "최신순", style: .default) { action -> Void in
            DispatchQueue.main.async {
                self.sortingMethodLabel.text  = "최신순"
                self.setReviewListOrder()
            }
        }
        let orderByUsefulNum = UIAlertAction(title: "유용순", style: .default) { action -> Void in
            DispatchQueue.main.async {
                self.sortingMethodLabel.text  = "유용순"
                self.setReviewListOrder()
            }
        }
        alert.addAction(cancelAction)
        alert.addAction(orderByUpdate)
        alert.addAction(orderByUsefulNum)
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
        self.actInd.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.gray
        view.addSubview(actInd)
        actInd.startAnimating()
    }
    func hideActivityIndicatory() {
        if view.subviews.contains(actInd){
            actInd.stopAnimating()
            view.willRemoveSubview(actInd)
        }
    }
    func getReviewList(){
        var brand = ""
        switch selectedBrandIndexFromTab {
            case 0 : brand = ""
            case 1 : brand = "GS25"
            case 2 : brand = "CU"
            case 3 : brand = "7-eleven"
            default : break
        }
        showActivityIndicatory()
        if tableView != nil {
            if selectedBrandIndexFromTab == 0  && selectedCategoryIndex == 0 { // 브랜드 : 전체 , 카테고리 : 전체 일때
                DataManager.getReviewList(completion:  { (reviews) in
                    self.reviewList = reviews
                    DispatchQueue.main.async {
                        self.setReviewNum()
                        self.setReviewListOrder()
                        self.hideActivityIndicatory()
                    }
                })
            } else if selectedBrandIndexFromTab == 0 { // 브랜드만 전체일 때
                if categoryBtns.count > 0 {
                    DataManager.getReviewListBy(category: (categoryBtns[selectedCategoryIndex].titleLabel?.text)!) { (reviews) in
                        self.reviewList = reviews
                        DispatchQueue.main.async {
                            self.setReviewNum()
                            self.setReviewListOrder()
                            self.hideActivityIndicatory()
                        }
                    }
                }
            } else if selectedCategoryIndex == 0 { // 카테고리만 전체일 때
                DataManager.getReviewListBy(brand: brand) { (reviews) in
                    self.reviewList = reviews
                    DispatchQueue.main.async {
                        self.setReviewNum()
                        self.setReviewListOrder()
                        self.hideActivityIndicatory()
                    }
                }
            } else { // 브랜드도 카테고리도 전체가 아닐 때
                if categoryBtns.count > 0 {
                    DataManager.getReviewListBy(brand: brand, category: (categoryBtns[selectedCategoryIndex].titleLabel?.text!)!) { (reviews) in
                        self.reviewList = reviews
                        DispatchQueue.main.async {
                            self.setReviewNum()
                            self.setReviewListOrder()
                            self.hideActivityIndicatory()
                        }
                    }
                }
            }
        }
    }
    func setReviewNum(){
        DispatchQueue.main.async{
            if self.reviewList.count > 0 {
                self.reviewNumLabel.text = self.reviewList.count.description + "개의 리뷰"
            }else{
                self.reviewNumLabel.text = "아직 리뷰가 없습니다."
            }
        }
    }
    func setReviewListOrder(){
        if sortingMethodLabel != nil {
            let format = DateFormatter()
            format.locale = Locale(identifier: "ko_kr")
            format.timeZone = TimeZone(abbreviation: "KST")
            format.dateFormat = "yyyy-MM-dd HH:mm:ss"
            if sortingMethodLabel.text == "최신순"{
                self.reviewList = reviewList.sorted(by: { (review1, review2) in
                    if format.date(from: review1.timestamp) != nil && format.date(from: review2.timestamp) != nil {
                         return format.date(from: review1.timestamp)! > format.date(from: review2.timestamp)!
                    }else{
                        return review1.id > review2.id
                    }
                })
            }else{
                self.reviewList = reviewList.sorted(by: { $0.useful > $1.useful })
            }
            self.tableView.reloadData()
        }
    }
}

extension ReviewViewController: UITableViewDataSource, UITableViewDelegate { //메인화면에서 1,2,3위 상품 보여주기
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewList.count;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell =  tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? ReviewTableViewCell {
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            let review = reviewList[indexPath.item]
            Label.showWrittenTime(timestamp: review.timestamp, timeLabel: cell.timeLabel)
            Image.makeCircleImage(image: cell.userImage)
            cell.userImage.contentMode = .scaleAspectFill
            cell.userImage.clipsToBounds = true
            cell.loading.startAnimating()
            cell.userImage.af_setImage(withURL: URL(string: review.user_image)!, placeholderImage: UIImage(), imageTransition: .crossDissolve(0.2), completion:{ image in
                cell.loading.stopAnimating()
            })
            cell.brandLabel.text = review.brand
            cell.productNameLabel.text = review.p_name
            cell.reviewContentLabel.text = review.comment
            cell.badLabel.text = review.bad.description
            cell.usefulLabel.text = review.useful.description
            Image.drawStar(numberOfPlaces: 1.0, grade_avg: Double(review.grade), gradeLabel: cell.gradeLabel, starView: cell.starView, needSpace: false)
            cell.reviewView.layer.cornerRadius = 15
            return cell
        }
        return ReviewTableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    // 리뷰를 눌렀을 때 전환하는 함수
    func handleTap(index: Int) {
        let popup: ReviewPopupView = UINib(nibName: "ReviewPopupView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! ReviewPopupView
        popup.validator = 1
        review = reviewList[index]
        Popup.showPopup(popup: popup, index: index, reviewList: reviewList, review: review, view: self.view)
        popup.badBtn.isEnabled = false
        popup.usefulBtn.isEnabled = false
        DataManager.getReviewBy(id: review.id){ (review) in
            popup.badNumLabel.text = String(review.bad)
            popup.usefulNumLabel.text = String(review.useful)
            self.usefulNumLabel = popup.usefulNumLabel
            self.badNumLabel = popup.badNumLabel
            self.usefulBtn = popup.usefulBtn
            self.badBtn = popup.badBtn
            Button.validateUseful(review: review, usefulBtn: self.usefulBtn, badBtn: self.badBtn, usefulNumLabel: self.usefulNumLabel, badNumLabel: self.badNumLabel)
            popup.badBtn.isEnabled = true
            popup.usefulBtn.isEnabled = true
            popup.badBtn.addTarget(self, action: #selector(self.didPressBadBtn), for: UIControlEvents.touchUpInside)
            popup.usefulBtn.addTarget(self, action: #selector(self.didPressUsefulBtn), for: UIControlEvents.touchUpInside)
            // 카카오톡 공유 버튼 누르기
            popup.kakaoShareBtn.addTarget(self, action: #selector(self.didPressKakaoShareBtn), for: UIControlEvents.touchUpInside)
        }
    }
    func didPressUsefulBtn(sender: UIButton) { //유용해요 버튼 누르기
        if appdelegate.user?.email == "" {
            let alert = UIAlertController(title: "로그인 후 이용해주세요!", message: "", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            Button.didPressUsefulBtn(sender: sender, reviewId: review.id, usefulNumLabel: usefulNumLabel, badNumLabel: badNumLabel, usefulBtn: usefulBtn, badBtn: badBtn, reviewList: reviewList)
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    func didPressBadBtn(sender: UIButton) { //별로에요 버튼 누르기
        if appdelegate.user?.email == "" {
            let alert = UIAlertController(title: "로그인 후 이용해주세요!", message: "", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            Button.didPressBadBtn(sender: sender, reviewId: review.id, usefulNumLabel: usefulNumLabel, badNumLabel: badNumLabel, usefulBtn: usefulBtn, badBtn: badBtn, reviewList: reviewList)
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    func didPressKakaoShareBtn(sender: UIButton) { //카카오톡 공유 버튼 클릭 이벤트
        DataManager.sendLinkFeed(review: review)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        handleTap(index: indexPath.row)
    }
}
