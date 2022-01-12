//
//  LinkedTeam.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 01/01/2022.
//

import Foundation

struct LinkedTeam: Decodable, Identifiable{
    let id = UUID()
    let studentUserId: Int
    let teamId: Int
    let team: Team
    
    enum CodingKeys: String, CodingKey{
        case studentUserId
        case teamId
        case team
    }
}
