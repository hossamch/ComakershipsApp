//
//  ComakershipCreate.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 30/12/2021.
//

import Foundation

struct ComakershipCreate: Encodable{
    let name: String
    let description: String
    let credits: Bool
    let bonus: Bool
    let deliverables: [Deliverable]
    let skills: [Skill]
    let programIds: [Int]
    let purchaseKey: String

    enum CodingKeys: String, CodingKey {
        case name
        case description
        case credits
        case bonus
        case deliverables
        case skills
        case programIds
        case purchaseKey
    }
}
