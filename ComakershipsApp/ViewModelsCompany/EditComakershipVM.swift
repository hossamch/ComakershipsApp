//
//  EditComakershipVM.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 01/01/2022.
//

import Foundation
import Combine

final class EditComakershipVM: ObservableObject{
    @Published var comakershipMembers = ComakershipMembers()
    @Published var api = API.shared
    @Published var loading = false
    @Published var editing = false
    @Published var isAlerted = false
    @Published var started = false
    @Published var fetchingStudents = false
    @Published var hasMembers = false
    @Published var isAlertedEdited = false
    @Published var editedComakership: ComakershipCheckEdited? = nil
    @Published var kicking = false
    @Published var kicked = false
    static var shared = EditComakershipVM()
    
    private init(){}
    
    static func renew(){
        self.shared = EditComakershipVM()
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    func leaveComakership(comakershipId: Int, completion: @escaping (Result<Void, RequestError>) -> Void){
        loading = true
        let url = URL(string: api.apiUrl + "/comakerships/\(comakershipId)/leave")!
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-type")
        urlRequest.setValue("Bearer \(api.accessToken!)", forHTTPHeaderField: "Authorization")
        urlRequest.httpMethod = "POST"

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
                    //self.isAlertedEdited = true
                    print("result: \(result)")
                    completion(.success(()))
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
            })
            .store(in: &cancellables)
    }
    
    
    func kickStudent(comakershipId: Int, studentId: Int, completion: @escaping (Result<Void, RequestError>) -> Void){
        kicking = true
        let url = URL(string: api.apiUrl + "/comakerships/\(comakershipId)/kick/\(studentId)")!
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-type")
        urlRequest.setValue("Bearer \(api.accessToken!)", forHTTPHeaderField: "Authorization")
        urlRequest.httpMethod = "POST"

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
                    self.kicked = true
                    self.kicking = false
                    //self.isAlertedEdited = true
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
                self.comakershipMembers.students.remove(at: self.comakershipMembers.students.firstIndex(where: {$0.id == studentId})!)
                print("iwts")
            })
            .store(in: &cancellables)
    }
    
    func checkChanges(comakership: ComakershipCGet){
        loading = true
        let url = URL(string: api.apiUrl + "/comakerships/\(comakership.id)")!
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-type")
        urlRequest.setValue("Bearer \(api.accessToken!)", forHTTPHeaderField: "Authorization")
        urlRequest.httpMethod = "GET"

        URLSession.shared.dataTaskPublisher(for: urlRequest)
            .receive(on: DispatchQueue.main)
            .tryMap{ (data, response) -> Data in
                let res = response as? HTTPURLResponse
                print(res!.statusCode)
                guard let response = response as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode <= 300 else{
                    if res!.statusCode == 401{
                        self.api.logout()
                    }
                    else if res!.statusCode == 404{
                        print("not found")
                        self.loading = false
                       // self.fetched = true
                    }
                    throw URLError(.badServerResponse)
                }
               // self.fetchingStudents = false
                print("response: \(response)")
                return data
            }
            .decode(type: ComakershipCheckEdited.self, decoder: JSONDecoder())
            .sink { (completion) in
            } receiveValue: { (result) in
                if result.name != comakership.name{
                    self.editedComakership = result
                } else if result.description != comakership.description{
                    self.editedComakership = result
                } else if result.credits != comakership.credits{
                    self.editedComakership = result
                } else if result.bonus != comakership.bonus{
                    self.editedComakership = result
                }
                
                self.loading = false
            }
            .store(in: &cancellables)
    }
    
    func editComakership(id: Int, name: String, description: String, credits: Bool, bonus: Bool, comakershipStatusId: Int, completion: @escaping (Result<Void, RequestError>) -> Void){
        editing = true
        let url = URL(string: api.apiUrl + "/comakerships/\(id)")!
        print("shit: Bearer\(api.accessToken!)")
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-type")
        urlRequest.setValue("Bearer \(api.accessToken!)", forHTTPHeaderField: "Authorization")
        urlRequest.httpMethod = "PUT"
        
        let parameters = EditComakership(
            id: id,
            name: name,
            description: description,
            credits: credits,
            bonus: bonus,
            comakershipStatusId: comakershipStatusId
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
                switch result {
                case .finished:
                    self.editing = false
                    self.isAlertedEdited = true
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
                // dit wordt gexexecute
                print("iwts")
            })
            .store(in: &cancellables)
    }
    
    func getComakershipMembers(id: Int){
        if !api.isAuthenticated{
            return
        }
        fetchingStudents = true
        hasMembers = false
        let url = URL(string: api.apiUrl + "/comakerships/\(id)/complete")!
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-type")
        urlRequest.setValue("Bearer \(api.accessToken!)", forHTTPHeaderField: "Authorization")
        urlRequest.httpMethod = "GET"

        URLSession.shared.dataTaskPublisher(for: urlRequest)
            .receive(on: DispatchQueue.main)
            .tryMap{ (data, response) -> Data in
                let res = response as? HTTPURLResponse
                print(res!.statusCode)
                guard let response = response as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode <= 300 else{
                    if res!.statusCode == 401{
                        self.api.logout()
                    }
                    else if res!.statusCode == 404{
                        print("not found")
                        self.loading = false
                       // self.fetched = true
                    }
                    throw URLError(.badServerResponse)
                }
                self.fetchingStudents = false
                print("response: \(response)")
                return data
            }
            .decode(type: ComakershipMembers.self, decoder: JSONDecoder())
            .sink { (completion) in
            } receiveValue: { (result) in
                self.comakershipMembers = result
                if result.students.count == 0{
                    self.hasMembers = false
                } else{
                    self.hasMembers = true
                }
                self.fetchingStudents = false
            }
            .store(in: &cancellables)
    }
    
    func startComakership(id: Int, name: String, description: String, credits: Bool, bonus: Bool, comakershipStatusId: Int,completion: @escaping (Result<Void, RequestError>) -> Void){
        loading = true
        let url = URL(string: api.apiUrl + "/comakerships/\(id)")!
        print("shit: Bearer\(api.accessToken!)")
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-type")
        urlRequest.setValue("Bearer \(api.accessToken!)", forHTTPHeaderField: "Authorization")
        urlRequest.httpMethod = "PUT"
        
        let parameters = EditComakership(
            id: id,
            name: name,
            description: description,
            credits: credits,
            bonus: bonus,
            comakershipStatusId: comakershipStatusId
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
                switch result {
                case .finished:
                    self.loading = false
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
                //print("completion: \(completion)")
                //print("response: \(response)")
                //completion(.success(response))
            })
            .store(in: &cancellables)
    }
}
