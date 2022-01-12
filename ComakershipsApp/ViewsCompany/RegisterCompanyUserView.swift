//
//  RegisterCompanyView.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 22/12/2021.
//

import SwiftUI

struct RegisterCompanyUserView: View {
    @ObservedObject var api = API.shared
    @ObservedObject var viewModel = RegisterCompanyVM.shared
    @State var isLoggingin: Bool = false
    @State var errorDescription: String = ""
    @State var isRequestErrorViewPresented: Bool = false
    @State var successful: Bool = false;
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        NavigationView{
            VStack{
                if (isLoggingin){
                    ProgressView("Processing...")
                }
                else if (successful){
                    Text("Account successfully created!")
                }
                else{
                    
                    EntryField(symbolName: "info", placeHolder: "Enter your name", field: $viewModel.name, prompt: viewModel.namePrompt)
                    EntryField(symbolName: "info", placeHolder: "Enter Your Email", field: $viewModel.email, isEmail: true, prompt: viewModel.emailPrompt)
                    EntryField(symbolName: "info", placeHolder: "Enter your password", field: $viewModel.password, isSecure: true, prompt: viewModel.passwordPrompt)
                    EntryField(symbolName: "info", placeHolder: "Confirm password", field: $viewModel.confirmPass, isSecure: true, prompt: viewModel.confirmPassPrompt)
                    Button(action: {
                        isLoggingin = true
                        API.shared.registerCompanyUser(name: viewModel.name, email: viewModel.email, password: viewModel.password){ (result) in
                            switch result {
                            case .success(_):
                                print("result: \(result)")
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
                                    errorDescription = "URL ERROR"
                                }
                                
                                self.isRequestErrorViewPresented = true
                            }
                            isLoggingin = false
                        }
                        
                    }, label: {
                        Text("Register")
                            .frame(maxWidth: .infinity, minHeight: 50)
                            .foregroundColor(.white)
                            .background(Image("buttonbg"))
                            .cornerRadius(9.0)
                            .opacity(viewModel.signUpComplete ? 1 : 0.5)
                    })
                        .disabled(!viewModel.signUpComplete)
                }
                
            }.alert(isPresented: $isRequestErrorViewPresented){
                Alert(title: Text("Error"), message: Text(errorDescription), dismissButton: .default(Text("OK")))
            }.alert(isPresented: $successful){
                Alert(title: Text("Success"), message: Text("Account successfully created!"), dismissButton: .default(Text("OK")))
            }
            .navigationBarTitle("Register as Client", displayMode: .inline)
            .padding()
            
        }
        //.navigationBarBackButtonHidden(true)
    }
}

struct RegisterCompanyUserView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterCompanyUserView()
    }
}
