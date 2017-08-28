//
//  Segue.swift
//  pyunrihae
//
//  Created by woowabrothers on 2017. 8. 28..
//  Copyright © 2017년 busride. All rights reserved.
//

import Foundation
import UIKit
class Segue: UIStoryboardSegue
{
    override func perform()
    {
        let src = self.source.parent
        let dst = self.destination
        src?.view.superview?.insertSubview(dst.view, aboveSubview: (src?.view)!)
        dst.view.transform = CGAffineTransform(translationX: (src?.view.frame.size.width)!, y: 0)
        UIView.animate(withDuration: 0.25,
                                   delay: 0.0,
                                   options: UIViewAnimationOptions.curveEaseInOut,
                                   animations: {
                                    dst.view.transform = CGAffineTransform(translationX: 0, y: 0)
        },
                                   completion: { finished in
                                    src?.present(dst, animated: false, completion: nil)
        }
        )
    }
}
