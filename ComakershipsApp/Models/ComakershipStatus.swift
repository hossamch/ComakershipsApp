//
//  Status.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 11/12/2020.
//

import Foundation

struct ComakershipStatus: Codable{
    let id: Int
    let name: String
    
    init(){
        id = 0
        name = "default"
    }
}
