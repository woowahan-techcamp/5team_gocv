//
//  WaitingViewController.swift
//  pyunrihae
//
//  Created by woowabrothers on 2017. 8. 16..
//  Copyright © 2017년 busride. All rights reserved.
//

import UIKit

class WaitingViewController: UIViewController {

    @IBOutlet weak var pyunrihaeImage: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animateView()
        
        DataManager.getTop3Product() { (products) in
            DispatchQueue.main.async {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let tabBar = storyboard.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
                let transition: CATransition = CATransition()
                transition.duration = 1.5
                transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                transition.type = kCATransitionReveal
                transition.subtype = kCATransitionFade
                self.view.window!.layer.add(transition, forKey: nil)
                self.dismiss(animated: false, completion: nil)
                self.present(tabBar, animated: false, completion: nil)
            }
        }
        // Do any additional setup after loading the view.
    }
    
    func animateView(){
        UIView.animate(withDuration: 1,delay: 0.5, animations: {
            self.pyunrihaeImage.alpha -= 1
        }, completion: { (complete:Bool) in
             if complete == true{
                UIView.animate(withDuration: 1,delay: 0.5, animations: {
                    self.pyunrihaeImage.alpha += 1
                }
            )}
        })
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
