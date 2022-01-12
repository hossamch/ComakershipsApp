//
//  RegisterCompanyVM.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 22/12/2021.
//

import Foundation
import Combine

class RegisterCompanyVM: ObservableObject{
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPass: String = ""
    private var emails = ["@inholland", "@hva", "@nhlstenden", "@student.inholland", "@student.nhlstenden", "@windesheim", "@student.windesheim"]
    static var shared = RegisterCompanyVM()
    
    private init(){}
    
    static func renew(){
        self.shared = RegisterCompanyVM()
    }
    
    var signUpComplete: Bool{
        if !validatePassword() || !validatePassword2() || !validateEmail() || name == ""{
            return false
        }
        return true
    }
    
    var namePrompt: String{
        if name != ""{
            return ""
        }
        return "Enter your name please"
    }

    var passwordPrompt: String{
        if validatePassword(){
            return ""
        }
        return "The password should start with a letter and must be between 4 and 15 characters long. Only letters numbers and underscores may be used."
    }
    
    var confirmPassPrompt: String{
        if validatePassword2(){
            return ""
        }
        return "The passwords do not match."
    }
    
    var emailPrompt: String{
        if validateEmail(){
            return ""
        }
        return "Please enter a valid email address."
    }
    
    
    func validatePassword() -> Bool{
        //The password's first character must be a letter, it must contain at least 4 characters and no more than 15 characters and no characters other than letters, numbers and the underscore may be used
        let test = NSPredicate(format: "SELF MATCHES %@", "^[a-zA-Z]\\w{3,14}$")
        return test.evaluate(with: password)
    }
    
    func validatePassword2() -> Bool{
        confirmPass == password
    }
    
    func validateEmail() -> Bool{
        //Email validator that adheres directly to the specification for email address naming. It allows for everything from ipaddress and country-code domains, to very rare characters in the username.
        let test = NSPredicate(format: "SELF MATCHES %@", "^([a-zA-Z0-9_\\-\\.]+)@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\\]?)$")
        return test.evaluate(with: email)
    }
    
    func validateEmail2() -> Bool{
        var valid = false
        emails.forEach { it in
            if (email.contains(it)){
                valid = true
            }
        }
        return valid
    }
    
}
