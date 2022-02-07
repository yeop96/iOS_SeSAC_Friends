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
}

enum keyEnum: String {
    case isAppFirstLaunch = "isAppFirstLaunch"
    case idToken = "idToken"
    case phoneNumber = "phoneNumber"
    case fcmToken = "fcmToken"
    case nickName = "nickName"
    case birth = "birth"
    case email = "email"
    case gender = "gender"
}
