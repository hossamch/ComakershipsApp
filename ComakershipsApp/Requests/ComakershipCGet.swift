//
//  ComakershipCGet.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 31/12/2021.
//

import Foundation

struct ComakershipCGet: Decodable, Identifiable, BaseComakership{
    let id: Int
    let name: String
    let description: String
    let company: ComakershipCompany
    let status: ComakershipStatus?
    let skills: [Skill]
    let programs: [Program?]
    let deliverables: [Deliverable?]
    let students: [Student?]
    let credits: Bool
    let bonus: Bool
    let createdAt: String
    
    init(){
        id = 0
        name = ""
        description = ""
        company = ComakershipCompany()
        status = nil
        skills = [Skill]()
        programs = [Program]()
        deliverables = [Deliverable]()
        students = [Student]()
        credits = false
        bonus = false
        createdAt = ""
    }
    
    enum CodingKeys: String, CodingKey{
        case id
        case name
        case description
        case company
        case status
        case skills
        case programs
        case deliverables
        case students
        case credits
        case bonus
        case createdAt
    }
}
