//
//  RegisterCompanyWithLogo.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 22/12/2021.
//

import Foundation

struct RegisterCompanyWithLogo: Encodable{
    let name: String
    let description: String
    let logoAsBase64: String = ""
    let logoGuid: String
    let street: String
    let city: String
    let zipcode: String
    let companyUser: CompanyUserReg
    
    enum CodingKeys: String, CodingKey{
        case logoAsBase64 = "LogoAsBase64"
        case companyUser = "CompanyUser"
    }
}
