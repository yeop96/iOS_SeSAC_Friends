//
//  Model.swift
//  SeSAC_Friends
//
//  Created by yeop on 2022/01/23.
//

import Foundation


struct PickLocation {
    let region: Int
    let lat: Double
    let long: Double
}

struct SearchedFriends: Codable {
    let fromQueueDB, fromQueueDBRequested: [FromQueueDB]
    let fromRecommend: [String]
}

struct FromQueueDB: Codable {
    let uid, nick: String
    let lat, long: Double
    let reputation: [Int]
    let hf, reviews: [String]
    let gender, type, sesac, background: Int
}

struct MyState: Codable {
    let dodged, matched, reviewed: Int
    let matchedNick, matchedUid: String
}

struct Chat: Codable {
    let id: String
    let v: Int
    let to, from, chat, createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case v = "__v"
        case to, from, chat, createdAt
    }
}

struct Chats: Codable {
    let payload: [Chat]
}
