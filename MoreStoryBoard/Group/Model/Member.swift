//
//  Member.swift
//  Jome17Wave_iOS
//
//  Created by Karena on 2020/11/13.
//

import Foundation
struct Member: Codable {
    var memberId: String
    var accountStatus: Int
    var phoneNumber: String
    var nickname: String
    var account: String
    var password: String
    var gender: Int
    var latitude: Double?
    var longitude: Double?
    var tokenId: String?
    var friendCount: String?
    var scoreAverage: String?
    var beRankedCount: String?
    var groupCount: String?
    var createGroupCount: String?
    
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
