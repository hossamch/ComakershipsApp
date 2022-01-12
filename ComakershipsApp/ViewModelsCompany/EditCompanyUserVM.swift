//
//  EditCompanyUserVM.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 26/12/2021.
//

import Foundation
import Combine

final class EditCompanyUserVM: ObservableObject{
    @Published var name = ""
    @Published var oldPassword = ""
    @Published var newPassword = ""
    @Published var confirmPass = ""
    @Published var loading = false
    @Published var isAlerted = false
    @Published var wrongPass = false
    @Published var success = false
    private let api = API.shared
    static var shared = EditCompanyUserVM()
    private var cancellables = Set<AnyCancellable>()
    
    private init(){
//        self.name = api.userFullName!
    }
    
    static func renew(){
        self.shared = EditCompanyUserVM()
    }
    
    var complete: Bool{
        if name != ""{
            return true
        }
        return false
    }
    
    var completeChangePass: Bool{
        if oldPassword != "" && validatePassword() && validatePassword2() || !validatePassFields{
            return true
        }
        return false
    }
    
    var validatePassFields: Bool{
        if oldPassword == "" && newPassword == "" && confirmPass == ""{
            return false
        }
        return true
    }
    
    var oldPassPrompt: String{
        if oldPassword == ""{
            return "Enter your current password."
        }
        return ""
    }
    
    var newPassPrompt: String{
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
    
    var namePrompt: String{
        if name == ""{
            return "Please enter your name."
        }
        return ""
    }
    
    func validatePassword() -> Bool{
        //The password's first character must be a letter, it must contain at least 4 characters and no more than 15 characters and no characters other than letters, numbers and the underscore may be used
        let test = NSPredicate(format: "SELF MATCHES %@", "^[a-zA-Z]\\w{3,14}$")
        return test.evaluate(with: newPassword)
    }
    
    func validatePassword2() -> Bool{
        confirmPass == newPassword
    }
    func getCompanyUser(){
        if !api.isAuthenticated{
            return
        }
        loading = true
        let url = URL(string: api.apiUrl + "/CompanyUser/\(api.userId!)")!
        print("shit: Bearer\(api.accessToken!)")
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-type")
        urlRequest.setValue("Bearer \(api.accessToken!)", forHTTPHeaderField: "Authorization")
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
            .decode(type: CompanyUserGet.self, decoder: JSONDecoder())
            .sink { (completion) in
            } receiveValue: { (result) in
                self.name = result.name
                self.loading = false
            }
            .store(in: &cancellables)
    }
    
    
    func changePassword(completion: @escaping (Result<Void, RequestError>) -> Void){
        if !validatePassFields{return}
        success = false
        wrongPass = false
        loading = true
        let url = URL(string: api.apiUrl + "/User/ChangePassword")!
        print("shit: Bearer\(api.accessToken!)")
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-type")
        urlRequest.setValue("Bearer \(api.accessToken!)", forHTTPHeaderField: "Authorization")
        urlRequest.httpMethod = "POST"
        
        let parameters = ChangePassword(
            oldPassword: self.oldPassword,
            newPassword: self.newPassword,
            confirmNewPassword: self.confirmPass
        )
        
        let encoder = JSONEncoder()
        guard let body = try? encoder.encode(parameters) else {return}
        urlRequest.httpBody = body
        
        URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap{ (data, response) -> Data in
                guard let response = response as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode <= 300 else{
                    let res = response as? HTTPURLResponse
                    print(res!.statusCode)
                    if res!.statusCode == 401{
                        self.api.logout()
                    } else if res!.statusCode == 400{
                        self.wrongPass = true
                        
                    }
                    throw URLError(.badServerResponse)
                }
                print("response: \(response)")
                return data
            }
            //.decode(type: RegisterResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { (result) in
                switch result {
                case .finished:
                    print("result: \(result)")
                    self.success = true
                    self.isAlerted = true
                    self.loading = false
                    break
                case .failure(let error):
                    switch error {
                    case let urlError as URLError:
                        completion(.failure(.urlError(urlError)))
                    case let decodingError as DecodingError:
                        completion(.failure(.decodingError(decodingError)))
                    default:
                        completion(.failure(.genericError(error)))
                    }
                }
            }, receiveValue: { (response)  in
                self.loading = false
   
            })
            .store(in: &cancellables)
    }
    
    
    func editCompanyUser(completion: @escaping (Result<Void, RequestError>) -> Void){
        if name == api.userFullName! || name == ""{return}
        success = false
        loading = true
        let url = URL(string: api.apiUrl + "/CompanyUser")!
        print("shit: Bearer\(api.accessToken!)")
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-type")
        urlRequest.setValue("Bearer \(api.accessToken!)", forHTTPHeaderField: "Authorization")
        urlRequest.httpMethod = "PUT"
        
        let parameters = CompanyUserToEdit(
            name: name
        )
        
        let encoder = JSONEncoder()
        guard let body = try? encoder.encode(parameters) else {return}
        urlRequest.httpBody = body
        
        URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap{ (data, response) -> Data in
                guard let response = response as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode <= 300 else{
                    let res = response as? HTTPURLResponse
                    print(res!.statusCode)
                    if res!.statusCode == 401{
                        self.api.logout()
                    }
                    throw URLError(.badServerResponse)
                    
                }
                print("response: \(response)")
                return data
            }
            //.decode(type: RegisterResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { (result) in
                switch result {
                case .finished:
                    print("result: \(result)")
                    self.api.userFullName = self.name
                    self.success = true
                    self.isAlerted = true
                    break
                case .failure(let error):
                    switch error {
                    case let urlError as URLError:
                        completion(.failure(.urlError(urlError)))
                    case let decodingError as DecodingError:
                        completion(.failure(.decodingError(decodingError)))
                    default:
                        completion(.failure(.genericError(error)))
                    }
                }
            }, receiveValue: { (response)  in
                self.loading = false
            })
            .store(in: &cancellables)
    }
}
