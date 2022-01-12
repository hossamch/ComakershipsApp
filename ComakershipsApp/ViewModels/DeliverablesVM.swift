//
//  DeliverablesVM.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 07/01/2022.
//

import Foundation
import Combine
import SwiftUI

final class DeliverablesVM: ObservableObject{
    @Published var deliverables = [Assignment]()
    @Published var loading = false
    private var api = API.shared
    private var cancellables = Set<AnyCancellable>()
    static var shared = DeliverablesVM()
    
    private init(){}
    
    static func renew(){
        self.shared = DeliverablesVM()
    }
    
    var progress: CGFloat{
        get{
            var i: CGFloat = 0
            for ass in deliverables{
                if ass.finished{i+=1}
            }
            return i / CGFloat(deliverables.count)
        }
        set(value){
        
        }
    }
    
    func finishAssignment(deliverable: Assignment, comakershipId: Int){
        loading = true
        deliverables[deliverables.firstIndex(where: {$0.id == deliverable.id})!].finished = true
        let url = URL(string: api.apiUrl + "/deliverables/\(deliverable.id)")!
        print("shit: Bearer\(api.accessToken!)")
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-type")
        urlRequest.setValue("Bearer \(api.accessToken!)", forHTTPHeaderField: "Authorization")
        urlRequest.httpMethod = "PUT"
        
        let parameters = Assignment(
            id: deliverable.id,
            name: deliverable.name,
            finished: true
        )
        
        let encoder = JSONEncoder()
        guard let body = try? encoder.encode(parameters) else {return}
        urlRequest.httpBody = body
        
        URLSession.shared.dataTaskPublisher(for: urlRequest)
            .map{$0.data}
            //.decode(type: RegisterResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { (result) in
        

            }, receiveValue: { (response)  in
                //wordt gexexcute
                self.loading = false
            })
            .store(in: &cancellables)
    }
    
    func unfinishAssignment(deliverable: Assignment, comakershipId: Int){
        loading = true
        deliverables[deliverables.firstIndex(where: {$0.id == deliverable.id})!].finished = false
        let url = URL(string: api.apiUrl + "/deliverables/\(deliverable.id)")!
        print("shit: Bearer\(api.accessToken!)")
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-type")
        urlRequest.setValue("Bearer \(api.accessToken!)", forHTTPHeaderField: "Authorization")
        urlRequest.httpMethod = "PUT"
        
        let parameters = Assignment(
            id: deliverable.id,
            name: deliverable.name,
            finished: false
        )
        
        let encoder = JSONEncoder()
        guard let body = try? encoder.encode(parameters) else {return}
        urlRequest.httpBody = body
        
        URLSession.shared.dataTaskPublisher(for: urlRequest)
            .map{$0.data}
            //.decode(type: RegisterResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { (result) in
        

            }, receiveValue: { (response)  in
                //wordt gexexcute
                self.loading = false
            })
            .store(in: &cancellables)
    }
    
    func getDeliverables(id: Int){
        loading = true
        let url = URL(string: api.apiUrl + "/comakerships/\(id)/deliverables")!
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
                return data
            }
            .decode(type: [Assignment].self, decoder: JSONDecoder())
            .sink { (completion) in
            } receiveValue: { (result) in
                if result.count != 0{
                    self.deliverables = result
                }
                self.loading = false
            }
            .store(in: &cancellables)
    }
}
