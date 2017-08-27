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
        NotificationCenter.default.addObserver(self, selector: #selector(getLikeProductList), name: NSNotification.Name("likeListChanged"), object: nil)
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func onTouchCloseButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
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
            cell.moreImage.isHidden = true
            cell.productImageView.image = UIImage()
        }else{
            if likeProductList[indexPath.row].image != ""{
                cell.productImageView.af_setImage(withURL: URL(string: likeProductList[indexPath.row].image)!)
            }else{
                cell.productImageView.image = #imageLiteral(resourceName: "ic_default.png")
            }
            if likeProductList[indexPath.row].name != "" {
                cell.productNameLabel.text = likeProductList[indexPath.row].name
            }
            cell.moreImage.isHidden = false
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if likeProductList.count > 0 {
            let product = likeProductList[indexPath.row]
            NotificationCenter.default.post(name: NSNotification.Name("showProduct"), object: self, userInfo: ["product" : product])
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "mainNavigationController") as! UINavigationController
            self.present(vc, animated: true, completion: nil)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}
