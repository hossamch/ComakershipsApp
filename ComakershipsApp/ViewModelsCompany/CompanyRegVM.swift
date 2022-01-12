//
//  CompanyVM.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 24/12/2021.
//

import Foundation

// register companyvm
class CompanyRegVM: ObservableObject{
    @Published var companyName: String = ""
    @Published var description: String = ""
    @Published var street: String = ""
    @Published var city: String = ""
    @Published var zipcode: String = ""
    @Published var fullname: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPass: String = ""
    static var shared = CompanyRegVM()
    
    private init(){}
    
    static func renew(){
        self.shared = CompanyRegVM()
    }
    
    
    var signUpCompleteForCompany: Bool{
        if  !validateEmptyFields() || !validateEmail() || !validateEmail2() || !validatePassword2() || !validatePassword(){
            return false
        }
        return true
    }
    
    var signUpCompleteForCompanyUser: Bool{
        if  !validateEmptyFieldsUser() || !validateEmail() || !validatePassword2() || !validatePassword(){
            return false
        }
        return true
    }
    
    func validateEmptyFieldsUser() -> Bool{
        if  companyName != "" || description != "" || street != "" || city != "" || zipcode != "" || fullname == "" || email == "" || password == ""{
            return false
        }
        return true
    }
    
    func checkFieldsForUserEmailPrompt() -> Bool{
        if companyName != "" || description != "" || street != "" || city != "" || zipcode != ""{
            return false
        }
        return true
    }
    
    func validateEmptyFields() -> Bool{
        if  companyName == "" || description == "" || fullname == "" || email == "" || password == ""{
            return false
        }
        return true
    }
    
    var companyNamePrompt: String{
        if companyName != ""{
            return ""
        }
        return "Enter your company name."
    }
    
    var desciptionPrompt: String{
        if description != ""{
            return ""
        }
        return "Give your company a description."
    }
    
    var streetPrompt: String{
        if street != ""{
            return ""
        }
        return "Enter the street of the company."
    }
    
    var cityPrompt: String{
        if city != ""{
            return ""
        }
        return "Enter the city of the company."
    }
    
    var zipcodePrompt: String{
        if zipcode != ""{
            return ""
        }
        return "Enter the zipcode of the company."
    }
    
    var namePrompt: String{
        if fullname != ""{
            return ""
        }
        return "Enter your full name."
    }

    var emailPrompt: String{
        if !validateEmail(){
            return "Please enter a valid email address."
        }
        else if checkFieldsForUserEmailPrompt(){
            return ""
        }
        else if !validateEmail2(){
            return "Your company needs to have its own email domain."
        }
        return ""
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
        if (email.contains("@\(companyName.lowercased()).")){
            valid = true
        }
        
        return valid
    }
}
