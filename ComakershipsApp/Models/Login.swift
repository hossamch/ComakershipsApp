//
//  Login.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 13/12/2020.
//

import Foundation

struct Login: Encodable{
    let email: String
    let password: String
    
    enum CodingKeys: String, CodingKey{
        case email
        case password
    }
}
