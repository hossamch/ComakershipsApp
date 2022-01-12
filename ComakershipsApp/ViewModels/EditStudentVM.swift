//
//  EditStudentVM.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 20/12/2021.
//

import Foundation
import Combine

final class EditStudentVM: ObservableObject{
    private var api = API.shared
    private var cancellables = Set<AnyCancellable>()
    @Published var name: String = StudentVM.shared.student.name
    @Published var about: String = ""
    @Published var links: [String?] = ["", ""]
    @Published var nickName: String = ""
    @Published var isLoading: Bool = false
    @Published var successful: Bool = false
    @Published var link: String = ""
    @Published var isAddingLink: Bool = false
    @Published var oldPassword = ""
    @Published var newPassword = ""
    @Published var confirmPass = ""
    @Published var wrongPass = false
    @Published var isAlerted =  false
    static var shared = EditStudentVM()
    
    private init(){
        getStudent()
    }
    
    static func renew(){
        self.shared = EditStudentVM()
    }
    
    var completeChangePass: Bool{
        if oldPassword != "" && validatePassword() && validatePassword2() || !validatePassFields{
            return true
        }
        return false
    }
    
    var validatePassFields: Bool{
        if oldPassword == "" && newPassword == "" && confirmPass == ""{
            return false
        }
        return true
    }
    
    var oldPassPrompt: String{
        if oldPassword == ""{
            return "Enter your current password."
        }
        return ""
    }
    
    var newPassPrompt: String{
        if validatePassword(){
            return ""
        }
        return "The password should start with a letter and must be between 4 and 15 characters long. Only letters numbers and underscores may be used."
    }
    
    var confirmPassPrompt: String{
        if validatePassword2(){
            return ""
        }
        return "The passwords do not match."
    }
    
    func validatePassword() -> Bool{
        //The password's first character must be a letter, it must contain at least 4 characters and no more than 15 characters and no characters other than letters, numbers and the underscore may be used
        let test = NSPredicate(format: "SELF MATCHES %@", "^[a-zA-Z]\\w{3,14}$")
        return test.evaluate(with: newPassword)
    }
    
    func validatePassword2() -> Bool{
        confirmPass == newPassword
    }
    
    
    
    
    
    
    
    
    var editComplete: Bool{
        if name == "" && about == "" && links == ["", ""] && nickName == ""{
            return false
        }
        return true
    }
    
    func addLink(){
        if !link.contains("http://"){
            link = "http://\(link)"
        }
        let test = NSPredicate(format: "SELF MATCHES %@", "^http\\://[a-zA-Z0-9\\-\\.]+\\.[a-zA-Z]{2,3}(/\\S*)?$")
        if test.evaluate(with: link){
            links.append(link)
            link = ""
        }
        link = ""
        isAddingLink = false
    }
    
    func removeLinks(){
        if links.count > 0{
            links.remove(at: links.count-1)
        }
    }
    
    func changePassword(completion: @escaping (Result<Void, RequestError>) -> Void){
        if !validatePassFields{return}
        successful = false
        wrongPass = false
        isLoading = true
        let url = URL(string: api.apiUrl + "/User/ChangePassword")!
        print("shit: Bearer\(api.accessToken!)")
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-type")
        urlRequest.setValue("Bearer \(api.accessToken!)", forHTTPHeaderField: "Authorization")
        urlRequest.httpMethod = "POST"
        
        let parameters = ChangePassword(
            oldPassword: self.oldPassword,
            newPassword: self.newPassword,
            confirmNewPassword: self.confirmPass
        )
        
        let encoder = JSONEncoder()
        guard let body = try? encoder.encode(parameters) else {return}
        urlRequest.httpBody = body
        
        URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap{ (data, response) -> Data in
                guard let response = response as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode <= 300 else{
                    let res = response as? HTTPURLResponse
                    print(res!.statusCode)
                    if res!.statusCode == 401{
                        self.api.logout()
                    } else if res!.statusCode == 400{
                        self.wrongPass = true
                        
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
                    print("result: \(result)")
                    self.successful = true
                    self.isAlerted = true
                    self.isLoading = false
                    break
                case .failure(let error):
                    switch error {
                    case let urlError as URLError:
                        self.isAlerted = false
                        completion(.failure(.urlError(urlError)))
                    case let decodingError as DecodingError:
                        completion(.failure(.decodingError(decodingError)))
                    default:
                        completion(.failure(.genericError(error)))
                    }
                }
            }, receiveValue: { (response)  in
   
            })
            .store(in: &cancellables)
    }
    
    func getStudent(){
        if !api.isAuthenticated{
            return
        }
        isLoading = true
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
                self.isLoading = false
                return data
            }
            .decode(type: StudentToEdit.self, decoder: JSONDecoder())
            .sink { (completion) in
            } receiveValue: { (result) in
                self.name = result.name
                self.nickName = (result.nickname != nil) ? result.nickname! : ""
                self.about = (result.about != nil) ? result.about! : ""
                self.links = result.links
                self.isLoading = false
            }
            .store(in: &cancellables)
    }
    
    func editStudent(completion: @escaping (Result<Void, RequestError>) -> Void){
        isLoading = true
        wrongPass = false
        successful = false
        let url = URL(string: api.apiUrl + "/Students")!
        print("shit: Bearer\(api.accessToken!)")
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-type")
        urlRequest.setValue("Bearer \(api.accessToken!)", forHTTPHeaderField: "Authorization")
        urlRequest.httpMethod = "PUT"
        
        let parameters = StudentToEdit(
            name: name,
            about: about,
            links: links,
            nickname: nickName
        )
        
        let encoder = JSONEncoder()
        guard let body = try? encoder.encode(parameters) else {return}
        urlRequest.httpBody = body
        
        URLSession.shared.dataTaskPublisher(for: urlRequest)
            .map{$0.data}
            //.decode(type: RegisterResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { (result) in
                switch result {
                case .finished:
                    print("result: \(result)")
                    self.successful = true
                    self.isAlerted = true
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
                completion(.success(response))
            })
            .store(in: &cancellables)
    }
}
