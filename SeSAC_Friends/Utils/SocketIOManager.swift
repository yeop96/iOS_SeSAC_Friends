//
//  SocketIOManager.swift
//  SeSAC_Friends
//
//  Created by yeop on 2022/02/25.
//

import Foundation
import SocketIO

class SocketIOManager: NSObject {
    static let shared = SocketIOManager()
    
    //서버와 메시지를 주고받기 위한 클래스
    var manager: SocketManager!
    //클라이언트 소켓
    var socket: SocketIOClient!
    
    let url = URL(string: Bundle.main.baseURL)!
    
    override init() {
        super.init()
        
        manager = SocketManager(socketURL: url , config: [
            .log(true),
            .compress,
            .forceWebsockets(true)
        ])
        
        socket = manager.defaultSocket
        //소켓 연결
        socket.on(clientEvent: .connect) { data, ack in
            print("Socket is connected", data, ack)
            self.socket.emit("changesocketid", UserData.myUID)
        }
        //소켓 해제
        socket.on(clientEvent: .disconnect) { data, ack in
            print("socket is disconnected", data, ack)
        }
        //소켓 채팅 듣는 메소드
        // 데이터 수신 -> 디코딩 -> 모델에 추가 -> 갱신
        socket.on("chat") { dataArray, ack in
            print("응답 ", dataArray, ack)
            
            let data = dataArray[0] as! NSDictionary
            let id = data["_id"] as! String
            let v = data["__v"] as! Int
            let to = data["to"] as! String
            let from = data["from"] as! String
            let chat = data["chat"] as! String
            let createdAt = data["createdAt"] as! String
            
            NotificationCenter.default.post(name: NSNotification.Name("getMessage"), object: self, userInfo: [
                "_id" : id,
                "__v" : v,
                "to" : to,
                "from" : from,
                "chat" : chat,
                "createdAt" : createdAt
            ])
        }
        
    }
    
    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
    
}
