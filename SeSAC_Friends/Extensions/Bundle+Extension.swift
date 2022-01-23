//
//  Bundle+Extension.swift
//  SeSAC_Friends
//
//  Created by yeop on 2022/01/23.
//

import Foundation

//BaseURLInfo.plist는 .gitignore한 상태
extension Bundle {
    var baseURL: String {
        guard let file = self.path(forResource: "BaseURLInfo", ofType: "plist") else { fatalError("BaseURLInfo.plist 파일이 없습니다.") }
        guard let resource = NSDictionary(contentsOfFile: file) else { fatalError("파일 형식 에러") }
        guard let key = resource["BaseURL"] as? String else { fatalError("BaseURLInfo에 BaseURL을 설정해주세요.")}
        return key
    }
}
