//
//  TeamPost.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 01/01/2022.
//

import Foundation

struct TeamPost: Encodable{
    let name: String
    let description: String
    
    enum CodingKeys: String, CodingKey{
        case name
        case description
    }
}
