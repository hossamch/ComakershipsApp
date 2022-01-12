//
//  RegisterCompany.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 22/12/2021.
//

import Foundation

struct RegisterCompany: Encodable{
    let name: String
    let description: String
    let street: String
    let city: String
    let zipcode: String
    let companyUser: CompanyUserReg
}
