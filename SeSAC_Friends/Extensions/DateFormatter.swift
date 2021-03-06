//
//  DateFormatter.swift
//  SeSAC_Friends
//
//  Created by yeop on 2022/01/24.
//

import Foundation

extension DateFormatter {
    
    func koreaDateFormatString(date : Date) -> String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier:"ko_KR")
        dateFormatter.dateFormat = "yyyy년 M월 d일"
        let str = dateFormatter.string(from: date)
        
        return str
    }
    
    func connectDateFormatString(date : Date) -> String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier:"ko_KR")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let str = dateFormatter.string(from: date)
        
        return str
    }
    
    func DateFormatInt(date : Date) -> Int{
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier:"ko_KR")
        dateFormatter.dateFormat = "yyyyMMdd"
        let str = dateFormatter.string(from: date)
        
        return Int(str)!
    }
    
    
}
