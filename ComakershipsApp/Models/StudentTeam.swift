//
//  StudentTeam.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 12/12/2020.
//

import Foundation

struct StudentTeam: Codable{
    let studentUserId: Int
    let teamId: Int
    //let studentUser: [StudentUser]?
    let team: [Team]?
    
    enum CodingKeys: String, CodingKey{
        case studentUserId
        case teamId
        //case studentUser
        case team
    }
}
