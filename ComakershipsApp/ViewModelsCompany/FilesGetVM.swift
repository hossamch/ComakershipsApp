//
//  FilesGetVM.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 07/01/2022.
//

import Foundation
import Combine

final class FilesGetVM: ObservableObject{
    private let api = API.shared
    @Published var student = Student()
    private var cancellables = Set<AnyCancellable>()
    @Published var loading = false
    @Published var isAlerted = false
    @Published var files = [Data]()
    @Published var hasFiles = false
    static var shared = FilesGetVM()
    
    private init(){
        //self.mimeType =
    }
    
    static func renew(){
        self.shared = FilesGetVM()
    }
    
    func getFiles(id: Int){
        loading = true
        let url = URL(string: api.apiUrl + "/comakerships/\(id)/files")!
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
                    } else if res!.statusCode == 400{
                        self.hasFiles = false
                    }
                    throw URLError(.badServerResponse)
                }
                self.loading = false
                return data
            }
            .decode(type: [Data].self, decoder: JSONDecoder())
            .sink { (completion) in
            } receiveValue: { (result) in
                self.files = result
                self.hasFiles = result.count > 0
                self.loading = false
            }
            .store(in: &cancellables)
    }
}
