//
//  ComakershipSearch.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 28/12/2021.
//

import Foundation

struct ComakershipSearch: Codable, Identifiable, BaseComakership{
    let id: Int
    let name: String
    let description: String
    let company: ComakershipCompany
    let status: ComakershipStatus?
    let skills: [Skill]
    let programs: [Program?]
    let credits: Bool
    let bonus: Bool
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case company
        case status
        case skills
        case programs
        case credits
        case bonus
        case createdAt
    }
    
        init(){
            id = 0
            name = ""
            description = ""
            company = ComakershipCompany()
            status = ComakershipStatus()
            skills = [Skill]()
            programs = [Program]()
            credits = true
            bonus = false
            createdAt = ""
        }
}
