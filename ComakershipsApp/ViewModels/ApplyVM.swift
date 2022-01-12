//
//  ApplyVM.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 01/01/2022.
//

import Foundation
import Combine

final class ApplyVM: ObservableObject{
    @Published var api = API.shared
    @Published var teamsvm = TeamsVM.shared
    //@Published var applications = [[ApplicationsForTeam]]()
    @Published var appl = [[ApplicationsForTeam]]()
    @Published var loading = false
    @Published var isAlerted = false
    @Published var status = ApplyStatus.Default
    @Published var requested = false
    private var cancellables = Set<AnyCancellable>()
    @Published var currentlySelectedTeam: Int? = nil
    static var shared = ApplyVM()
    
//    class var applyVMManager: ApplyVM{
//
//    }
    
    
    private init(){
        for team in teamsvm.myTeams{
            getMyTeamApplications(teamId: team.teamId)
        }
    }
//    public func reInstance(){
//        shared = ApplyVM()
//    }
    
    static func renew(){
        self.shared = ApplyVM()
    }
    
    func refresh(){
        self.currentlySelectedTeam = nil
        self.appl.removeAll()
        for team in self.teamsvm.myTeams{
            self.getMyTeamApplications(teamId: team.teamId)
        }
    }
    
    var currentIndex: Int?{
        if currentlySelectedTeam != nil{
            return teamsvm.myTeams.firstIndex{$0.teamId == currentlySelectedTeam!}
        }
        return nil
    }
    
    var teamPrompt: String{
        if currentlySelectedTeam == nil{
            return "Please select a team to apply to this comakership with."
        }
        return ""
    }
    
    var complete: Bool{
        if currentlySelectedTeam != nil{
            return true
        }
        return false
    }
    
    func getMyTeamApplications(teamId: Int){
        loading = true
        let url = URL(string: api.apiUrl + "/teams/\(teamId)/applications")!
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
            .decode(type: [ApplicationsForTeam].self, decoder: JSONDecoder())
            .sink { (completion) in
            } receiveValue: { (result) in
//                result.forEach{it in
//
//                }
                if result.count != 0{
                    self.appl.append(result)
                }
                self.loading = false
            }
            .store(in: &cancellables)
    }

    
    func applyForComakership(comakershipId: Int, completion: @escaping (Result<Void, RequestError>) -> Void){
        loading = true
        let url = URL(string: api.apiUrl + "/teams/\(currentlySelectedTeam!)/applyforcomakership/\(comakershipId)")!
        currentlySelectedTeam = nil
        print("shit: Bearer\(api.accessToken!)")
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
                    if res!.statusCode == 401{
                        self.api.logout()
                    }
                    throw URLError(.badServerResponse)
                    
                }
                print("response: \(response)")
                return data
            }
            .decode(type: String.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { (result) in
                switch result {
                case .finished:
                    self.loading = false
                    self.isAlerted = true
                    self.refresh()
                    self.status = ApplyStatus.Applied
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
                print("canceled")
            })
            .store(in: &cancellables)
    }
    
    func cancelApplicationForComakership(comakershipId: Int, completion: @escaping (Result<Void, RequestError>) -> Void){
        loading = true
        let url = URL(string: api.apiUrl + "/teams/\(currentlySelectedTeam!)/applyforcomakership/\(comakershipId)")!
        currentlySelectedTeam = nil
        print("shit: Bearer\(api.accessToken!)")
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
                    if res!.statusCode == 401{
                        self.api.logout()
                    }
                    throw URLError(.badServerResponse)
                    
                }
                print("response: \(response)")
                return data
            }
            .decode(type: String.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { (result) in
                switch result {
                case .finished:
                    self.loading = false
                    self.isAlerted = true
                    self.refresh()
                    self.status = ApplyStatus.Canceled
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
                print("canceled")
            })
            .store(in: &cancellables)
    }
}

enum ApplyStatus{
    case Default
    case Applied
    case Canceled
}
