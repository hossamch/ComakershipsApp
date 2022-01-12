//
//  StudentVM.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 02/01/2021.
//

import Foundation
import Combine

class StudentVM: ObservableObject{
    private let api = API.shared
    @Published var student = Student()
    private var cancellables = Set<AnyCancellable>()
    @Published var loading = false
    static var shared = StudentVM()
    
    private init(){
        getStudent()
    }
    
    static func renew(){
        self.shared = StudentVM()
    }
    
    func getStudent(){
        if !api.isAuthenticated{return}
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
                    if res!.statusCode == 401{
                        self.api.logout()
                    }
                    throw URLError(.badServerResponse)
                }
                self.loading = false
                return data
            }
            .decode(type: Student.self, decoder: JSONDecoder())
            .sink { (completion) in
            } receiveValue: { (result) in
                self.student = result
                self.api.userFullName = result.name
                self.loading = false
            }
            .store(in: &cancellables)
    }
}
