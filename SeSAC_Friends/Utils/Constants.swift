//
//  Constants.swift
//  SeSAC_Friends
//
//  Created by yeop on 2022/01/26.
//

import Foundation

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
