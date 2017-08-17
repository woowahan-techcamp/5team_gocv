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
}
