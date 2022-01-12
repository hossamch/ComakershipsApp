//
//  CompanyUserGet.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 25/12/2021.
//

import Foundation

class CompanyUserGet: Decodable{
    let company: Company?
    let isCompanyAdmin: Bool
    let companyId: Int?
    let id: Int
    let name: String
    let email: String
    let deleted: Bool
    
    init(){
        company = Company()
        isCompanyAdmin = false
        companyId = 0
        id = 0
        name = "default"
        email = "default"
        deleted = false
    }
    
    enum CodingKeys: String, CodingKey{
        case company
        case isCompanyAdmin
        case companyId
        case id
        case name
        case email
        //case password
        case deleted
    }
}
