//
//  CreateComakershipVM.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 29/12/2021.
//

import Foundation
import Combine

class CreateComakershipVM: ObservableObject{
    @Published var name: String = ""
    @Published var description: String = ""
    @Published var credits: Bool = false
    @Published var bonus: Bool = false
    @Published var deliverables: [Deliverable] = [Deliverable]()
    @Published var skills: [Skill] = [Skill]()
    @Published var programId: Int = 0
    @Published var purchaseKey: String = ""
    @Published var deliverable: String = ""
    @Published var skill: String = ""
    @Published var isAddingDeliverable: Bool = false
    @Published var isAddingSkill: Bool = false
    @Published var currentlySelectedProgram: Int? = nil
    @Published var isAlerted: Bool = false
    @Published var success: Bool = false
    @Published var programs = [Program]()
    @Published var api = API.shared
    @Published var loading = false
    @Published var finished = false
    static var shared = CreateComakershipVM()
    
    
    private var cancellables = Set<AnyCancellable>()
    
    private init(){
        getPrograms()
    }
    
    static func renew(){
        self.shared = CreateComakershipVM()
    }
    
    var partOneComplete: Bool{
        if  name == "" || description == "" || currentlySelectedProgram == nil || purchaseKey == ""{
            return false
        }
        return true
    }
    
    var partTwoComplete: Bool{
        if  deliverables.count == 0{
            return false
        }
        return true
    }
    
    var partThreeComplete: Bool{
        if  skills.count == 0{
            return false
        }
        return true
    }
    
    var namePrompt: String{
        if name != ""{
            return ""
        }
        return "Enter the name of your comakership."
    }
    
    
    var desciptionPrompt: String{
        if description != ""{
            return ""
        }
        return "Describe your comakership."
    }
    
    var purchaseKeyPrompt: String{
        if purchaseKey != ""{
            return ""
        }
        return "Enter your purchase key. Don't have it? Contact us to purchase a key."
    }
    
    var deliverablesPrompt: String{
        if deliverables.count == 0{
            return ""
        }
        return "Enter the deliverables/phases of your comakership."
    }
    
    var skillsPrompt: String{
        if skills.count == 0{
            return ""
        }
        return "Enter the desired skill(s) of your participants."
    }
    
    var programPrompt: String{
        if currentlySelectedProgram != nil{
            return ""
        }
        return "Select the program that your comakership applies to"
    }
    
    func addDeliverable(){
        if deliverable != "" {
            deliverables.append(Deliverable(name: deliverable))
            deliverable = ""
        }
        isAddingDeliverable = false
        deliverables.forEach{d in
            print(d.name)
        }
    }
    
    func removeDeliverables(){
        if deliverables.count > 0{
            deliverables.remove(at: deliverables.count-1)
        }
    }
    
    func addSkill(){
        if skill != "" {
            skills.append(Skill(name: skill))
            skill = ""
        }
        isAddingSkill = false
        skills.forEach{d in
            print(d.name)
        }
    }
    
    func removeSkills(){
        if skills.count > 0{
            skills.remove(at: skills.count-1)
        }
    }
    
    func getPrograms(){
        if !api.isAuthenticated{
            return
        }
        loading = true
        let url = URL(string: api.apiUrl + "/programs/")!
//        print("shit: Bearer\(api.accessToken!)")
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-type")
        //urlRequest.setValue("Bearer \(api.accessToken!)", forHTTPHeaderField: "Authorization")
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
                print("response: \(response)")
                return data
            }
            .decode(type: [Program].self, decoder: JSONDecoder())
            .sink { (completion) in
            } receiveValue: { (result) in
                self.programs = result
//                self.programs.insert(Program(name: "Program"), at: 0)
                self.loading = false
            }
            .store(in: &cancellables)
    }
    
    func createComakership(completion: @escaping (Result<Void, RequestError>) -> Void){
        loading = true
        success = false
        finished = false
        let url = URL(string: api.apiUrl + "/comakerships")!
        print("shit: Bearer\(api.accessToken!)")
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-type")
        urlRequest.setValue("Bearer \(api.accessToken!)", forHTTPHeaderField: "Authorization")
        urlRequest.httpMethod = "POST"
        
        let parameters = ComakershipCreate(
            name: name,
            description: description,
            credits: credits,
            bonus: bonus,
            deliverables: deliverables,
            skills: skills,
            programIds: [
                currentlySelectedProgram!
            ],
            purchaseKey: purchaseKey
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
                    throw URLError(.badServerResponse)
                    
                }
                print("response: \(response)")
                return data
            }
            //.decode(type: RegisterResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { (result) in
                switch result {
                case .finished:
                    self.loading = false
                    self.success = true
                    self.finished = true
                    self.isAlerted = true
                    print("result: \(result)")
                    completion(.success(()))
                    break
                case .failure(let error):
                    switch error {
                    case let urlError as URLError:
                        completion(.failure(.urlError(urlError)))
                    case let decodingError as DecodingError:
                        completion(.failure(.decodingError(decodingError)))
                    case let RequestError.invalidPurchaseKey:
                        self.isAlerted = true
                        self.finished = true
                        self.loading = false
                        completion(.failure(.invalidPurchaseKey))
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
