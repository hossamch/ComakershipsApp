//
//  TeamMembers.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 04/01/2022.
//

import Foundation

struct TeamMembers: Decodable, Identifiable{
    let id: Int
    let name: String
    let description: String
    let members: [Member]
}
