//
//  TeamsVM.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 20/12/2021.
//

import Foundation
import Combine

final class TeamsVM: ObservableObject{
    @Published var api = API.shared
    @Published var teams = [TeamResponse]()
    @Published var myTeams = [LinkedTeam]()
    @Published var myJoinRequests = [Int]()
    @Published var teamById: TeamResponse? = nil
    @Published var name: String = ""
    @Published var description: String = ""
    @Published var teamIdField: String = ""
    @Published var loading = false
    @Published var loadingMyTeams = false
    @Published var loadingCreate = false
    @Published var success = false
    @Published var loadingTeamsById: Bool = false
    @Published var fetchedTeamById: Bool = false
    @Published var notFound = false
    @Published var edited = false
    
    @Published var loadingJoin = false
    @Published var requestStatus = RequestStatus.Default
    @Published var isAlerted = false
    @Published var loadingEdit = false
    static var shared = TeamsVM()
    
    
    private var cancellables = Set<AnyCancellable>()
    
    private init(){
//        if (api.isAuthenticated){
//            getAllTeams()
//            getMyTeams()
//            getMyJoinRequests()
//        }
    }
    
    static func renew(){
        self.shared = TeamsVM()
    }
    
    var teamId: Int?{
        if (Int(teamIdField) != nil){
            return Int(teamIdField)
        }
        return nil
    }
    var searchIdComplete: Bool{
        if teamId == nil{
            return false
        }
        return true
    }
    
    var complete: Bool{
        if name == "" || description == ""{
            return false
        }
        return true
    }
    
    var namePrompt: String{
        if name == ""{
            return "Please enter a team name"
        }
        return ""
    }
    
    var descriptionPrompt: String{
        if description == ""{
            return "Please enter a team description"
        }
        return ""
    }
    
    var teamIdPrompt: String{
        if teamId == nil{
            return "Please enter the team ID."
        }
        return ""
    }
    
//    func getMyTeams(){
//        teams.forEach{it in
//            if it.name == api.userFullName{
//                myTeams.append(it)
//            }
//        }
//    }
    
    func getMyJoinRequests(){
        loading = true
        let url = URL(string: api.apiUrl + "/student/joinrequests")!
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
                    throw URLError(.badServerResponse)
                }
                let res = response as? HTTPURLResponse
                print(res!.statusCode)
                self.loading = false
                return data
            }
            .decode(type: [MyJoinQuery].self, decoder: JSONDecoder())
            .sink { (completion) in
            } receiveValue: { (result) in
                result.forEach{it in
                    self.myJoinRequests.append(it.teamId)
                }
                self.loading = false
            }
            .store(in: &cancellables)
    }
    
    func getTeamById(){
        loadingTeamsById = true
        fetchedTeamById = false
        let url = URL(string: api.apiUrl + "/teams/\(teamId!)")!
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
                    if res!.statusCode == 404{
                        self.notFound = true
                        self.loadingTeamsById = false
                    }
                    print(res!.statusCode)
                    throw URLError(.badServerResponse)
                }
                
                return data
            }
            .decode(type: TeamResponse.self, decoder: JSONDecoder())
            .sink { (completion) in
            } receiveValue: { (result) in
                self.teamById = result
                self.loadingTeamsById = false
                self.fetchedTeamById = true
            }
            .store(in: &cancellables)
    }
    
    func createTeam(completion: @escaping (Result<Void, RequestError>) -> Void){
        loadingCreate = true
        success = false
        let url = URL(string: api.apiUrl + "/teams")!
        print("shit: Bearer \(api.accessToken!)")
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-type")
        urlRequest.setValue("Bearer \(api.accessToken!)", forHTTPHeaderField: "Authorization")
        urlRequest.httpMethod = "POST"
        
        let parameters = TeamPost(
            name: name,
            description: description
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
                    self.loadingCreate = false
                    throw URLError(.badServerResponse)
                }
                print("response: \(response)")
                return data
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { (result) in
                switch result {
                case .finished:
                    print("result: \(result)")
                    self.success = true
                    self.loadingCreate = false
                    self.getMyTeams()
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
    
    
    func getAllTeams(){
        loading = true
        let url = URL(string: api.apiUrl + "/teams")!
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
                    print(res!.statusCode)
                    throw URLError(.badServerResponse)
                }
                self.loading = false
                return data
            }
            .decode(type: [TeamResponse].self, decoder: JSONDecoder())
            .sink { (completion) in
            } receiveValue: { (result) in
                self.teams = result
                self.loading = false
            }
            .store(in: &cancellables)
    }
    
    func getAllTeamsExceptMine(){
        teams.forEach{it in
            myTeams.forEach{myIt in
                if myIt.teamId == it.id{
                    teams.removeAll{$0 == it}
                }
            }
        }
    }
    
    func getMyTeams(){
        loadingMyTeams = true
        let url = URL(string: api.apiUrl + "/Students/\(api.userId!)")!
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
                    throw URLError(.badServerResponse)
                }
//                let res = response as? HTTPURLResponse
//                print(res!.statusCode)
                self.loadingMyTeams = false
                return data
            }
            .decode(type: TeamGet.self, decoder: JSONDecoder())
            .sink { (completion) in
            } receiveValue: { (result) in
                self.myTeams = result.linkedTeams
                self.loadingMyTeams = false
            }
            .store(in: &cancellables)
    }
    
    func cancelJoinRequest(id: Int, completion: @escaping (Result<Void, RequestError>) -> Void){
        loadingJoin = true
        requestStatus = RequestStatus.Default
        let url = URL(string: api.apiUrl + "/teams/\(id)/join")!
        print("shit: Bearer \(api.accessToken!)")
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-type")
        urlRequest.setValue("Bearer \(api.accessToken!)", forHTTPHeaderField: "Authorization")
        urlRequest.httpMethod = "DELETE"
        
        URLSession.shared.dataTaskPublisher(for: urlRequest)
            //.map{$0.data}
            .tryMap{ (data, response) -> Data in
                guard let response = response as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode <= 300 else{
                    let res = response as? HTTPURLResponse
                    print(res!.statusCode)
                    if res!.statusCode == 422{
                        throw RequestError.invalidPurchaseKey
                    }
                    self.loadingJoin = false
                    throw URLError(.badServerResponse)
                }
                print("response: \(response)")
                return data
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { (result) in
                switch result {
                case .finished:
                    print("result: \(result)")
                    self.requestStatus = RequestStatus.Canceled
                    self.loadingJoin = false
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
                while self.myJoinRequests.contains(id){
                    if let index = self.myJoinRequests.index(of: id) {
                        self.myJoinRequests.remove(at: index)
                    }
                }
            })
            .store(in: &cancellables)
    }
    
    func joinTeam(id: Int, completion: @escaping (Result<Void, RequestError>) -> Void){
        loadingJoin = true
        requestStatus = RequestStatus.Default
        let url = URL(string: api.apiUrl + "/teams/\(id)/join")!
        print("shit: Bearer \(api.accessToken!)")
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-type")
        urlRequest.setValue("Bearer \(api.accessToken!)", forHTTPHeaderField: "Authorization")
        urlRequest.httpMethod = "POST"
        
        URLSession.shared.dataTaskPublisher(for: urlRequest)
            //.map{$0.data}
            .tryMap{ (data, response) -> Data in
                guard let response = response as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode <= 300 else{
                    let res = response as? HTTPURLResponse
                    print(res!.statusCode)
                    if res!.statusCode == 422{
                        throw RequestError.invalidPurchaseKey
                    }
                    self.loadingJoin = false
                    throw URLError(.badServerResponse)
                }
                print("response: \(response)")
                return data
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { (result) in
                switch result {
                case .finished:
                    print("result: \(result)")
                    self.requestStatus = RequestStatus.Joined
                    self.loadingJoin = false
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
                self.myJoinRequests.append(id)
            })
            .store(in: &cancellables)
    }
}

enum RequestStatus{
    case Joined
    case Canceled
    case Default
}
