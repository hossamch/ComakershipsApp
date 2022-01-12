//
//  ComakershipsGet.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 31/12/2020.
//

import Foundation

struct ComakershipsGet: Codable{
    let comakerships: [Comakership]
    
    enum CodingKeys: String, CodingKey{
        case comakerships
    }
}
