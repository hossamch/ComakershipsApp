//
//  TeamResponse.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 20/12/2021.
//

import Foundation

struct TeamResponse: Decodable, Identifiable, Equatable{
    let id: Int
    let name: String
    let description: String
    
//    init(){
//        self.id = 0
//        self.name = ""
//        self.description = ""
//    }
    
    enum CodingKeys: String, CodingKey{
        case id
        case name
        case description
    }
}
