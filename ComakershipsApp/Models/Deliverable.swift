//
//  Deliverable.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 12/12/2020.
//

import Foundation

struct Deliverable: Codable{
    let id: Int?
    let name: String
    let finished: Bool?
    
    init(name: String){
        id = nil
        self.name = name
        finished = nil
    }
}
