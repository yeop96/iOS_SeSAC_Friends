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

enum MatchingStatus: Int {
    case search
    case matching
    case matched
}

enum ServerStatusCode: Int {
    case OK = 200
    case FIREBASE_TOKEN_ERROR = 401
    case UNREGISTERED_ERROR = 406
    case SERVER_ERROR = 500
    case CLIENT_ERROR = 501
}

// 회원가입
enum SignupStatusCode: Int {
    case ALREADY_SIGNIN = 201
    case CANT_USE_NICKNAME = 202
}

// 취미 함께할 친구 찾기 요청 (post queue)
enum QueueStatusCode: Int {
    case ALREADY_THREE_REPORT = 201
    case FIRST_PENALTY = 203
    case SECOND_PENALTY = 204
    case THIRD_PENALTY = 205
    case GENDER_NOT_SET = 206
}

// 친구 찾기 중단 (delete queue)
enum DeleteQueueStatusCode: Int {
    case ALREADY_MATCHING = 201
}

// 취미 함께하기 요청 (post hobbyrequest)
enum HobbyRequestStatusCode: Int {
    case USER_ALREADY_REQUEST = 201
    case USER_STOP_MATCHING = 202
}

// 취미 함께하기 수락 (post hobbyaccept)
enum HobbyAcceptStatusCode: Int {
    case ALREADY_MATCHING_OTHERS = 201
    case USER_STOP_MATCHING = 202
    case ALREADY_MATCHING_ME = 203
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
    case background5
    case background6
    case background7
    
    func sesacBackgroundUIImage() -> UIImage{
        return UIImage(named: "sesac_background_\(self.rawValue + 1)")!
    }
    
}
