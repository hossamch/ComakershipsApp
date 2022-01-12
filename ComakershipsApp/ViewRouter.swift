//
//  ViewRouter.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 26/12/2021.
//

import Foundation

class ViewRouter: ObservableObject{
    @Published var currentPage: Page = .loggedin
        
}

enum Page{
    case loggedin
    case logout
}
