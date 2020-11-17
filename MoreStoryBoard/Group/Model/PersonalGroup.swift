//
//  PersonalGroup.swift
//  Jome17Wave_iOS
//
//  Created by Karena on 2020/11/11.
//

import Foundation
struct PersonalGroup: Codable{
    var groupId: String
    var groupName: String
    var assembleTime: String?
    var groupEndTime: String?
    var signUpEnd: String?
    var groupLimit: Int?
    var gender: Int?
    var notice: String?
    var memberId: String
    var nickname: String
    var memberGender: Int?
    var attenderId: Int?
    var attenderStatus: Int?
    var role: Int?
    var surfName: String?
    var surfPointId: Int?
    var joinCountNow: Int?
    var groupStatus: Int?
}
