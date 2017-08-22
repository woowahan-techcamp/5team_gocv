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
    
    var appdelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var completeBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTouchCloseBtn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismissKeyboard()
        dismiss(animated: true, completion: nil)
    }
    
   
    @IBAction func onNickNameTextChanged(_ sender: Any) {
        if (nickNameTextField.text?.characters.count)! > 0 {
            completeBtn.isEnabled = true
        }else{
            completeBtn.isEnabled = false
        }
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    @IBAction func onTouchCompleteBtn(_ sender: Any) {
        
        if completeBtn.isEnabled {
            if appdelegate.user != nil {
                if (nickNameTextField.text?.characters.count)! > 10 {
                    let alert = UIAlertController(title: "알림", message: "10자 이내로 닉네임을 설정해주세요!", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    DataManager.updateUserNickname(user: appdelegate.user!, nickname: nickNameTextField.text!)
                    self.dismiss(animated: false, completion: nil)
                    NotificationCenter.default.post(name: NSNotification.Name("userLogined"), object: nil)
                }
            }
        }
        
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
