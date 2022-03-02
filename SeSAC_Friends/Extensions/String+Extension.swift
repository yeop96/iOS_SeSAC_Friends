//
//  String+Extension.swift
//  SeSAC_Friends
//
//  Created by yeop on 2022/03/02.
//

import Foundation

extension String {
    var toDate: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: Locale.preferredLanguages.first ?? "ko-KR")
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let date = formatter.date(from: self) ?? Date()
        return date.toString
    }
}
