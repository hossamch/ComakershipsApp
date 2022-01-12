//
//  Team.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 12/12/2020.
//

import Foundation

struct Team: Codable{
    let id: Int
    let name: String
    let description: String
    let linkedStudents: [LinkedStudent?]
    let appliedComakerships: [TeamComakership?]
    let joinRequests: [JoinRequest]?
    let teamInvites: [TeamInvite]?
    
    enum CodingKeys: String, CodingKey{
        case id
        case name
        case description
        case linkedStudents
        case appliedComakerships
        case joinRequests
        case teamInvites
    }
}
