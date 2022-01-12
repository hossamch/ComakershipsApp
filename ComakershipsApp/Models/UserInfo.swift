//
//  UserInfo.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 22/12/2020.
//

import Combine

public class UserInfo: ObservableObject{
    @Published var userId: String = ""
    @Published var userType: String = ""
    
//    init(response: LoginResponse){
//        self.userId = response.userId
//        self.userType = response.userType
//    }
}
