//
//  ServerService.swift
//  SeSAC_Friends
//
//  Created by yeop on 2022/01/23.
//

import Foundation
import Alamofire
import SwiftyJSON
import Firebase
import FirebaseAuth

struct ServerModel{
    let url: String
    let parameters: Parameters?
    let headers: HTTPHeaders?
}

enum ServerRequest {
    case UserInfo
    case SignUp
    case Withdraw
    case UpdateMyPage
    case RequestFrineds
    case StopRequestFrineds
    case SearchFriends
    case HobbyRequest
    case HobbyAccept
    case MyState
    case Dodge
    case SendChatting
    case GetChatting
    
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
        case .Withdraw:
            url = .endPoint("/user/withdraw")
            parm = nil
        case .UpdateMyPage:
            url = .endPoint("/user/update/mypage")
            parm = nil
        case .RequestFrineds:
            url = .endPoint("/queue")
            parm = nil
        case .StopRequestFrineds:
            url = .endPoint("/queue")
            parm = nil
        case .SearchFriends:
            url = .endPoint("/queue/onqueue")
            parm = nil
        case .HobbyRequest:
            url = .endPoint("/queue/hobbyrequest")
            parm = nil
        case .HobbyAccept:
            url = .endPoint("/queue/hobbyaccept")
            parm = nil
        case .MyState:
            url = .endPoint("/queue/myQueueState")
            parm = nil
        case .Dodge:
            url = .endPoint("/queue/dodge")
            parm = nil
        case .SendChatting:
            url = .endPoint("/queue/chat")
            parm = nil
        case .GetChatting:
            url = .endPoint("/queue/chat")
            parm = nil
        }
        
        head = ["Content-Type" : "application/x-www-form-urlencoded",
                "idtoken" : idToken] as HTTPHeaders
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
        return ["Content-Type": "application/x-www-form-urlencoded"]
    }
    
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        return request
    }
    
}



class ServerService {
    static let shared = ServerService()
    typealias CompletionHandler = (Int, JSON) -> ()
    typealias NetworkResult = (Int) -> ()
    typealias DataCompletionHandler = (Int, Data?) -> ()
    
    //싱글톤 사용시 private으로 인스턴스 생성 안되게 하기
    private init(){
        
    }
    
    func getUserInfo(_ result: @escaping CompletionHandler){
        let server = ServerRequest.UserInfo.urlRequest
        AF.request(server.url, method: .get, headers: server.headers)
            .validate()
            .responseJSON { response in
                let json = JSON(response.data as Any)
                let statusCode = response.response?.statusCode ?? 500
                result(statusCode, json)
            }
    }
    
    
    func postSignUp(_ result: @escaping CompletionHandler) {
        let server = ServerRequest.SignUp.urlRequest
        let parm : Parameters = ["phoneNumber": UserData.phoneNumber,
                                 "FCMtoken": UserData.fcmToken,
                                 "nick": UserData.nickName,
                                 "birth": UserData.birth.bitryDateString(),
                                 "email": UserData.email,
                                 "gender": UserData.gender]
        
        AF.request(server.url, method: .post, parameters: parm, headers: server.headers).validate().responseString { response in
            let json = JSON(response.data as Any)
            let statusCode = response.response?.statusCode ?? 500
            
            result(statusCode, json)
            print(statusCode,json)
            
        }
    }
    
    func postWithdraw(_ result: @escaping CompletionHandler){
        let server = ServerRequest.Withdraw.urlRequest
        AF.request(server.url, method: .post, headers: server.headers)
            .validate()
            .responseJSON { response in
                let json = JSON(response.data as Any)
                let statusCode = response.response?.statusCode ?? 500
                result(statusCode, json)
                print(statusCode,json)
            }
    }
    
    func postMyPage(_ result: @escaping CompletionHandler) {
        let server = ServerRequest.UpdateMyPage.urlRequest
        let parm : Parameters = ["searchable": UserData.searchable,
                                 "ageMin": UserData.ageMin,
                                 "ageMax": UserData.ageMax,
                                 "gender": UserData.gender,
                                 "hobby": UserData.hobby]
        
        AF.request(server.url, method: .post, parameters: parm, headers: server.headers).validate().responseString { response in
            let statusCode = response.response?.statusCode ?? 500
            
            switch response.result {
            case .success:
                switch statusCode {
                case 200..<300:
                    let json = JSON(response.data as Any)
                    result(statusCode, json)
                case ServerStatusCode.FIREBASE_TOKEN_ERROR.rawValue:
                    let json = JSON(response.data as Any)
                    result(statusCode, json)
                case ServerStatusCode.SERVER_ERROR.rawValue:
                    print("서버 에러")
                case ServerStatusCode.CLIENT_ERROR.rawValue:
                    print("클라이언트 에러")
                default:
                    print("default")
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func postRequestFrineds(region: Int, lat: Double, long: Double, hobby: [String], _ result: @escaping CompletionHandler){
        let server = ServerRequest.RequestFrineds.urlRequest
        let parm : Parameters = ["type": 2,
                                 "region": region,
                                 "lat": lat,
                                 "long": long,
                                 "hf": hobby]
        AF.request(server.url, method: .post, parameters: parm, encoding: URLEncoding(arrayEncoding: .noBrackets), headers: server.headers)
            .validate()
            .responseString { response in
                let json = JSON(response.data as Any)
                let statusCode = response.response?.statusCode ?? 500
                result(statusCode, json)
            }
    }
    
    func deleteRequestFrineds(_ result: @escaping CompletionHandler){
        let server = ServerRequest.StopRequestFrineds.urlRequest
        AF.request(server.url, method: .delete, headers: server.headers)
            .validate()
            .responseString { response in
                let json = JSON(response.data as Any)
                let statusCode = response.response?.statusCode ?? 500
                result(statusCode, json)
            }
    }
    
    func postSearchFriedns(region: Int, lat: Double, long: Double,_ result: @escaping DataCompletionHandler) {
        let server = ServerRequest.SearchFriends.urlRequest
        let parm : Parameters = ["region": region,
                                 "lat": lat,
                                 "long": long]
        AF.request(server.url, method: .post, parameters: parm, headers: server.headers).validate().responseJSON { response in
            let data = response.data
            let statusCode = response.response?.statusCode ?? 500
            
            result(statusCode, data)
            
        }
    }
    
    func postHobbyrequest(uid: String, _ result: @escaping CompletionHandler){
        let server = ServerRequest.HobbyRequest.urlRequest
        let parm : Parameters = ["otheruid": uid]
        AF.request(server.url, method: .post, parameters: parm, headers: server.headers)
            .validate()
            .responseString { response in
                let json = JSON(response.data as Any)
                let statusCode = response.response?.statusCode ?? 500
                result(statusCode, json)
            }
    }
    func postHobbyaccept(uid: String, _ result: @escaping CompletionHandler){
        let server = ServerRequest.HobbyAccept.urlRequest
        let parm : Parameters = ["otheruid": uid]
        AF.request(server.url, method: .post, parameters: parm, headers: server.headers)
            .validate()
            .responseString { response in
                let json = JSON(response.data as Any)
                let statusCode = response.response?.statusCode ?? 500
                result(statusCode, json)
            }
    }
    func getMyState( _ result: @escaping DataCompletionHandler){
        let server = ServerRequest.MyState.urlRequest
        AF.request(server.url, method: .get, headers: server.headers)
            .validate()
            .responseJSON { response in
                let data = response.data
                let statusCode = response.response?.statusCode ?? 500
                
                result(statusCode, data)
            }
    }
    
    func postDodge(uid: String, _ result: @escaping CompletionHandler){
        let server = ServerRequest.Dodge.urlRequest
        let parm : Parameters = ["otheruid": uid]
        AF.request(server.url, method: .post, parameters: parm, headers: server.headers)
            .validate()
            .responseString { response in
                let json = JSON(response.data as Any)
                let statusCode = response.response?.statusCode ?? 500
                result(statusCode, json)
            }
    }
    
    func postSendingChatting(chat: String, _ result: @escaping DataCompletionHandler){
        let server = ServerRequest.SendChatting.urlRequest
        let parm : Parameters = ["chat": chat]
        AF.request(server.url + "/\(UserData.matchedUID)", method: .post, parameters: parm, headers: server.headers).validate().responseJSON { response in
            let data = response.data
            let statusCode = response.response?.statusCode ?? 500
            
            result(statusCode, data)
            
        }
    }
    func getChatting(chat: String, _ result: @escaping DataCompletionHandler){
        let server = ServerRequest.GetChatting.urlRequest
        AF.request(server.url + "/\(UserData.matchedUID)?lastchatDate=2000-01-01T00:00:00.000Z", method: .get, headers: server.headers).validate().responseJSON { response in
            let data = response.data
            let statusCode = response.response?.statusCode ?? 500
            
            result(statusCode, data)
            
        }
    }
    
    static func updateIdToken(completion: @escaping (Result<String, Error>) -> Void) {
        Auth.auth().currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let idToken = idToken {
                UserData.idToken = idToken
                print("아이디 토큰 업데이투",idToken)
                completion(.success(idToken))
            }
        }
    }
}
