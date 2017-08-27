//
//  LoginViewController.swift
//  pyunrihae
//
//  Created by woowabrothers on 2017. 8. 17..
//  Copyright © 2017년 busride. All rights reserved.
//
import UIKit
import FirebaseAuth
class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func onCancelButtonClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    @IBAction func onEditingPassword(_ sender: Any) {
        isValidSignup()
    }
    @IBAction func onEditingEmail(_ sender: Any) {
        isValidSignup()
    }
    func isValidSignup(){
        if Validator.isValidLogin(email: emailTextField.text!,password: passwordTextField.text!) {
            loginButton.isEnabled = true
        }else{
            loginButton.isEnabled = false
        }
    }
    @IBAction func onTouchLoginBtn(_ sender: Any) {
        if loginButton.isEnabled {
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                if error != nil {
                    self.alertLabel.text = "로그인에 실패했습니다."
                    self.alertLabel.alpha = 1
                    UIView.animate(withDuration: 2.0, animations: {
                        self.alertLabel.alpha = 0
                    })
                }else{
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    if Auth.auth().currentUser != nil {
                        DataManager.getUserFromUID(uid: (Auth.auth().currentUser?.uid)!, completion: { (user) in
                            appDelegate.user = user
                            self.dismiss(animated: true, completion: {
                                NotificationCenter.default.post(name: NSNotification.Name("userLogined"), object: nil)
                            })
                        })
                    } else {
                        appDelegate.user = User()
                    }
                }
            }
        }
    }
}
