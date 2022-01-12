//
//  InboxTeamsVM.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 01/01/2022.
//

import Foundation
import Combine
import UserNotifications

final class InboxTeamsVM: ObservableObject{
    @Published var api = API.shared
    @Published var loading = false
    @Published var myTeams = [LinkedTeam]()
    @Published var joinRequests = JoinModel()
    @Published var status = JoinRequestStatus.Default
    @Published var isAlerted = false
    static var shared = InboxTeamsVM()
    
    private var cancellables = Set<AnyCancellable>()
    
    private init(){
        //getAllNotifications()
    }
    
    static func renew(){
        self.shared = InboxTeamsVM()
    }
    
    func getAllNotifications(){
        joinRequests = JoinModel()
        getMyTeams()
    }
    // voor ez testen meerdere notificatins
//    func refresh(){
//        self.myTeams.forEach{it in
//            self.getJoinRequestsStudents(id: it.teamId)
//        }
//    }
    
    func notifyEmpty(){
        status = JoinRequestStatus.Empty
        isAlerted = true
    }
    
    func checkIfEmpty(){
        //await Task.sleep(nanoseconds: 500)
        //sleep(10)
      //  DispatchQueue.main.async {
            self.refresh()
        //}
        
        if self.joinRequests.results.count == 0{
            self.notifyEmpty()
        }
    }
    
    func refresh(){
        joinRequests = JoinModel()
        for team in self.myTeams{
            self.getJoinRequestsStudents(id: team.teamId)
        }
    }
    
    func getMyTeams(){
        if !api.isAuthenticated{
            return
        }
        loading = true
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
                self.loading = false
                return data
            }
            .decode(type: TeamGet.self, decoder: JSONDecoder())
            .sink { (completion) in
            } receiveValue: { (result) in
                self.myTeams = result.linkedTeams
                self.myTeams.forEach{it in
                    self.getJoinRequestsStudents(id: it.teamId)
                }
                self.loading = false
            }
            .store(in: &cancellables)
    }
    
    func getJoinRequestsStudents(id: Int){
        if (!api.isAuthenticated){
            return
        }
        loading = true
        let url = URL(string: api.apiUrl + "/teams/\(id)/joinrequests")!
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
            .decode(type: [JoinQuery].self, decoder: JSONDecoder())
            .sink { (completion) in
            } receiveValue: { (result) in
                if result.count != 0{
                    self.joinRequests.results.append(result)
                }
                for joinreq in result{
                    let notification = UNMutableNotificationContent()
                    notification.title = "Join Request"
                    notification.subtitle = "\(joinreq.studentUser.name) wants to join \(joinreq.team.name)"
                    notification.sound = UNNotificationSound.default
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                    
                    let request = UNNotificationRequest(identifier: UUID().uuidString, content: notification, trigger: trigger)
                    UNUserNotificationCenter.current().add(request)
                }
                
                self.loading = false
                if self.joinRequests.results.count > 0{
                    self.api.notification = true
                }
            }
            .store(in: &cancellables)
    }
    
    func acceptJoinRequest(teamId: Int, studentId: Int){
        loading = true
        let url = URL(string: api.apiUrl + "/teams/\(teamId)/joinrequests/\(studentId)")!
        print("shit: Bearer\(api.accessToken!)")
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
                    self.getAllNotifications()
                }
                self.loading = false
                return data
            }
            .decode(type: String.self, decoder: JSONDecoder())
            .sink { (completion) in
            } receiveValue: { (result) in
            }
            .store(in: &cancellables)
    }
    
    func denyJoinRequest(teamId: Int, studentId: Int){
        loading = true
        let url = URL(string: api.apiUrl + "/teams/\(teamId)/joinrequests/\(studentId)")!
        print("shit: Bearer\(api.accessToken!)")
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-type")
        urlRequest.setValue("Bearer \(api.accessToken!)", forHTTPHeaderField: "Authorization")
        urlRequest.httpMethod = "DELETE"

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
                    self.getAllNotifications()
                }
                self.loading = false
                return data
            }
            .decode(type: String.self, decoder: JSONDecoder())
            .sink { (completion) in
            } receiveValue: { (result) in
                
            }
            .store(in: &cancellables)
    }
}

enum JoinRequestStatus{
    case Default
    case Accepted
    case Rejected
    case Empty
}
