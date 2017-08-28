//
//  LoginSignUpViewController.swift
//  pyunrihae
//
//  Created by woowabrothers on 2017. 8. 16..
//  Copyright © 2017년 busride. All rights reserved.
//
import UIKit
import GoogleSignIn
import Firebase

class LoginSignUpViewController: UIViewController,GIDSignInUIDelegate{


    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self

        NotificationCenter.default.addObserver(self, selector: #selector(closeSelf), name: NSNotification.Name("userLogined"), object: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func onTouchCloseButton(_ sender: Any) {
        closeSelf()
    }
    func closeSelf() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }


    @IBAction func onTouchGoogleSignInBtn(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }


}
