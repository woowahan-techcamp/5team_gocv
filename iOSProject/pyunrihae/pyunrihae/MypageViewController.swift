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

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var moreImg: UIImageView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var labelList = ["내가 찜한 상품","편리해 정보","회원가입 / 로그인"]
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(checkUserLogin), name: NSNotification.Name("userLogined"), object: nil)
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        checkUserLogin()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(nicknameTapped))
        
        // add it to the image view;
        nickNameLabel.addGestureRecognizer(tapGesture)
        // make sure imageView can be interacted with by user
        nickNameLabel.isUserInteractionEnabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func nicknameTapped(){
        if nickNameLabel.text != "로그인을 해주세요." {
            // 닉네임 수정
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "UpdateNicknameViewController") as! UpdateNicknameViewController
            self.present(vc, animated: true, completion: nil)
        }
    }
    func checkUserLogin(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let user = appDelegate.user
        if user?.email != "" {
            userImage.image = UIImage(named: "user_default.png")
            nickNameLabel.text = user?.nickname
            emailLabel.text = user?.email
            labelList[2] = "로그아웃"
            DispatchQueue.main.async {
                self.moreImg.isHidden = false
            }
            tableView.reloadData()
        } else {
            nickNameLabel.text = "로그인을 해주세요."
            emailLabel.text = "로그인을 해주세요."
            labelList[2] = "회원가입 / 로그인"
            DispatchQueue.main.async {
                self.moreImg.isHidden = true
            }
            tableView.reloadData()
        }
    }

    
    func setLogined(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let currentUser = appDelegate.user
        if currentUser?.email != "" {
            DispatchQueue.main.async{
                self.nickNameLabel.text = currentUser?.nickname
                self.emailLabel.text = currentUser?.email
                self.labelList[2] = "로그아웃"
                self.tableView.reloadData()
            }
        }else{
            DispatchQueue.main.async{
                self.userImage.image = UIImage(named: "ic_user.png")
                self.nickNameLabel.text = "로그인을 해주세요."
                self.emailLabel.text = "로그인을 해주세요."
                self.labelList[2] = "회원가입 / 로그인"
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 { // 내가 찜한 상품을 눌렀을 때
            
            if appDelegate.user?.email == "" { // 로그인 된 상태가 아니면
                let alertController = UIAlertController(title: "알림", message: "내가 찜한 상품은 로그인 뒤 이용가능합니다.", preferredStyle: UIAlertControllerStyle.alert)
                
                let DestructiveAction = UIAlertAction(title: "취소", style: UIAlertActionStyle.destructive) { (result : UIAlertAction) -> Void in
                    alertController.dismiss(animated: false, completion: nil)
                }
                
                let okAction = UIAlertAction(title: "로그인", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "LoginSignUpViewController") as! LoginSignUpViewController
                    self.present(vc, animated: true, completion: nil)
                }
                
                alertController.addAction(DestructiveAction)
                
                alertController.addAction(okAction)
                
                self.present(alertController, animated: true, completion: nil)
            }else{
                // 내가 찜한 상품 뷰
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "LikeProductViewController") as! LikeProductViewController
                self.present(vc, animated: true, completion: nil)
            }
        }
        if indexPath.row == 2 {
            if labelList[2] == "회원가입 / 로그인" {
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
                        self.appDelegate.user = User()
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
