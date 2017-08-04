//
//  EventViewController.swift
//  pyunrihae
//
//  Created by woowabrothers on 2017. 8. 3..
//  Copyright © 2017년 busride. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class EventViewController: UIViewController {
    
    @IBOutlet weak var eventTableView: UITableView!
    
    var ref : DatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.eventTableView.dataSource = self
        self.eventTableView.delegate = self
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
extension EventViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventListCell", for: indexPath) as! EventTableViewCell
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}
