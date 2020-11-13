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
