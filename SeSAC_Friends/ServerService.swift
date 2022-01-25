//
//  ServerService.swift
//  SeSAC_Friends
//
//  Created by yeop on 2022/01/23.
//

import Foundation
import Alamofire
import SwiftyJSON

struct ServerModel{
    let url: String
    let parameters: Parameters?
    let headers: HTTPHeaders?
}

enum ServerRequest {
    case UserInfo
    case SignUp
    
    var urlRequest: ServerModel {
        let idToken = UserData.idToken
        var url: String?
        var parm: Parameters?
        var head: HTTPHeaders?
        
        switch self {
        case .UserInfo:
            url = .endPoint("/user")
            parm = nil
        case .SignUp:
            url = .endPoint("/user")
            parm = nil
        }
        
        head = ["Content-Type" : "application/x-www-form-urlencoded", "idtoken" : idToken]
        return ServerModel(url: url ?? "", parameters: parm, headers: head)
    }
}

extension String{
    static let baseURL = Bundle.main.baseURL
    static func endPoint(_ path: String) -> String {
        return baseURL + path
    }
    mutating func addToken() -> [String: String] {
        let idToken = UserData.idToken
        return ["idtoken": idToken]
    }
    mutating func addContentType() -> [String: String] {
        return ["Content-Type": "application/json"]
    }
}



class ServerService {
    static let shared = ServerService()
    typealias CompletionHandler = (Int, JSON) -> ()

    func getUserInfo(_ result: @escaping CompletionHandler){
        let server = ServerRequest.UserInfo.urlRequest
        
        AF.request(server.url,
                   method: .get,
                   headers: server.headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                let json = JSON(response)
                let statusCode = response.response?.statusCode ?? 500
                
                result(statusCode, json)
                print(statusCode,json)
            }
    }
    
    
    func postSignUp(_ result: @escaping CompletionHandler) {
        let server = ServerRequest.SignUp.urlRequest
        let parm : Parameters = ["phoneNumber": "",
                "FCMtoken": "",
                "nick": "",
                "birth": "",
                "email": "",
                "gender": 1]
        
        AF.request(server.url, method: .post, parameters: parm, headers: server.headers).validate(statusCode: 200...500).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let statusCode = response.response?.statusCode ?? 500
                
                result(statusCode, json)
                print(statusCode,json)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
}