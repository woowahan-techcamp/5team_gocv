//
//  Validator.swift
//  pyunrihae
//
//  Created by woowabrothers on 2017. 8. 17..
//  Copyright © 2017년 busride. All rights reserved.
//

import Foundation


class Validator {
    
    static func isValidEmail(email : String ) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    static func isValidPassWord(password : String) -> Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[A-Za-z])(?=.*[0-9])[A-Za-z\\d+]{6,}")
        return passwordTest.evaluate(with: password)
    }
    
    static func isSamePassWord(password: String, confirmPassword : String) -> Bool {
        if password == confirmPassword {
            return true
        }else{
            return false
        }
    }
    
    static func isValidSign(email : String, password: String, confirmPassword : String) -> Bool {
        if isValidEmail(email:email) && isValidPassWord(password: password) && isSamePassWord(password: password, confirmPassword: confirmPassword){
            return true
        }else{
            return false
        }
    }
    
    //TODO 현재 user모델에 있는 이메일인지도 확인해야함.
}
