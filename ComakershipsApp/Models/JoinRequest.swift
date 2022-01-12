//
//  JoinRequest.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 13/12/2020.
//

import Foundation

struct JoinRequest: Codable{
    let studentUserId: Int
    let teamId: Int
    let studentUser: StudentUser
    let team: Team
    
    enum CodingKeys: String, CodingKey{
        case studentUserId
        case teamId 
        case studentUser
        case team
    }
}
