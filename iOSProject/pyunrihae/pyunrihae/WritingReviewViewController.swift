//
//  WritingReviewViewController.swift
//  pyunrihae
//
//  Created by woowabrothers on 2017. 8. 9..
//  Copyright © 2017년 busride. All rights reserved.
//

import UIKit

class WritingReviewViewController: UIViewController {

    @IBOutlet weak var starView: UIView!
    @IBAction func tabBackBtn(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func tabCompleteBtn(_ sender: UIButton) {
    }
    @IBOutlet weak var scrollView: UIScrollView!
    let priceLevel = ["비싸다","비싼편","적당","싼편","싸다"]
    let flavorLevel = ["노맛","별로","적당","괜춘","존맛"]
    let quantityLevel = ["창렬","적음","적당","많음","혜자"]
    var allergy = [String]()
    var starBtns = [UIButton]()
    func addStarBtn() {
        for i in 0..<5 {
            let starBtn = UIButton()
            starBtn.frame = CGRect(x: i*45, y: 0, width: 25, height: 25)
            Button.changeColor(btn: starBtn, color: UIColor.lightGray, imageName: "star.png")
            starBtn.addTarget(self, action: #selector(didPressStarBtn), for: UIControlEvents.touchUpInside)
            starBtn.tag = i
            starBtns.append(starBtn)
            starView.addSubview(starBtn)
        }
    }
    func didPressStarBtn (sender: UIButton) {
        for i in 0...sender.tag {
            Button.changeColor(btn: starBtns[i], color: UIColor.orange, imageName: "star.png")
        }
        for i in (sender.tag + 1)..<5 {
            Button.changeColor(btn: starBtns[i], color: UIColor.lightGray, imageName: "star.png")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.isScrollEnabled = true
        addStarBtn()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
