//
//  ModelManager.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 09/01/2022.
//

import Foundation

final class ModelManager: ObservableObject{
    @Published var isInstantiated = false
    static let shared = ModelManager()
    
    private init(){
        
    }
}
