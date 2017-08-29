//
//  PyunrihaeInfoViewController.swift
//  pyunrihae
//
//  Created by woowabrothers on 2017. 8. 22..
//  Copyright © 2017년 busride. All rights reserved.
//
import UIKit
class PyunrihaeInfoViewController: UIViewController {
    @IBAction func onTouchCloseBtn(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right: self.navigationController?.popToRootViewController(animated: true)
            default: break
            }
        }
    }
}
