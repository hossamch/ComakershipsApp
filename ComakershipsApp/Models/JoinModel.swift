//
//  JoinModel.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 01/01/2022.
//

import Foundation

struct JoinModel: Identifiable{
    let id = UUID()
    var results: [[JoinQuery]]
    
    init(){
        //id = 0
        results = [[JoinQuery]]()
    }
}
