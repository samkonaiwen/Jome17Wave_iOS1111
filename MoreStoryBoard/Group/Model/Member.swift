//
//  Member.swift
//  Jome17Wave_iOS
//
//  Created by Karena on 2020/11/13.
//

import Foundation
struct Member: Codable {
    let memberId: String
    let accountStatus: Int
    let phoneNumber: String
    let nickname: String
    let account: String
    let password: String
    let gender: Int
    var latitude: Double?
    var longitude: Double?
    let tokenId: String?
    let friendCount: String?
    let scoreAverage: String?
    let beRankedCount: String?
    let groupCount: String?
    let createGroupCount: String?
    
    enum CodingKeys: String, CodingKey {
        case memberId
        case accountStatus
        case phoneNumber
        case nickname
        case account
        case password
        case gender
        case latitude
        case longitude
        case tokenId
        case friendCount
        case scoreAverage
        case beRankedCount
        case groupCount
        case createGroupCount
    }
 
}
