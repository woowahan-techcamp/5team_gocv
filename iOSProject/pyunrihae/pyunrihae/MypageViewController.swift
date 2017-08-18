//
//  MypageViewController.swift
//  pyunrihae
//
//  Created by woowabrothers on 2017. 8. 7..
//  Copyright © 2017년 busride. All rights reserved.
//

import UIKit
import FirebaseAuth
class MypageViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var nickNameLabel: UILabel!
    
    var labelList = ["닉네임 수정","내가 찜한 상품","편리해 정보","회원가입 / 로그인"]
    var currentUser = User()
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(checkUserLogin), name: NSNotification.Name("userLogined"), object: nil)
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        checkUserLogin()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkUserLogin(){
        if Auth.auth().currentUser != nil {
            DataManager.getUserFromUID(uid: (Auth.auth().currentUser?.uid)!, completion: { (user) in
                self.currentUser = user
                
                if user.email != "" {
                    DispatchQueue.main.async{
                        self.nickNameLabel.text = self.currentUser.nickname
                        self.emailLabel.text = self.currentUser.email
                        self.labelList[3] = "로그아웃"
                        self.tableView.reloadData()
                    }
                }else{
                    DispatchQueue.main.async{
                        self.nickNameLabel.text = "로그인을 해주세요."
                        self.emailLabel.text = "로그인을 해주세요."
                        self.labelList[3] = "회원가입 / 로그인"
                        self.tableView.reloadData()
                    }
                }
            })
        }
    }
    
    func setLogined(){
        if currentUser.email != "" {
            DispatchQueue.main.async{
                self.nickNameLabel.text = self.currentUser.nickname
                self.emailLabel.text = self.currentUser.email
                self.labelList[3] = "로그아웃"
                self.tableView.reloadData()
            }
        }else{
            DispatchQueue.main.async{
                self.nickNameLabel.text = "로그인을 해주세요."
                self.emailLabel.text = "로그인을 해주세요."
                self.labelList[3] = "회원가입 / 로그인"
                self.tableView.reloadData()
            }
        }
    }
    
    func showAlertIfLogined(bool : Bool){
        
        // TODO 회원가입이나 로그인 시 로그인 되었습니다 뜨도록 하기. 그때는 제대로 안뜸.
        alertLabel.alpha = 1.0
        if bool {
            alertLabel.text = "로그인 되었습니다."
            UIView.animate(withDuration: 3) {
                self.alertLabel.alpha = 0
            }
        }else{
            alertLabel.text = "로그아웃 되었습니다."
            UIView.animate(withDuration: 2) {
                self.alertLabel.alpha = 0
            }
        }
        
       
    }
}

extension MypageViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return labelList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MypageTableViewCell
        cell.mypageListLabel.text = labelList[indexPath.row]
        let image = cell.rightImage.image
        let tintedImage = image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        cell.rightImage.image = tintedImage
        cell.rightImage.tintColor = UIColor.lightGray
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 3 {
            if labelList[3] == "회원가입 / 로그인" {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "LoginSignUpViewController") as! LoginSignUpViewController
                self.present(vc, animated: true, completion: nil)
            } else{ // 로그아웃 시키기
                
                let alertController = UIAlertController(title: "알림", message: "정말 로그아웃 하시겠어요?", preferredStyle: UIAlertControllerStyle.alert)
                
                let DestructiveAction = UIAlertAction(title: "취소", style: UIAlertActionStyle.destructive) { (result : UIAlertAction) -> Void in
                    alertController.dismiss(animated: false, completion: nil)
                }
                
                let okAction = UIAlertAction(title: "로그아웃", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                    let firebaseAuth = Auth.auth()
                    do {
                        try firebaseAuth.signOut()
                        self.currentUser = User()
                        self.setLogined()
                        self.showAlertIfLogined(bool: false)
                    } catch let signOutError as NSError {
                        print ("Error signing out: %@", signOutError)
                    }
                }
                
                alertController.addAction(DestructiveAction)
                
                alertController.addAction(okAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}
