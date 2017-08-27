//
//  GoogleSignInViewController.swift
//  pyunrihae
//
//  Created by KimJuneYoung on 2017. 8. 27..
//  Copyright © 2017년 busride. All rights reserved.
//

import UIKit
import GoogleSignIn
import Firebase

class GoogleSignInViewController: UIViewController,GIDSignInUIDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
