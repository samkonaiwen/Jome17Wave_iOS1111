//
//  PersonalGroup.swift
//  Jome17Wave_iOS
//
//  Created by Karena on 2020/11/11.
//

import Foundation
struct PersonalGroup: Codable{
    let groupId: String
    let groupName: String
    let assembleTime: String?
    let groupEndTime: String?
    let signUpEnd: String?
    let groupLimit: Int?
    let gender: Int?
    let notice: String?
    let memberId: String
    let nickname: String
    let memberGender: Int?
    let attenderId: Int?
    let attenderStatus: Int?
    let role: Int?
    let surfName: String?
    let surfPointId: Int?
    let joinCountNow: Int?
    let groupStatus: Int?
}
