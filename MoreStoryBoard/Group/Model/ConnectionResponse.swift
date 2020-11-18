//
//  ConnectionResponse.swift
//  Jome17Wave_iOS
//
//  Created by Karena on 2020/11/12.
//

import Foundation
struct GroupGetAllResponse: Decodable {
    let resultCode: Int
    var groups: [PersonalGroup]?
    
    enum CodingKeys: String, CodingKey {
        case resultCode = "getAllResult"
        case groups = "allGroup"
    }
    
    init(from decoder: Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        resultCode = try container.decode(Int.self, forKey: .resultCode)
        let groupsString = try container.decode(String.self, forKey: .groups)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase //將底線轉換成駝峰是命名
        if let groupsData = groupsString.data(using: .utf8),
           let groups = try? decoder.decode([PersonalGroup].self, from: groupsData){
            self.groups = groups
        }
    }
}

struct changeResponse: Decodable {
    let resultCode: Int
}

//struct InsertGroupPost: Encodable {
//    let action: String
//    let insertGroup: PersonalGroup
//    enum CodingKeys: String, CodingKey {
//               case action
//               case insertGroup
//        }
//    func encode(to encoder: Encoder) throws {
//           var container = encoder.container(keyedBy: CodingKeys.self)
//           try container.encode(action, forKey: .action)
//           let encoder = JSONEncoder()
//           encoder.keyEncodingStrategy = .convertToSnakeCase
//           if let insertGroupData = try? encoder.encode(insertGroup),
//              let insertGroupString = String(data: insertGroupData, encoding: .utf8)  {
//               try container.encode(insertGroupString, forKey: .insertGroup)
//           }
//       }
//}
