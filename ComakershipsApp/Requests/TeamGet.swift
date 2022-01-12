//
//  TeamsGet.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 01/01/2022.
//

import Foundation

struct TeamGet: Decodable{
    let linkedTeams: [LinkedTeam]
    
    enum CodingKeys: String, CodingKey{
        case linkedTeams
    }
}
