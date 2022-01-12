//
//  Programs.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 11/12/2020.
//

import Foundation

struct Program: Codable, Identifiable, Hashable{
    let id: Int?
    let name: String
    //let linkedComakerships: ComakershipProgram?
    
    init(name: String){
        id = nil
        self.name = name
    }
}
