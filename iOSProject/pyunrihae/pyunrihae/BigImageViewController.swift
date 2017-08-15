//
//  BigImageViewController.swift
//  pyunrihae
//
//  Created by woowabrothers on 2017. 8. 15..
//  Copyright © 2017년 busride. All rights reserved.
//

import UIKit

class BigImageViewController: UIViewController {

    @IBOutlet weak var bigImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        DataManager.getProductById(id: SelectedProduct.foodId) { (product) in
            self.bigImageView.af_setImage(withURL: URL(string: product.image)!, placeholderImage: UIImage(), imageTransition: .crossDissolve(0.2), completion:{ image in
            })
            
        }
        bigImageView.contentMode = .scaleAspectFit
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
