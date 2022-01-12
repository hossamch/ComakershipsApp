//
//  RegisterResponse.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 13/12/2020.
//

import Foundation

struct RegisterResponse: Decodable{
    let message: String
    
    enum CodingKeys: String, CodingKey{
        case message
    }
    
}
