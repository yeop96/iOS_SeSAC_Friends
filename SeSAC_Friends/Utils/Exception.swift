//
//  Exception.swift
//  SeSAC_Friends
//
//  Created by yeop on 2022/01/20.
//

import Foundation

struct Exception{
    func IsValidPhone(phone: String?) -> Bool {
        guard phone != nil else { return false }
        let phoneRegEx = "^01[0-1,6]-[0-9]{3,4}-[0-9]{4}$"
        let pred = NSPredicate(format:"SELF MATCHES %@", phoneRegEx)
        return pred.evaluate(with: phone)
    }
}

