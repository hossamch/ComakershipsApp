//
//  LoginVM.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 29/12/2021.
//

import Foundation

final class LoginVM: ObservableObject{
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var api = API.shared
    static var shared = LoginVM()
    
    private init(){}
    
    static func renew(){
        self.shared = LoginVM()
    }
    
    var loginComplete: Bool{
        if email == "" || password == ""{
            return false
        }
        return true
    }
    
    var emailPrompt: String{
        if email != ""{
            return ""
        }
        return "Enter your email please"
    }
    
    var passwordPrompt: String{
        if password != ""{
            return ""
        }
        return "Enter your password please."
    }
}
