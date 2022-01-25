//
//  Exception.swift
//  SeSAC_Friends
//
//  Created by yeop on 2022/01/20.
//

import Foundation

struct Exception{
    static func IsValidPhone(phone: String?) -> Bool {
        guard phone != nil else { return false }
        let phoneReg = "^01[0-1,6]-[0-9]{3,4}-[0-9]{4}$"
        let pred = NSPredicate(format:"SELF MATCHES %@", phoneReg)
        return pred.evaluate(with: phone)
    }
    
    static func IsValidNickName(nickName: String?) -> Bool{
        guard nickName != nil else { return false }
        let nickReg = "[가-힣A-Za-z0-9]{1,10}"
        let pred = NSPredicate(format:"SELF MATCHES %@", nickReg)
        return pred.evaluate(with: nickName)
    }
    
    static func IsValidEmail(email: String?) -> Bool{
        guard email != nil else { return false }
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let pred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return pred.evaluate(with: email)
    }
}

