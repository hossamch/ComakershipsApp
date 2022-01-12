//
//  University.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 12/12/2020.
//

import Foundation

struct University: Codable{
    let id: Int
    let name: String
    let registrationDate: String
    let domain: String
    let street: String
    let city: String
    let zipcode: String
    
    enum CodingKeys: String, CodingKey{
        case id
        case name
        case registrationDate
        case domain
        case street
        case city
        case zipcode
    }
    init(){
        self.id = 1
        self.name = ""
        self.registrationDate = ""
        self.domain = ""
        self.street = ""
        self.city = ""
        self.zipcode = ""
    }
}
