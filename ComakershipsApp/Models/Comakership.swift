//
//  Comakership.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 11/12/2020.
//

import Foundation

struct Comakership: Codable, Identifiable{
    let id: Int
    let name: String
    let description: String
    let comakershipStatusId: Int
    let companyId: Int
    let company: ComakershipCompany
    let status: ComakershipStatus
    let skills: [Skill]
    let programs: [Program]
    let credits: Bool
    let bonus: Bool
    let createdAt: Date
    let deliverables: [Deliverable]
    let linkedSkills: [Skill]?
    let studentUsers: [StudentUser]?
    let programIds: [Int]
    let applications: [TeamComakership]?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case comakershipStatusId = "comakershipstatusid"
        case companyId = "companyid"
        case company
        case status
        case skills
        case programs
        case credits
        case bonus
        case createdAt = "createdat"
        case deliverables
        case linkedSkills = "linkedskills"
        case studentUsers = "studentusers"
        case programIds = "programids"
        case applications
    }
    
//        init(){
//            id = 0
//            name = ""
//            description = ""
//            comakershipStatusId = 0
//            companyId = 0
//            company = ComakershipCompany()
//            status = ComakershipStatus()
//            skills = Skill()
//            programs = ""
//            credits = ""
//            bonus = ""
//            createdAt = ""
//            deliverables = ""
//            linkedSkills = ""
//            studentUsers = ""
//            programIds = ""
//            applications = ""
//        }
}
