//
//  Company.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 12/12/2020.
//

import Foundation

class Company: Codable{
    let id: Int
    let name: String
    let description: String
    var logoGuid: String?
    let comakerships: [Comakership]?
    let registrationDate: String
    let reviews: [Review]?
    let street: String
    let city: String
    let zipcode: String
    
    init(){
        self.id = 0
        self.name = ""
        self.description = ""
        self.logoGuid = ""
        self.comakerships = nil
        self.registrationDate = ""
        self.reviews = [Review]()
        self.street = ""
        self.city = ""
        self.zipcode = ""
    }
    
    enum CodingKeys: String, CodingKey{
        case id
        case name
        case description
        case logoGuid
        case comakerships
        case registrationDate
        case reviews
        case street
        case city
        case zipcode
    }
}
