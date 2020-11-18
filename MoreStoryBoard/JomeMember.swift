//
//  JomeMember.swift
//  Jome17Wave_iOS
//
//  Created by 洪展彬 on 2020/11/15.
//

import Foundation

struct JomeMember: Codable {
    let memberId: String!
    let accountStatus: Int?
    let phoneNumber: String?
    let nickname: String?
    let account: String?             //5
    let password: String?
    let gender: Int?
    let latitude: Double?
    let longitude: Double?
    let tokenId: String?            //10
    let friendCount: String?
    let scoreAverage: String?
    let beRankedCount: String?
    let groupCount: String?
    let createGroupCount: String?   //15
    let modifyDate: String?
    
    enum CodingKeys: String, CodingKey {
        case memberId
        case accountStatus
        case phoneNumber
        case nickname
        case account            //5
        case password
        case gender
        case latitude
        case longitude
        case tokenId            //10
        case friendCount
        case scoreAverage
        case beRankedCount
        case groupCount
        case createGroupCount   //15
        case modifyDate
    }
}

