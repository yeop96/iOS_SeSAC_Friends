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
}
