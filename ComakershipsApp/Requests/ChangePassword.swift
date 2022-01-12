//
//  ChangePassword.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 08/01/2022.
//

import Foundation

struct ChangePassword: Encodable{
    let oldPassword: String
    let newPassword: String
    let confirmNewPassword: String
}
