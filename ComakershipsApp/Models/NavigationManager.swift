//
//  NavigationManager.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 09/01/2022.
//

import Foundation

final class NavigationManager: ObservableObject{
    @Published var selected = 1
    static let shared = NavigationManager()
    
    private init(){}
    
    func changeTab(tab: Int){
        self.selected = tab
    }
}
