//
//  Review.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 11/12/2020.
//

import Foundation

struct Review: Codable{
    let id: Int
    let companyId: Int
    let studentUserId: Int
    let reviewersName: String
    let rating: Float
    let comment: String
    let forCompany: Bool
    
    init(){
        id = 0
        companyId = 0
        studentUserId = 0
        reviewersName = ""
        rating = 0
        comment = ""
        forCompany = false
    }
    
    enum CodingKeys: String, CodingKey{
        case id
        case companyId
        case studentUserId
        case reviewersName
        case rating
        case comment
        case forCompany
    }
}
