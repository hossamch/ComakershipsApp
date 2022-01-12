//
//  API.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 11/12/2020.
//

import Foundation
import Combine
import KeychainAccess

final public class API: ObservableObject{
    static let shared = API()
    @Published var isAuthenticated: Bool = false
    public var notification: Bool = false
    private let keychain = Keychain()
    private var accessTokenKey = "accessToken"
    //private var userIdKey = "userId"
    
    private var cancellable : AnyCancellable?
    private var cancellables = Set<AnyCancellable>()
    //private var apiUrl = "https://comakershipsapi.azurewebsites.net/api"
    var apiUrl = "http://192.168.1.105:7071/api"
    
    var accessToken: String? {
        get {
            try? keychain.get(accessTokenKey)
        }
        set(newValue) {
            guard let accessToken = newValue else {
                try? keychain.remove(accessTokenKey)
                isAuthenticated = false
                return
            }
            try? keychain.set(accessToken, key: accessTokenKey)
            isAuthenticated = true
        }
    }
    
    var userFullName: String?{
        get{
            try? keychain.get("userFullName")
        }
        set(newValue){
            guard let userFullName = newValue else {
                try? keychain.remove("userFullName")
                return
            }
            try? keychain.set(userFullName, key: "userFullName")
        }
    }
    
    var userId: String?{
        get{
            try? keychain.get("userId")
        }
        set(newValue){
            guard let userId = newValue else {
                try? keychain.remove("userId")
                return
            }
            try? keychain.set(userId, key: "userId")
        }
    }
    
    var userType: String?{
        get{
            try? keychain.get("userType")
        }
        set(newValue){
            guard let userType = newValue else{
                try? keychain.remove("userType")
                return
            }
            try? keychain.set(userType, key: "userType")
        }
    }
    
    private init(){
        isAuthenticated = accessToken != nil
    }
    
    func login(email: String, password: String, completion: @escaping (Result<LoginResponse, RequestErrors>) -> Void){
        let url = URL(string: self.apiUrl + "/Login")!
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-type")
        urlRequest.httpMethod = "POST"
        
        let parameters = Login(
            email: email,
            password: password
        )
        
        let encoder = JSONEncoder()
        guard let body = try? encoder.encode(parameters) else {return}
        urlRequest.httpBody = body
        
        URLSession.shared.dataTaskPublisher(for: urlRequest)
            .map{$0.data}
//            .tryMap() { element -> Data in
//                    guard let httpResponse = element.response as? HTTPURLResponse,
//                        httpResponse.statusCode == 200 else {
//                            throw URLError(.badServerResponse)
//                        }
//                    return element.data
//                    }
            .decode(type: LoginResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { (result) in
                switch result {
                case .finished:
                    break
                case .failure(let error):
                    switch error {
                    case is URLError:
                        completion(.failure(.addressUnreachable(url, error)))
                    case is DecodingError:
                        completion(.failure(.invalidResponse(error)))
                    default:
                        completion(.failure(.genericError(error)))
                    }
                }
            }, receiveValue: { (response)  in
                print(response)
                completion(.success(response))
            })
            .store(in: &cancellables)
    }
    
    func registerStudent(firstName: String, lastName: String, email: String, nickName: String, password: String, programId: Int, completion: @escaping (Result<Void, RequestError>) -> Void){
        
        let url = URL(string: self.apiUrl + "/Students")!
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-type")
        urlRequest.httpMethod = "POST"
        
        let parameters = RegisterStudent(
            firstName: firstName,
            lastName: lastName,
            email: email,
            password: password,
            programId: programId,
            nickName: nickName
        )
        
        let encoder = JSONEncoder()
        guard let body = try? encoder.encode(parameters) else {return}
        urlRequest.httpBody = body
        
        URLSession.shared.dataTaskPublisher(for: urlRequest)
            .map{$0.data}
            //.decode(type: RegisterResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { (result) in
                switch result {
                case .finished:
                    print("result: \(result)")
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
                //dit wordt ge exexute
                completion(.success(response))
            })
            .store(in: &cancellables)
    }
    
    func registerCompanyUser(name: String, email: String, password: String, completion: @escaping (Result<Void, RequestError>) -> Void){
        
        let url = URL(string: self.apiUrl + "/CompanyUser")!
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-type")
        urlRequest.httpMethod = "POST"
        
        let parameters = CompanyUserReg(
            name: name,
            email: email,
            password: password
        )
        
        let encoder = JSONEncoder()
        guard let body = try? encoder.encode(parameters) else {return}
        urlRequest.httpBody = body
        
        URLSession.shared.dataTaskPublisher(for: urlRequest)
            .map{$0.data}
            //.decode(type: RegisterResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { (result) in
                switch result {
                case .finished:
                    print("result: \(result)")
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
                //print("completion: \(completion)")
                //print("response: \(response)")
                completion(.success(response))
            })
            .store(in: &cancellables)
    }
    
    func createCompany(name: String, description: String, street: String, city: String, zipcode: String, username: String, email: String, password: String, completion: @escaping (Result<Void, RequestError>) -> Void){
        let url = URL(string: self.apiUrl + "/company")!
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-type")
        urlRequest.httpMethod = "POST"
        
        let parameters = RegisterCompany(
            name: name,
            description: description,
            street: street,
            city: city,
            zipcode: zipcode,
            companyUser: CompanyUserReg(
                name: username,
                email: email,
                password: password
            )
        )
        
        let encoder = JSONEncoder()
        guard let body = try? encoder.encode(parameters) else {return}
        urlRequest.httpBody = body
        
        URLSession.shared.dataTaskPublisher(for: urlRequest)
            .map{$0.data}
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { (result) in
                switch result {
                case .finished:
                    print("result: \(result)")
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
                completion(.success(response))
            })
            .store(in: &cancellables)
    }
    
    func getComakerships(completion: @escaping (Result<ComakershipsGet, RequestError>) -> Void){
        
        let url = URL(string: self.apiUrl + "/Students")!
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-type")
        urlRequest.httpMethod = "POST"
    
        
        URLSession.shared.dataTaskPublisher(for: urlRequest)
            .map{$0.data}
            .decode(type: ComakershipsGet.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { (result) in
                switch result {
                case .finished:
                    print(result)
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
                completion(.success(response))
            })
            .store(in: &cancellables)
    }
    
    func getStudentUser(id: String, completion: @escaping (Result<StudentUser, RequestErrors>) -> Void){
//    func getStudentUser(id: String) -> StudentUser{
        var student = StudentUser()
        let url = URL(string: self.apiUrl + "/Students/\(id)")!
        print(self.apiUrl + "/Students/\(id)")
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-type")
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("Bearer \(self.accessToken)", forHTTPHeaderField: "Authorization")
        //print(self.accessToken ?? "nigga")
        //urlRequest.setValue(self.accessToken, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTaskPublisher(for: urlRequest)
            .map{$0.data}
            .decode(type: StudentUser.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { (result) in
                switch result {
                case .finished:
                    print(result)
                    break
                case .failure(let error):
                    switch error {
                    case is URLError:
                        completion(.failure(.addressUnreachable(url, error)))
                    case is DecodingError:
                        completion(.failure(.invalidResponse(error)))
                    case is EncodingError:
                        completion(.failure(.encodingError(error)))
                    default:
                        completion(.failure(.genericError(error)))
                    }
                }
            }, receiveValue: { (response)  in
                completion(.success(response))
            })
            .store(in: &cancellables)
    }
    
    func logout(){
        if (self.userType == UserTypes.student.rawValue){
            ApplyVM.renew()
            ComakershipGetVM.renew()
            EditStudentVM.renew()
            LoginVM.renew()
            RegisterVM.renew()
            StudentVM.renew()
            TeamsVM.renew()
            EditTeamVM.renew()
            FilesVM.renew()
            DeliverablesVM.renew()
            InboxTeamsVM.renew()
        }
        else{
            InboxVM.renew()
            ComakershipVM.renew()
            CompanyRegVM.renew()
            CompanyVM.renew()
            CreateComakershipVM.renew()
            EditComakershipVM.renew()
            RegisterCompanyVM.renew()
            FilesGetVM.renew()
            AddCompanyUserVM.renew()
            EditCompanyUserVM.renew()
            
            CompanyVM.shared.companyUser = CompanyUserGet()
            ComakershipVM.shared.comakerships = [ComakershipCGet]()
        }
        
        self.accessToken = nil
        self.userId = nil
        self.userType = nil
        self.notification = false
        
    }
}
