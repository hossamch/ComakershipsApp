//
//  ComakershipVM.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 12/12/2020.
//

import Foundation
import Combine

class ComakershipGetVM: ObservableObject{
    private let api = API.shared
    @Published var comakerships = [ComakershipSearch]()
    @Published var loading = false
    @Published var fetched = false
    @Published var skill: String = ""
    @Published var prompt: String = ""
    static var shared = ComakershipGetVM()
    
    var cancellable: AnyCancellable?
    private var cancellables = Set<AnyCancellable>()
    
    private init(){}
    
    static func renew(){
        self.shared = ComakershipGetVM()
    }
    
    func getComakershipBySkill(){
        comakerships.removeAll()
        if !api.isAuthenticated{
            return
        }
        if skill == ""{
            self.prompt = "Please enter a skill to base your search off."
            return
        }
        loading = true
        let url = URL(string: api.apiUrl + "/comakerships/search?Skill=\(skill)")!
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
                        self.fetched = true
                    }
                    throw URLError(.badServerResponse)
                }
                self.loading = false
                print("response: \(response)")
                return data
            }
            .decode(type: [ComakershipSearch].self, decoder: JSONDecoder())
            .sink { (completion) in
            } receiveValue: { (result) in
                self.comakerships = result
                self.fetched = true
            }
            .store(in: &cancellables)
    }
    
//    func getComakerships(){
//        api.getComakerships{
//            (result) in
//            switch result{
//            case .success(let response):
//                self.comakerships = response.comakerships
//            case .failure(let error):
//                print(error)
//            }
//        }
//    }
    
}
