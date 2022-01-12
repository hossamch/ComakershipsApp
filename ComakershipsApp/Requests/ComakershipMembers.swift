//
//  ComakershipMembers.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 06/01/2022.
//

import Foundation

struct ComakershipMembers: Decodable{
    let id: Int
    var students: [Member]
    
    init(){
        id = 0
        students = [Member]()
    }
}
