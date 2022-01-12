//
//  Company.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 11/12/2020.
//

import Foundation

struct ComakershipCompany: Codable{
    let id: Int
    let name: String
    let description: String
    let registrationDate: String
    let reviews: [Review?]
    let street: String
    let city: String
    let zipcode: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case registrationDate
        case reviews
        case street
        case city
        case zipcode
    }
    
    init(){
        id = 0
        name = ""
        description = ""
        registrationDate = ""
        reviews = [Review]()
        street = ""
        city = ""
        zipcode = ""
    }
}
