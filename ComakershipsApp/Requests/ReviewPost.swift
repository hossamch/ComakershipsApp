//
//  ReviewPost.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 09/01/2022.
//

import Foundation

struct ReviewPost: Encodable{
    let companyId: Int
    let studentUserId: Int
    let rating: Int
    let comment: String
    let forCompany: Bool
}
