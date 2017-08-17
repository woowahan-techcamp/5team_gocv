//
//  SignupViewController.swift
//  pyunrihae
//
//  Created by woowabrothers on 2017. 8. 16..
//  Copyright © 2017년 busride. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {

    @IBOutlet weak var passWordConfirmTextField: UITextField!
    @IBOutlet weak var passWordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var completeBtn: UIButton!
    
    @IBOutlet weak var emailAlertLabel: UILabel!
    @IBOutlet weak var passwordAlertLabel: UILabel!
    @IBOutlet weak var passwordConfirmAlertLabel: UILabel!

    @IBAction func onCancelBtnPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onEmailTextChanged(_ sender: Any) {
        if Validator.isValidEmail(email: emailTextField.text!) {
            emailAlertLabel.isHidden = true
        }else{
            emailAlertLabel.isHidden = false
        }
    }
    
    @IBAction func onPasswordTextChanged(_ sender: Any) {
        if Validator.isValidPassWord(password: passWordTextField.text!) {
            passwordAlertLabel.isHidden = true
        }else{
            passwordAlertLabel.isHidden = false
        }
    }
    
    @IBAction func onPasswordConfirmTextChanged(_ sender: Any) {
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
