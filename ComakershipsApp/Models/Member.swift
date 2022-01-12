//
//  Member.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 04/01/2022.
//

import Foundation

struct Member: Decodable, Identifiable{
    let id: Int
    let name: String
    let email: String
}
