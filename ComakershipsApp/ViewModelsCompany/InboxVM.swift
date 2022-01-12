//
//  InboxVM.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 01/01/2022.
//

import Foundation
import Combine

final class InboxVM: ObservableObject{
    @Published var api = API.shared
    @Published var loading = false
    @Published var applications = [[TeamApplication]]()
    @Published var status = JoinRequestStatus.Default
    @Published var isAlerted = false
    @Published var comakershipvm = ComakershipVM.shared
    @Published var comakerships: [ComakershipCGet] = [ComakershipCGet]()
    static var shared = InboxVM()
    private var cancellables = Set<AnyCancellable>()
    
    private init(){
//        guard CompanyVM.shared.companyUser.company != nil else{return}
//        if CompanyVM.shared.companyUser.company!.name != ""{
//            getComakerships()
//        }
        // tijdens deze init is comakershipvm.comakerships nog leeg for some reaeson
    }
    
    static func renew(){
        self.shared = InboxVM()
    }
    
    func refresh(){
        applications = [[TeamApplication]]()
        getComakerships()
    }
    
    func getApplications(id: Int){
        if (!api.isAuthenticated){
            return
        }
        loading = true
        let url = URL(string: api.apiUrl + "/comakerships/\(id)/applications")!
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
            .decode(type: [TeamApplication].self, decoder: JSONDecoder())
            .sink { (completion) in
            } receiveValue: { (result) in
                if result.count != 0{
                  //  self.joinRequests.results.append(result)
                    self.applications.append(result)
                }
                self.loading = false
//                if self.joinRequests.results.count > 0{
//                    self.api.notification = true
//                }
            }
            .store(in: &cancellables)
    }
    
    func acceptApplication(comakershipId: Int, teamId: Int){
        loading = true
        status = JoinRequestStatus.Default
        let url = URL(string: api.apiUrl + "/comakerships/\(comakershipId)/acceptapplication/\(teamId)")!
        var urlRequest = URLRequest(url: url)
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
                let res = response as? HTTPURLResponse
                print(res!.statusCode)
                if res!.statusCode == 200{
                    self.status = JoinRequestStatus.Accepted
                    
                    self.isAlerted = true
                   // self.getAllNotifications()
                }
                self.loading = false
                return data
            }
            .decode(type: String.self, decoder: JSONDecoder())
            .sink { (completion) in
            } receiveValue: { (result) in
                self.refresh()
            }
            .store(in: &cancellables)
    }
    
    func rejectApplication(comakershipId: Int, teamId: Int){
        loading = true
        status = JoinRequestStatus.Default
        let url = URL(string: api.apiUrl + "/comakerships/\(comakershipId)/rejectapplication/\(teamId)")!
        var urlRequest = URLRequest(url: url)
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
                let res = response as? HTTPURLResponse
                print(res!.statusCode)
                if res!.statusCode == 200{
                    self.status = JoinRequestStatus.Rejected
                    
                    self.isAlerted = true
                   // self.getAllNotifications()
                }
                self.loading = false
                return data
            }
            .decode(type: String.self, decoder: JSONDecoder())
            .sink { (completion) in
            } receiveValue: { (result) in
                self.refresh()
            }
            .store(in: &cancellables)
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
                       // self.fetched = true
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
                //self.fetched = true
                for it in result{
                    self.getApplications(id: it.id)
                }
            }
            .store(in: &cancellables)
    }
}
