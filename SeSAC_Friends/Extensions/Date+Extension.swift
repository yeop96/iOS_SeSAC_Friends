//
//  Date+Extension.swift
//  SeSAC_Friends
//
//  Created by yeop on 2022/01/26.
//

import Foundation

extension Date {
    func bitryDateString() -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        return formatter.string(from: self)
    }
    
    var toString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: Locale.preferredLanguages.first ?? "ko-KR")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        
        formatter.dateFormat = "a HH:mm"
        return formatter.string(from: self)
    }
    
}

