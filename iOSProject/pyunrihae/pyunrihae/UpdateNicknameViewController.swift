//
//  UpdateNicknameViewController.swift
//  pyunrihae
//
//  Created by woowabrothers on 2017. 8. 21..
//  Copyright © 2017년 busride. All rights reserved.
//

import UIKit
import FirebaseAuth

class UpdateNicknameViewController: UIViewController {
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var completeBtn: UIButton!
    var appdelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func onTouchCloseBtn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismissKeyboard()
        dismiss(animated: true, completion: nil)
    }
    @IBAction func onNickNameTextChanged(_ sender: Any) {
        if (nickNameTextField.text?.characters.count)! > 0 &&  (nickNameTextField.text?.characters.count)! <= 10{
            completeBtn.isEnabled = true
        }else{
            completeBtn.isEnabled = false
        }
    }
    @IBAction func onTouchCompleteBtn(_ sender: Any) {
        if completeBtn.isEnabled {
            if User.sharedInstance.email != "" { // 로그인 되어있으면
                if (nickNameTextField.text?.characters.count)! > 10 {
                    let alert = UIAlertController(title: "알림", message: "닉네임을 10자 이내로 설정해주세요!", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    DataManager.updateUserNickname(user: User.sharedInstance, nickname: nickNameTextField.text!)
                    self.dismiss(animated: false, completion: nil)
                    NotificationCenter.default.post(name: NSNotification.Name("userLogined"), object: nil)
                }
            } // 비회원이면 동작 안함
        }
    }
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}
