//
//  EditComakership.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 01/01/2022.
//

import Foundation

struct EditComakership: Codable{
    let id: Int
    let name: String
    let description: String
    let credits: Bool
    let bonus: Bool
    let comakershipStatusId: Int
    
    enum CodingKeys: String, CodingKey{
        case id
        case name
        case description
        case credits
        case bonus
        case comakershipStatusId
    }
}
