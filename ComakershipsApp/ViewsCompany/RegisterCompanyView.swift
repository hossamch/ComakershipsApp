//
//  CompanyView.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 24/12/2021.
//

import SwiftUI

struct RegisterCompanyView: View {
    @ObservedObject var api = API.shared
    @ObservedObject var viewModel = CompanyRegVM.shared
    
    @State var isLoggingin: Bool = false
    @State var errorDescription: String = ""
    @State var isRequestErrorViewPresented: Bool = false
    @State var successful: Bool = false;
    @State var successfulUser = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack{
            TopRect()
            VStack{
                if (isLoggingin){
                    MidProgressView()
                }
                else{
                    ScrollView{
                        Text("* If you want to join an existing company, leave the company fields empty.")
                            .font(.caption)
                        Group{
                            Text("Company")
                            EntryField(symbolName: "info", placeHolder: "Company name", field: $viewModel.companyName, prompt: viewModel.companyNamePrompt)
                            EntryField(symbolName: "info", placeHolder: "Description", field: $viewModel.description, prompt: viewModel.desciptionPrompt)
                            EntryField(symbolName: "info", placeHolder: "Street", field: $viewModel.street, prompt: viewModel.streetPrompt)
                            EntryField(symbolName: "info", placeHolder: "City", field: $viewModel.city, prompt: viewModel.cityPrompt)
                            EntryField(symbolName: "info", placeHolder: "Zipcode", field: $viewModel.zipcode, prompt: viewModel.zipcodePrompt)
                        }
                        Group{
                            Text("Your information")
                                .padding(.top)
                            EntryField(symbolName: "exclamationmark.circle", placeHolder: "Name", field: $viewModel.fullname, prompt: viewModel.namePrompt)
                            EntryField(symbolName: "exclamationmark.circle", placeHolder: "Email", field: $viewModel.email, isEmail: true, prompt: viewModel.emailPrompt)
                            EntryField(symbolName: "exclamationmark.circle", placeHolder: "Password", field: $viewModel.password,isSecure: true,  prompt: viewModel.passwordPrompt)
                            EntryField(symbolName: "exclamationmark.circle", placeHolder: "Confirm password", field: $viewModel.confirmPass, isSecure: true, prompt: viewModel.confirmPassPrompt)
                        }
                    }
                    .animation(.easeInOut)
                    .frame(minHeight: 600)
                    
                    Button(action: {
                        if viewModel.signUpCompleteForCompany{
                            isLoggingin = true
                            API.shared.createCompany(name: viewModel.companyName, description: viewModel.description, street: viewModel.street, city: viewModel.city, zipcode: viewModel.zipcode, username: viewModel.fullname, email: viewModel.email, password: viewModel.password){ (result) in
                                switch result {
                                case .success(_):
                                    print("result: \(result)")
                                    self.isRequestErrorViewPresented = true
                                    self.successful = true
                                    self.presentationMode.wrappedValue.dismiss()
                                case .failure(let error):
                                    switch error {
                                    case .urlError(_):
                                        errorDescription = "URL Error"
                                    case .decodingError(_):
                                        errorDescription = "DecodingError"
                                    case .genericError(_):
                                        errorDescription = "GenericError"
                                    case .invalidPurchaseKey:
                                        errorDescription = "URL Error"
                                    }
                                    
                                    self.isRequestErrorViewPresented = true
                                }
                                isLoggingin = false
                            }
                        } else{
                            isLoggingin = true
                            API.shared.registerCompanyUser(name: viewModel.fullname, email: viewModel.email, password: viewModel.password){ (result) in
                                switch result {
                                case .success(_):
                                    print("result: \(result)")
                                    self.isRequestErrorViewPresented = true
                                    self.successfulUser = true
                                    self.presentationMode.wrappedValue.dismiss()
                                case .failure(let error):
                                    switch error {
                                    case .urlError(_):
                                        errorDescription = "URL Error"
                                    case .decodingError(_):
                                        errorDescription = "DecodingError"
                                    case .genericError(_):
                                        errorDescription = "GenericError"
                                    case .invalidPurchaseKey:
                                        errorDescription = "URL Error"
                                    }
                                    
                                    self.isRequestErrorViewPresented = true
                                }
                                isLoggingin = false
                            }
                        }
                    }, label: {
                        Text("Register")
                            .frame(maxWidth: .infinity, minHeight: 50)
                            .foregroundColor(.white)
                            .background(Image("buttonbg"))
                            .cornerRadius(9.0)
                            .opacity(viewModel.signUpCompleteForCompany || viewModel.signUpCompleteForCompanyUser ? 1 : 0.5)
                    })
                        .disabled(!viewModel.signUpCompleteForCompany && !viewModel.signUpCompleteForCompanyUser)
                }
                
            }
            .navigationBarTitle("Register your company", displayMode: .inline)
            .padding()
            
        }
        .alert(isPresented: $isRequestErrorViewPresented){
            if successful{
                return Alert(title: Text("Success"), message: Text("Company successfully registered!"), dismissButton: .default(Text("OK")))
            } else if successfulUser{
                return Alert(title: Text("Success"), message: Text("Company User successfully registered!"), dismissButton: .default(Text("OK")))
            }
            return Alert(title: Text("Error"), message: Text(errorDescription), dismissButton: .default(Text("OK")))
        }
        //.navigationBarBackButtonHidden(true)
    }
}

struct RegisterCompanyView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterCompanyView()
    }
}
