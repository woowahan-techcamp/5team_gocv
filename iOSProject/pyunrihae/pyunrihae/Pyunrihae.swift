//
//  Pyunrihae.swift
//  pyunrihae
//
//  Created by woowabrothers on 2017. 8. 29..
//  Copyright © 2017년 busride. All rights reserved.
//

/*
 *  편리해 앱에서
 *  반복적으로 사용되는 함수들을 모아놓은 model입니다.
 */

import Foundation


class Pyunrihae {
    
    
    /*
     *  비회원일 때 로그인 필요 기능에 팝업 띄우기
     */
    static func showLoginOptionPopup(_ controller : UIViewController){
        let alertController = UIAlertController(title: "알림", message: "로그인 뒤 이용가능합니다.", preferredStyle: UIAlertControllerStyle.alert)
        let DestructiveAction = UIAlertAction(title: "취소", style: UIAlertActionStyle.destructive) { (result : UIAlertAction) -> Void in
            alertController.dismiss(animated: false, completion: nil)
        }
        let okAction = UIAlertAction(title: "로그인", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "LoginSignUpViewController") as! LoginSignUpViewController
            controller.present(vc, animated: true, completion: nil)
        }
        alertController.addAction(DestructiveAction)
        alertController.addAction(okAction)
        controller.present(alertController, animated: true, completion: nil)
    }
}
