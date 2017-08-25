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
        navigationController?.popViewController(animated: true)
        dismissKeyboard()
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
