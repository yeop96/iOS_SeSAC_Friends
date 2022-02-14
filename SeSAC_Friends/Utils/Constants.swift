//
//  Constants.swift
//  SeSAC_Friends
//
//  Created by yeop on 2022/01/26.
//

import Foundation
import UIKit

enum GenderNumber : Int {
    case unSelect = -1
    case female = 0
    case male = 1
}

enum ServerStatusCode: Int {
    case OK = 200
    case FIREBASE_TOKEN_ERROR = 401
    case UNREGISTERED_ERROR = 406
    case SERVER_ERROR = 500
    case CLIENT_ERROR = 501
}

enum SesacImage : Int {
    //Int여서 자동으로 rawValue 0부터 값을 가짐
    case sesac0
    case sesac1
    case sesac2
    case sesac3
    case sesac4
    
    func sesacUIImage() -> UIImage{
        return UIImage(named: "sesac_face_\(self.rawValue + 1)")!
    }
    
}

enum SesacBackgroundImage : Int {
    case background0
    case background1
    case background2
    case background3
    case background4
    
    func sesacBackgroundUIImage() -> UIImage{
        return UIImage(named: "sesac_background_\(self.rawValue + 1)")!
    }
    
}
