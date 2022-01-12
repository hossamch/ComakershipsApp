//
//  Student.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 15/12/2021.
//

import Foundation

class Student: Decodable{
    let id: Int
    let name: String
    let email: String
    
    init(){
        self.id = 0
        self.name = ""
        self.email = ""
    }
    
    enum CodingKeys: String, CodingKey{
        case id
        case name
        case email
    }
}
