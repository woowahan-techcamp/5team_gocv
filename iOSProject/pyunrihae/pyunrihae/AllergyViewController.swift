//
//  AllergyViewController.swift
//  pyunrihae
//
//  Created by woowabrothers on 2017. 8. 10..
//  Copyright © 2017년 busride. All rights reserved.
//

import UIKit

class AllergyViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBAction func tabBackBtn(_ sender: UIButton) {
        let writingReviewViewController = self.navigationController?.viewControllers[1] as! WritingReviewViewController
        self.navigationController?.popToViewController(writingReviewViewController, animated: true)
    }
    @IBAction func tabCompleteBtn(_ sender: UIButton) {
    }
    let allergyList = ["메밀","달걀","우유","콩","밀","게","새우","고등어","돼지고기","소고기","닭고기","복숭아","땅콩","토마토","오징어","호두","조개"] // 임의로 알레르기 리스트를 넣었음

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsMultipleSelection = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
extension AllergyViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allergyList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! AllergyTableViewCell
        cell.checkImage.isHidden = true
        cell.allergyListLabel.text = allergyList[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! AllergyTableViewCell
        cell.checkImage.isHidden = false
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! AllergyTableViewCell
        cell.checkImage.isHidden = true
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}
