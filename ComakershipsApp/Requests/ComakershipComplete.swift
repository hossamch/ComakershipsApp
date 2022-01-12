//
//  ComakershipComplete.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 06/01/2022.
//

import Foundation

struct ComakershipCheckEdited: Decodable{
    let id: Int
    let name: String
    let description: String
    let credits: Bool
    let bonus: Bool
    let status: ComakershipStatus
    
    enum CodingKeys: String, CodingKey{
        case id
        case name
        case description
        case credits
        case bonus
        case status
    }
}
