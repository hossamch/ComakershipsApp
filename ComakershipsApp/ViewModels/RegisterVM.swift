//
//  RegisterVM.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 06/12/2021.
//

import Foundation
import Combine

class RegisterVM: ObservableObject{
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPass: String = ""
    @Published var nickName: String = ""
    @Published var currentlySelectedProgram: Int? = nil
    @Published var loading: Bool = false
    @Published var programs = [Program]()
    @Published var progrId: Int? = nil
    static var shared = RegisterVM()
    private var emails = ["@inholland", "@hva", "@nhlstenden", "@student.inholland", "@student.nhlstenden", "@windesheim", "@student.windesheim"]
    private var api = API.shared
    
    private var cancellables = Set<AnyCancellable>()
    
    private init(){
        getPrograms()
    }
    
    static func renew(){
        self.shared = RegisterVM()
    }
    
    var signUpComplete: Bool{
        if !validatePassword() || !validatePassword2() || !validateEmail() || !validateEmail2() || firstName == "" || lastName == "" || currentlySelectedProgram == nil{
            return false
        }
        return true
    }
    
    var firstNamePrompt: String{
        if firstName != ""{
            return ""
        }
        return "Enter your first name please"
    }
    
    var lastNamePrompt: String{
        if lastName != ""{
            return ""
        }
        return "Enter your last name please"
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
        if validateEmail() && validateEmail2(){
            return ""
        }
        return "The email should be a valid university email within the netherlands."
    }
    
    var programPrompt: String{
        if currentlySelectedProgram == nil{
            return "Please select your study program."
        }
        return ""
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
    
    func getPrograms(){
        loading = true
        let url = URL(string: api.apiUrl + "/programs/")!
//        print("shit: Bearer\(api.accessToken!)")
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-type")
        //urlRequest.setValue("Bearer \(api.accessToken!)", forHTTPHeaderField: "Authorization")
        urlRequest.httpMethod = "GET"

        URLSession.shared.dataTaskPublisher(for: urlRequest)
            .receive(on: DispatchQueue.main)
            .tryMap{ (data, response) -> Data in
                guard let response = response as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode <= 300 else{
                    let res = response as? HTTPURLResponse
                    print(res!.statusCode)
                    if res!.statusCode == 401{
                        self.api.logout()
                    }
                    throw URLError(.badServerResponse)
                }
                self.loading = false
                print("response: \(response)")
                return data
            }
            .decode(type: [Program].self, decoder: JSONDecoder())
            .sink { (completion) in
            } receiveValue: { (result) in
                self.programs = result
//                self.programs.insert(Program(name: "Program"), at: 0)
                self.loading = false
            }
            .store(in: &cancellables)
    }
}
