//
//  StudentUser.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 12/12/2020.
//

import Foundation

struct StudentUser: Codable{
    let id: Int
    let name: String
    let email: String
    let nickName: String
    //let password: String
    let deleted: Bool
    let studentNumber: Int
    let about: String?
    let university: University
    let universityId: Int
    let programId: Int?
    let program: Program?
    let privateTeamId: Int
    let privateTeam: Team?
    //let favouritedComakerships: [Comakership]?
    let links: [String?]
    let linksJson: [String]?
    let skills: [String?]
    let skillsJson: [String]?
    let reviews: [Review?]
    let linkedTeams: [Team]?
    let comakerships: [Comakership]?
    let teamInvites: [TeamInvite]?
    let joinRequests: [JoinRequest]?
    
    enum CodingKeys: String, CodingKey{
        case id = "id"
        case name = "name"
        case email = "email"
        //case password
        case nickName = "nickname"
        case deleted = "deleted"
        case studentNumber
        case about = "about"
        case university = "university"
        case universityId
        case programId
        case program = "program"
        case privateTeamId
        case privateTeam
        //case favouritedComakerships
        case links
        case linksJson
        case skills
        case skillsJson
        case reviews
        case linkedTeams
        case comakerships
        case teamInvites
        case joinRequests
    }
    init(){
        self.id = 0
        self.name = ""
        self.about = ""
        self.nickName = ""
        self.comakerships = nil
        self.deleted = false
        self.email = ""
        //self.favouritedComakerships = nil
        self.joinRequests = nil
        self.linkedTeams = nil
        self.links = [String]()
        self.linksJson = nil
        self.privateTeam = nil
        self.privateTeamId = 12312
        self.program = nil
        self.programId = nil
        self.reviews = []
        self.skills = [String]()
        self.skillsJson = nil
        self.studentNumber = 0
        self.teamInvites = nil
        self.university = University()
        self.universityId = 1
    }
}
