//
//  UserComakership.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 01/01/2022.
//

import Foundation

struct UserComakership: Codable{
    let studentUserId: Int
    let comakershipId: Int
    let studentUser: StudentUserT
    let comakership: Comakership
}
