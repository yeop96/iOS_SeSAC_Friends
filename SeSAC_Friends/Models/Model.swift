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
