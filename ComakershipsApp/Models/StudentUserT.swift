//
//  StudentUserT.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 01/01/2022.
//

import Foundation

struct StudentUserT: Codable{
    let studentNumber: Int?
    let about: String?
    let nickName: String
    let university: University
    let universityId: Int
    let programId: Int
    let program: Program
    let privateTeamId: Int?
    //let privateTeam: Team?
    let links: [String]?
    let linksJson: String
    let skills: [String]?
    let skillJson: String
    let reviews: [Review]?
    let linkedTeams: [StudentTeam]?
    let comakerships: [UserComakership]
    let teamInvites: [TeamInvite]
    let joinRequests: [JoinRequest]
}
