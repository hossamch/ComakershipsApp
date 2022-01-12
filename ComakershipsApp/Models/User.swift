//
//  User.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 12/12/2020.
//

import Foundation

class User{
    let id: Int
    let name: String
    let email: String
    let password: String
    
    init(id: Int, name: String, email: String, password: String){
        self.id = id
        self.name = name
        self.email = email
        self.password = password
    }
}
