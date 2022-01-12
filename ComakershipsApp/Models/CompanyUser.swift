//
//  CompanyUser.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 13/12/2020.
//

import Foundation

struct CompanyUser: Codable{
    let id: Int
    let name: String
    let email: String
    let password: String
    let deleted: Bool
    let companyId: Int
    let company: Company
    
    enum CodingKeys: String, CodingKey{
        case id
        case name
        case email
        case password
        case deleted
        case companyId = "companyid"
        case company
    }
}
