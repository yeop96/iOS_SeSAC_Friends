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
    case sesac0 = 0
    case sesac1 = 1
    case sesac2 = 2
    case sesac3 = 3
    case sesac4 = 4
    
    func sesacUIImage() -> UIImage{
        switch self {
        case .sesac0:
            return UIImage(named: "sesac_face_1")!
        case .sesac1:
            return UIImage(named: "sesac_face_2")!
        case .sesac2:
            return UIImage(named: "sesac_face_3")!
        case .sesac3:
            return UIImage(named: "sesac_face_4")!
        case .sesac4:
            return UIImage(named: "sesac_face_5")!
        }
    }
    
}

enum SesacBackgroundImage : Int {
    case background0 = 0
    case background1 = 1
    case background2 = 2
    case background3 = 3
    case background4 = 4
    
    func sesacBackgroundUIImage() -> UIImage{
        switch self {
        case .background0:
            return UIImage(named: "sesac_background_1")!
        case .background1:
            return UIImage(named: "sesac_background_2")!
        case .background2:
            return UIImage(named: "sesac_background_3")!
        case .background3:
            return UIImage(named: "sesac_background_4")!
        case .background4:
            return UIImage(named: "sesac_background_5")!
        }
    }
    
}
