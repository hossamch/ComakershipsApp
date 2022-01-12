//
//  JoinQuery.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 01/01/2022.
//

import Foundation

struct JoinQuery: Decodable, Identifiable{
    let id = UUID()
    let studentUserId: Int
    let teamId: Int
    let studentUser: StudentUserBasic
    let team: TeamBasic
    
    enum CodingKeys: String, CodingKey{
        case studentUserId
        case teamId
        case studentUser
        case team
    }
}
