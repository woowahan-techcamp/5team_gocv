//
//  LoginSignUpViewController.swift
//  pyunrihae
//
//  Created by woowabrothers on 2017. 8. 16..
//  Copyright © 2017년 busride. All rights reserved.
//

import UIKit

class LoginSignUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(closeSelf), name: NSNotification.Name("userLogined"), object: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTouchCloseButton(_ sender: Any) {
        closeSelf()
    }

    func closeSelf() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }

}
