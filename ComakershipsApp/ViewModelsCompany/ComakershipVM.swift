//
//  ComakershipVM.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 31/12/2021.
//

import Foundation
import Combine

final class ComakershipVM: ObservableObject{
    @Published var comakerships: [ComakershipCGet] = [ComakershipCGet]()
    @Published var api = API.shared
    @Published var loading = false
    @Published var fetched = false
    @Published var countNotStarted = 0
    @Published var countStarted = 0
    @Published var countFinished = 0
    private let companyvm = CompanyVM.shared
    var defaultcase = false
    
    static var shared = ComakershipVM()
    private var cancellables = Set<AnyCancellable>()
    
    private init(){
//        if companyvm.companyUser.company != nil && companyvm.companyUser.company!.name != ""{
//            getComakerships()
//        }
    }
    
    static func renew(){
        self.shared = ComakershipVM()
    }
    
    func getStatCounts(){
        countStarted = 0
        countNotStarted = 0
        countFinished = 0
        for comakership in self.comakerships{
            switch comakership.status!.name{
            case "Not started":
                countNotStarted += 1
            case "Started":
                countStarted += 1
            case "Finished":
                countFinished += 1
            default:
                defaultcase = true
            }
        }
    }
    
    func getComakerships(){
        if !api.isAuthenticated{
            return
        }
        loading = true
        let url = URL(string: api.apiUrl + "/comakerships/loggedinuser/all")!
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
            .decode(type: [ComakershipCGet].self, decoder: JSONDecoder())
            .sink { (completion) in
            } receiveValue: { (result) in
                self.comakerships = result
                self.getStatCounts()
                self.fetched = true
            }
            .store(in: &cancellables)
    }
}
