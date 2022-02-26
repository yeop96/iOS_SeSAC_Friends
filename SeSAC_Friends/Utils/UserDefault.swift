//
//  UserDefault.swift
//  SeSAC_Friends
//
//  Created by yeop on 2022/01/24.
//

import Foundation

@propertyWrapper
struct UserDefault<T> {
    private let key: String
    private let defaultValue: T

    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T {
        get {
            // Read value from UserDefaults
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            // Set value to UserDefaults
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}

struct AppFirstLaunch {
    @UserDefault(key: keyEnum.isAppFirstLaunch.rawValue, defaultValue: true)
    static var isAppFirstLaunch: Bool
}

struct UserData {
    @UserDefault(key: keyEnum.idToken.rawValue, defaultValue: "")
    static var idToken: String
    @UserDefault(key: keyEnum.phoneNumber.rawValue, defaultValue: "")
    static var phoneNumber: String
    @UserDefault(key: keyEnum.fcmToken.rawValue, defaultValue: "")
    static var fcmToken: String
    @UserDefault(key: keyEnum.nickName.rawValue, defaultValue: "")
    static var nickName: String
    @UserDefault(key: keyEnum.birth.rawValue, defaultValue: Date())
    static var birth: Date
    @UserDefault(key: keyEnum.email.rawValue, defaultValue: "")
    static var email: String
    @UserDefault(key: keyEnum.gender.rawValue, defaultValue: GenderNumber.unSelect.rawValue)
    static var gender: Int
    
    @UserDefault(key: keyEnum.background.rawValue, defaultValue: 0)
    static var background: Int
    @UserDefault(key: keyEnum.sesac.rawValue, defaultValue: 0)
    static var sesac: Int
    @UserDefault(key: keyEnum.hobby.rawValue, defaultValue: "")
    static var hobby: String
    @UserDefault(key: keyEnum.searchable.rawValue, defaultValue: 1)
    static var searchable: Int
    @UserDefault(key: keyEnum.ageMin.rawValue, defaultValue: 18)
    static var ageMin: Int
    @UserDefault(key: keyEnum.ageMax.rawValue, defaultValue: 38)
    static var ageMax: Int
    
    @UserDefault(key: keyEnum.lat.rawValue, defaultValue: 0.0)
    static var lat: Double
    @UserDefault(key: keyEnum.long.rawValue, defaultValue: 0.0)
    static var long: Double
    @UserDefault(key: keyEnum.region.rawValue, defaultValue: 0)
    static var region: Int
    
    @UserDefault(key: keyEnum.matchingStatus.rawValue, defaultValue: MatchingStatus.search.rawValue)
    static var matchingStatus: Int
    
    @UserDefault(key: keyEnum.myUID.rawValue, defaultValue: "")
    static var myUID: String
    @UserDefault(key: keyEnum.otherUID.rawValue, defaultValue: "")
    static var otherUID: String
    
}

enum keyEnum: String {
    case isAppFirstLaunch = "isAppFirstLaunch"
    case idToken = "idToken"
    case phoneNumber = "phoneNumber"
    case fcmToken = "fcmToken"
    case nickName = "nickName"
    case birth = "birth"
    case email = "email"
    case gender = "gender" // 여자: 0, 남자: 1, 미선택: -1
    case background = "background"
    case sesac = "sesac"
    case hobby = "hobby"
    case searchable = "searchable" // 거부(Switch OFF): 0 , 허용(Switch ON): 1
    case ageMin = "ageMin"
    case ageMax = "ageMax"
    case lat = "lat"
    case long = "long"
    case region = "region"
    case matchingStatus = "matchingStatus"
    case myUID = "myUID"
    case otherUID = "otherUID"
}

