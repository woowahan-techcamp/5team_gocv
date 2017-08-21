//
//  LikeProductViewController.swift
//  pyunrihae
//
//  Created by woowabrothers on 2017. 8. 21..
//  Copyright © 2017년 busride. All rights reserved.
//

import UIKit

class LikeProductViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    var likeProductList : [Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getLikeProductList()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    @IBAction func onTouchCloseButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismissKeyboard()
        dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func getLikeProductList(){
        
        likeProductList = []
        if (appdelegate.user?.wish_product_list)! != [] && appdelegate.user?.wish_product_list != nil{
            
            for product in appdelegate.productList {
                for id in (appdelegate.user?.wish_product_list)! {
                    if product.id == id {
                        likeProductList.append(product)
                    }
                }
            }
        }
        
        tableView.reloadData()
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


extension LikeProductViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if likeProductList.count == 0 {
            return 1
        }else{
            return likeProductList.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LikeProductTableViewCell", for: indexPath) as! LikeProductTableViewCell
        
        if likeProductList.count == 0 {
            cell.productNameLabel.text = "찜한 상품이 없습니다."
        }else{
            if likeProductList[indexPath.row].image != ""{
                cell.productImageView.af_setImage(withURL: URL(string: likeProductList[indexPath.row].image)!)
            }else{
                cell.productImageView.image = #imageLiteral(resourceName: "ic_default.png")
            }
            
            if likeProductList[indexPath.row].name != "" {
                cell.productNameLabel.text = likeProductList[indexPath.row].name
            }
        }
       
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}
