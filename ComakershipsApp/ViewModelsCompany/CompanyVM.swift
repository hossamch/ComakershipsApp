//
//  CompanyVM.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 25/12/2021.
//

import Foundation
import Combine
import SwiftUI

class CompanyVM: ObservableObject{
    @Published var loading = false
    @Published var companyUser = CompanyUserGet()
    @Published var employees = [Member]()
    @Published var api = API.shared
    @Published var hasIcon = false
    static var shared = CompanyVM()
    private var isInstantiated = false
    private var cancellables = Set<AnyCancellable>()
    private var imageBase64 = ""
    
    private init(){
//        getCompany()
//        getCompanyLogo()
    }
    
    static func renew(){
        self.shared = CompanyVM()
    }
    
    func convertImage(image: UIImage){
        var imageData = image.jpegData(compressionQuality: 1)
        imageData = image.pngData()
        imageBase64 = (imageData?.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters))!
        print(imageBase64)
    }
    
    func uploadImage(){
        loading = true
        let url = URL(string: api.apiUrl + "/company/\(companyUser.companyId!)/logo")!
        print("shit: Bearer\(api.accessToken!)")
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-type")
        urlRequest.setValue("Bearer \(api.accessToken!)", forHTTPHeaderField: "Authorization")
        urlRequest.httpMethod = "POST"
        
        let parameters = ImageRequest(
            logoAsBase64: self.imageBase64
        )
        
        let encoder = JSONEncoder()
        guard let body = try? encoder.encode(parameters) else {return}
        urlRequest.httpBody = body
        
        URLSession.shared.dataTaskPublisher(for: urlRequest)
            //.map{$0.data}
            .tryMap{ (data, response) -> Data in
                guard let response = response as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode <= 300 else{
                    let res = response as? HTTPURLResponse
                    print(res!.statusCode)
                    if res!.statusCode == 422{
                        throw RequestError.invalidPurchaseKey
                    }
                    throw URLError(.badServerResponse)
                    
                }
                print("response: \(response)")
                return data
            }
            //.decode(type: RegisterResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { (result) in
//                switch result {
//                case .finished:
//                    self.loading = false
//                    print("result: \(result)")
//                    break
//                case .failure(let error):
//                    switch error {
//                    case let urlError as URLError:
//                        completion(.failure(.urlError(urlError)))
//                    case let decodingError as DecodingError:
//                        completion(.failure(.decodingError(decodingError)))
//                    case let RequestError.invalidPurchaseKey:
//                        completion(.failure(.invalidPurchaseKey))
//                    default:
//                        completion(.failure(.genericError(error)))
//                    }
//                }
            }, receiveValue: { (response)  in
                //executed
                print("fsgd")
            })
            .store(in: &cancellables)
    }
    
    func getCompanyLogo(){
        if !api.isAuthenticated{
            return
        }
        loading = true
        let url = URL(string: api.apiUrl + "/company/\(3)/logo")!
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
            .decode(type: String.self, decoder: JSONDecoder())
            .sink { (completion) in
            } receiveValue: { (result) in
                if result != ""{
                    guard self.companyUser.company != nil else {return}
                    self.companyUser.company!.logoGuid = result
                    self.hasIcon = true
                }
//                self.companyUser = result
//                self.api.userFullName = result.name
            }
            .store(in: &cancellables)
    }
    
    func getCompany(){
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
                self.companyUser = result
                self.api.userFullName = result.name
            }
            .store(in: &cancellables)
    }
}
