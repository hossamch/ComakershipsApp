//
//  TeamInvite.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 12/12/2020.
//

import Foundation

struct TeamInvite: Codable{
    let teamId: Int
    let studentUserId: Int
    let studentUser: StudentUser?
    let team: Team?
    
    enum CodingKeys: String, CodingKey{
        case teamId
        case studentUserId
        case studentUser
        case team
    }
}
