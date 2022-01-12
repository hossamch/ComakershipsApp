//
//  EditTeamVM.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 02/01/2022.
//

import Foundation
import Combine

final class EditTeamVM: ObservableObject{
    @Published var id: Int = 0
    @Published var name: String = ""
    @Published var description: String = ""
    @Published var members = [Member]()
    
    @Published var isLoading: Bool = false
    @Published var successful: Bool = false
    @Published var isAlerted: Bool = false
    @Published var left = false
    static var shared = EditTeamVM()
    
    private var api = API.shared
    private var cancellables = Set<AnyCancellable>()
    
    private init(){
        
    }
    
    static func renew(){
        self.shared = EditTeamVM()
    }
    
    var idPrompt: String{
        if Int(id) == nil{
            return "Please enter a valid ID number"
        }
        return ""
    }
    
    var namePrompt: String{
        if name != ""{
            return ""
        }
        return "Enter your team name please"
    }
    
    var descriptionPrompt: String{
        if description != ""{
            return ""
        }
        return "Enter your team description please"
    }
    
    var complete: Bool{
        if Int(id) == nil || name == "" || description == ""{
            return false
        }
        return true
    }
    
    func kickFromTeam(teamId: Int, studentId: Int){
        isLoading = true
        let url = URL(string: api.apiUrl + "/teams/\(teamId)/kick/\(studentId)")!
        var urlRequest = URLRequest(url: url)
        print("shit: Bearer \(api.accessToken!)")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-type")
        urlRequest.setValue("Bearer \(api.accessToken!)", forHTTPHeaderField: "Authorization")
        urlRequest.httpMethod = "POST"

        URLSession.shared.dataTaskPublisher(for: urlRequest)
            .receive(on: DispatchQueue.main)
            .tryMap{ (data, response) -> Data in
                guard let response = response as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode <= 300 else{
                    let res = response as? HTTPURLResponse
                    print(res!.statusCode)
                    throw URLError(.badServerResponse)
                }
                self.getTeamById(id: self.id)
                self.isLoading = false
                return data
            }
            .decode(type: TeamMembers.self, decoder: JSONDecoder())
            .sink { (completion) in
            } receiveValue: { (result) in
            }
            .store(in: &cancellables)
    }
    
    func leaveTeam(teamId: Int){
        isLoading = true
        let url = URL(string: api.apiUrl + "/teams/\(id)/leave")!
        var urlRequest = URLRequest(url: url)
        print("shit: Bearer \(api.accessToken!)")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-type")
        urlRequest.setValue("Bearer \(api.accessToken!)", forHTTPHeaderField: "Authorization")
        urlRequest.httpMethod = "POST"

        URLSession.shared.dataTaskPublisher(for: urlRequest)
            .receive(on: DispatchQueue.main)
            .tryMap{ (data, response) -> Data in
                guard let response = response as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode <= 300 else{
                    let res = response as? HTTPURLResponse
                    print(res!.statusCode)
                    throw URLError(.badServerResponse)
                }
                self.isLoading = false
                self.left = true
                return data
            }
            .decode(type: TeamMembers.self, decoder: JSONDecoder())
            .sink { (completion) in
            } receiveValue: { (result) in
            }
            .store(in: &cancellables)
    }
    
    func getTeamById(id: Int){
        isLoading = true
        let url = URL(string: api.apiUrl + "/teams/complete/\(id)")!
        var urlRequest = URLRequest(url: url)
        print("shit: Bearer \(api.accessToken!)")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-type")
        urlRequest.setValue("Bearer \(api.accessToken!)", forHTTPHeaderField: "Authorization")
        urlRequest.httpMethod = "GET"

        URLSession.shared.dataTaskPublisher(for: urlRequest)
            .receive(on: DispatchQueue.main)
            .tryMap{ (data, response) -> Data in
                guard let response = response as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode <= 300 else{
                    let res = response as? HTTPURLResponse
//                    if res!.statusCode == 404{
//                        self.notFound = true
//                        self.loadingTeamsById = false
//                    }
                    print(res!.statusCode)
                    throw URLError(.badServerResponse)
                }
                
                return data
            }
            .decode(type: TeamMembers.self, decoder: JSONDecoder())
            .sink { (completion) in
            } receiveValue: { (result) in
                self.id = result.id
                self.name = result.name
                self.description = result.description
                self.members = result.members
                self.isLoading = false
            }
            .store(in: &cancellables)
    }
    
    func editTeam(teamId: Int, completion: @escaping (Result<Void, RequestError>) -> Void){
        isLoading = true
        let url = URL(string: api.apiUrl + "/teams/\(teamId)")!
        print("shit: Bearer\(api.accessToken!)")
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-type")
        urlRequest.setValue("Bearer \(api.accessToken!)", forHTTPHeaderField: "Authorization")
        urlRequest.httpMethod = "PUT"
        
        let parameters = TeamBasic(
            id: teamId,
            name: name,
            description: description
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
//                self.isLoading = false
//                self.isAlerted = true
                print("response: \(response)")
                return data
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { (result) in
                switch result {
                case .finished:
                    print("result: \(result)")
                    self.successful = true
                    self.isLoading = false
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
                //print("completion: \(completion)")
                //print("response: \(response)")
                //completion(.success(response))
            })
            .store(in: &cancellables)
    }
}
