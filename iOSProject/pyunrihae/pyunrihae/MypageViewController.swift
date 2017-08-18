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
    
    var labelList = ["닉네임 수정","내가 찜한 상품","편리해 정보","회원가입 / 로그인"]
    var currentUser = User()
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(setLogined), name: NSNotification.Name("userLogined"), object: nil)
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        setLogined()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkUserLogin(){
        if Auth.auth().currentUser != nil {
            currentUser = User.init(id: (Auth.auth().currentUser?.uid)! , email: (Auth.auth().currentUser?.email)!)
        }
    }
    
    func setLogined(){
        checkUserLogin()
        if currentUser.email != "" {
            DispatchQueue.main.async{
                self.emailLabel.text = self.currentUser.email
                self.labelList[3] = "로그아웃"
                self.tableView.reloadData()
            }
            
        }else{
            DispatchQueue.main.async{
                self.emailLabel.text = "로그인을 해주세요."
                self.labelList[3] = "회원가입 / 로그인"
                self.tableView.reloadData()
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
        if labelList[3] == "회원가입 / 로그인" {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "LoginSignUpViewController") as! LoginSignUpViewController
            self.present(vc, animated: true, completion: nil)
        } else{
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                self.currentUser = User()
                self.setLogined()
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}
