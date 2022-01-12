//
//  TeamApplycation.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 04/01/2022.
//

import Foundation

struct TeamApplication: Decodable{
    //var id = UUID()
    let teamId: Int
    let comakershipId: Int
    let team: TeamMembers
}
