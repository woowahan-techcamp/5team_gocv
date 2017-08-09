//
//  MypageViewController.swift
//  pyunrihae
//
//  Created by woowabrothers on 2017. 8. 7..
//  Copyright © 2017년 busride. All rights reserved.
//

import UIKit

class MypageViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let labelList = ["닉네임 수정","내가 찜한 상품","편리해 정보"]
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
}

extension MypageViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}
