//
//  RegisterStudent.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 13/12/2020.
//

import Foundation

struct RegisterStudent: Encodable{
    let firstName: String
    let lastName: String
    let email: String
    let password: String
    let programId: Int?
    let nickName: String
    
    enum CodingKeys: String, CodingKey{
        case firstName
        case lastName
        case email
        case password
        case programId
        case nickName = "nickname"
    }
}
