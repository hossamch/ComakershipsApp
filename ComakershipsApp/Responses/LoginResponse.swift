//
//  LoginResponse.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 11/12/2020.
//

import Foundation

struct LoginResponse: Decodable{
    let userType: String
    let userId: String
    let accessToken: String
    let message: String?
    
    enum CodingKeys: String, CodingKey{
        case userType = "UserType"
        case userId = "UserId"
        case accessToken = "Token"
        case message
    }
    
}
