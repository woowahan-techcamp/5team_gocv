//
//  ReviewViewController.swift
//  pyunrihae
//
//  Created by woowabrothers on 2017. 8. 7..
//  Copyright © 2017년 busride. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class ReviewViewController: UIViewController {
    @IBOutlet weak var categoryScrollView: UIScrollView!
    @IBOutlet weak var reviewNumLabel: UILabel!
    @IBOutlet weak var sortingMethodLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var scrollBar = UILabel()
    var reviewList : [Review] = []
    var categoryBtns = [UIButton]()
    let category = ["전체","도시락","김밥","베이커리","라면","식품","스낵","아이스크림","음료"]
    var isLoaded = false
    var actInd: UIActivityIndicatorView = UIActivityIndicatorView()
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
        // Do any additional setup after loading the view.
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func tabDropDownBtn(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            
        }
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
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut,animations: {
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
        self.tableView.contentOffset.y = 0
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
                categoryScrollView.contentOffset.x = CGFloat(70 * self.category.count) - self.view.frame.size.width
            } else {
                categoryScrollView.contentOffset.x = CGFloat((selectedCategoryIndex - 1) * 40)
            }
            scrollBar.frame.origin.x = CGFloat(selectedCategoryIndex * 70 + 15)
        }
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
        default : break;
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
            
            let format = DateFormatter()
            format.locale = Locale(identifier: "ko_kr")
            format.timeZone = TimeZone(abbreviation: "KST")
            format.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            if let writtenDate = format.date(from: review.timestamp) {
                if writtenDate.timeIntervalSinceNow >= -5 * 24 * 60 * 60 {
                    if writtenDate.timeIntervalSinceNow <= -1 * 24 * 60 * 60 {
                        let daysAgo = Int(-writtenDate.timeIntervalSinceNow / 24 / 60 / 60)
                        cell.timeLabel.text = String(daysAgo) + "일 전"
                    } else if writtenDate.timeIntervalSinceNow <= -1 * 60 * 60 {
                        let hoursAgo = Int(-writtenDate.timeIntervalSinceNow / 60 / 60)
                        cell.timeLabel.text = String(hoursAgo) + "시간 전"
                    } else if writtenDate.timeIntervalSinceNow <= -1 * 60{
                        let minutesAgo = Int(-writtenDate.timeIntervalSinceNow / 60)
                        cell.timeLabel.text = String(minutesAgo) + "분 전"
                    } else{
                        cell.timeLabel.text = "방금"
                    }
                } else {
                    cell.timeLabel.text = review.timestamp.components(separatedBy: " ")[0]
                }
            }
            cell.userImage.layer.cornerRadius = cell.userImage.frame.height/2
            cell.userImage.clipsToBounds = true
            
            cell.loading.startAnimating()
            cell.userImage.contentMode = .scaleAspectFit
            cell.userImage.af_setImage(withURL: URL(string: review.user_image)!, placeholderImage: UIImage(), imageTransition: .crossDissolve(0.2), completion:{ image in
                cell.loading.stopAnimating()
            })
            cell.brandLabel.text = review.brand
            cell.productNameLabel.text = review.p_name
            cell.reviewContentLabel.text = review.comment
            cell.badLabel.text = review.bad.description
            cell.usefulLabel.text = review.useful.description
           
            for sub in cell.starView.subviews {
                sub.removeFromSuperview()
            }
            let grade = Double(review.grade)
            cell.gradeLabel.text = String(grade)
            for i in 0..<Int(grade) {
                let starImage = UIImage(named: "stars.png")
                let cgImage = starImage?.cgImage
                let croppedCGImage: CGImage = cgImage!.cropping(to: CGRect(x: 0, y: 0, width: (starImage?.size.width)! / 5, height: starImage!.size.height))!
                let uiImage = UIImage(cgImage: croppedCGImage)
                let imageView = UIImageView(image: uiImage)
                imageView.frame = CGRect(x: i*18, y: 0, width: 18, height: 15)
                cell.starView.addSubview(imageView)
            }
            if grade - Double(Int(grade)) >= 0.5 {
                let starImage = UIImage(named: "stars.png")
                let cgImage = starImage?.cgImage
                let croppedCGImage: CGImage = cgImage!.cropping(to: CGRect(x: (starImage?.size.width)! * 4 / 5, y: 0, width: (starImage?.size.width)!, height: starImage!.size.height))!
                let uiImage = UIImage(cgImage: croppedCGImage)
                let imageView = UIImageView(image: uiImage)
                imageView.frame = CGRect(x: Int(grade)*18 - 3, y: 0, width: 18, height: 15)
                cell.starView.addSubview(imageView)
            }
            cell.reviewView.layer.cornerRadius = 15
            return cell
        }
        return ReviewTableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! ReviewTableViewCell
        let indexRow = self.tableView!.indexPath(for: cell)?.row
        if reviewList.count > 0 {
            let product = reviewList[indexRow!]
            NotificationCenter.default.post(name: NSNotification.Name("showReviewProduct"), object: self, userInfo: ["product" : product])
        }
    }
}
