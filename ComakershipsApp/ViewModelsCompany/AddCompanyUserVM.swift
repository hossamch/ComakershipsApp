//
//  AddCompanyUserVM.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 08/01/2022.
//

import Foundation
import Combine

final class AddCompanyUserVM: ObservableObject{
    @Published var loading = false
    @Published var email: String = ""
    @Published var isAdmin = false
    @Published var topLevel = ""
    @Published var api = API.shared
    @Published var isAlerted = false
    @Published var added = false
    static var shared = AddCompanyUserVM()
    
    private var cancellables = Set<AnyCancellable>()
    
    private init(){
        
    }
    
    static func renew(){
        self.shared = AddCompanyUserVM()
    }
    
    var prompt: String{
        if email == ""{
            return "Please enter the email of the user you wish to add."
        }
        else if !validateEmail{
            return "You can only add user who are registered under the same domain."
        }
        return ""
    }
    
    var validateEmail: Bool{
        return email.contains(topLevel)
    }
    
    func getTopLevel(name: String){
        topLevel = "@\(name)".lowercased()
    }
    
    func addCompanyUser(id: Int, completion: @escaping (Result<Void, RequestError>) -> Void){
        loading = true
        let url = URL(string: api.apiUrl + "/company/\(id)/addcompanyuser")!
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-type")
        urlRequest.setValue("Bearer \(api.accessToken!)", forHTTPHeaderField: "Authorization")
        urlRequest.httpMethod = "POST"
        
        let parameters = AddCompanyUser(
            userEmail: email, makeAdmin: isAdmin
        )
        
        let encoder = JSONEncoder()
        guard let body = try? encoder.encode(parameters) else {return}
        urlRequest.httpBody = body

        URLSession.shared.dataTaskPublisher(for: urlRequest)
            .receive(on: DispatchQueue.main)
            .tryMap{ (data, response) -> Data in
                let res = response as? HTTPURLResponse
                print(res!.statusCode)
                guard let response = response as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode <= 300 else{
                    print(res!.statusCode)
                    if res!.statusCode == 401{
                        self.api.logout()
                    }
                    else if res!.statusCode == 404{
                        print("not found")
                        self.loading = false
                       // self.fetched = true
                    }
                    self.loading = false
                    throw URLError(.badServerResponse)
                }
               // self.fetchingStudents = false
                print(res!.statusCode)
                return data
            }
            //.decode(type: String.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { (result) in
                switch result {
                case .finished:
                    self.loading = false
                    self.added = true
                    self.isAlerted = true
                    print("result: \(result)")
                    break
                case .failure(let error):
                    switch error {
                    case let urlError as URLError:
                        completion(.failure(.urlError(urlError)))
                    case let decodingError as DecodingError:
                        completion(.failure(.decodingError(decodingError)))
                    case let RequestError.invalidPurchaseKey:
                        completion(.failure(.invalidPurchaseKey))
                    default:
                        completion(.failure(.genericError(error)))
                    }
                }
            }, receiveValue: { (response)  in
                //dit word geexecute
                print("iwts")
            })
            .store(in: &cancellables)
    }
}
