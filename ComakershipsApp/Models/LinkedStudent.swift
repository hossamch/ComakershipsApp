//
//  LinkedStudent.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 04/01/2021.
//

import Foundation

struct LinkedStudent: Codable{
    let studentUserId: Int
    let teamId: Int
    let studentUser: StudentUser
    let team: Team
}
