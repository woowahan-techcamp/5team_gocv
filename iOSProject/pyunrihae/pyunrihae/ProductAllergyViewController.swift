//
//  ProductAllergyViewController.swift
//  pyunrihae
//
//  Created by woowabrothers on 2017. 8. 23..
//  Copyright © 2017년 busride. All rights reserved.
//

import UIKit

class ProductAllergyViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var allergyList : [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTouchCloseBtn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
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

extension ProductAllergyViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if allergyList.count == 0 {
            return 1
        }else{
            return allergyList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "allergyCell", for: indexPath)
        
        if allergyList.count == 0 {
            cell.textLabel?.text = "알레르기 정보가 없습니다."
        }else{
            cell.textLabel?.text = allergyList[indexPath.row]
        }
        
        return cell
    }
    
}
