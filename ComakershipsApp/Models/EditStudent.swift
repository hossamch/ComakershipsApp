//
//  EditStudent.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 20/12/2021.
//

import Foundation

class EditStudent: Codable{
    let name: String
    let about: String
    let links: [String]
    let nickName: String
    
    enum CodingKeys: String, CodingKey{
        case name
        case about
        case links
        case nickName = "nickname"
    }
}
