//
//  TeamComakership.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 12/12/2020.
//

import Foundation

struct TeamComakership: Codable{
    let teamId: Int
    let comakershipId: Int
    let team: Team
    let comakership: [Comakership]
    
    enum CodingKeys: String, CodingKey{
        case teamId
        case comakershipId
        case team
        case comakership
    }
}
