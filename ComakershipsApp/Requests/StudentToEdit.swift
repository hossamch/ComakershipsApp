//
//  StudentToEdit.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 26/12/2021.
//

import Foundation

struct StudentToEdit: Codable{
    let name: String
    let about: String?
    let links: [String?]
    let nickname: String?
    
    enum CodingKeys: String, CodingKey{
        case name
        case about
        case links
        case nickname
    }
}
