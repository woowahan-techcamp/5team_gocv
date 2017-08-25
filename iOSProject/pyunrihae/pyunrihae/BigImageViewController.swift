//
//  BigImageViewController.swift
//  pyunrihae
//
//  Created by woowabrothers on 2017. 8. 15..
//  Copyright © 2017년 busride. All rights reserved.
//

import UIKit

class BigImageViewController: UIViewController {
    @IBOutlet weak var bigImageView = UIImageView()
    var image = UIImage()
    override func viewDidLoad() {
        super.viewDidLoad()
        bigImageView?.contentMode = .scaleAspectFit
        bigImageView?.image = image
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
