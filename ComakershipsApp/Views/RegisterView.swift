//
//  RegisterView.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 11/12/2020.
//

import SwiftUI

struct RegisterView: View {
    @ObservedObject var api = API.shared
    @ObservedObject var viewModel = RegisterVM.shared
    
    @State var isLoggingin: Bool = false
    @State var errorDescription: String = ""
    @State var isRequestErrorViewPresented: Bool = false
    @State var successful: Bool = false;
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack{
                TopRect()
            VStack{
                if (isLoggingin){
                    ProgressView("Processing...")
                        .position(x: UIScreen.main.bounds.width/2, y: 0)
                }
                else if (successful){
                    Text("Account successfully created!")
                }
                else{
                    VStack{
                        Text("Your information")
                        EntryField(symbolName: "exclamationmark.circle", placeHolder: "Enter First name", field: $viewModel.firstName, prompt: viewModel.firstNamePrompt)
                        EntryField(symbolName: "exclamationmark.circle", placeHolder: "Enter Last name", field: $viewModel.lastName, prompt: viewModel.lastNamePrompt)
                        EntryField(symbolName: "exclamationmark.circle", placeHolder: "Enter Your Email", field: $viewModel.email, isEmail: true, prompt: viewModel.emailPrompt)
                        EntryField(symbolName: "info", placeHolder: "Enter your nickname", field: $viewModel.nickName, prompt: "")
                        EntryField(symbolName: "exclamationmark.circle", placeHolder: "Enter your password", field: $viewModel.password, isSecure: true, prompt: viewModel.passwordPrompt)
                        EntryField(symbolName: "exclamationmark.circle", placeHolder: "Confirm password", field: $viewModel.confirmPass, isSecure: true, prompt: viewModel.confirmPassPrompt)
                        Picker("Program", selection: $viewModel.currentlySelectedProgram){
                            Text("Select Your Study").tag(nil as Int?)
                                .foregroundColor(.red)
                            
                            ForEach(viewModel.programs){ it in
                                Text(it.name).tag(it.id as Int?)
                            }
                        }
                        .padding(10)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                        Text(viewModel.programPrompt)
                            .font(.caption)
                        
                        Button(action: {
                            isLoggingin = true
                            API.shared.registerStudent(firstName: viewModel.firstName, lastName: viewModel.lastName, email: viewModel.email, nickName: viewModel.nickName, password: viewModel.password, programId: viewModel.currentlySelectedProgram!){ (result) in
                                switch result {
                                case .success(_):
                                    print("result: \(result)")
                                    self.successful = true
                                    self.presentationMode.wrappedValue.dismiss()
                                case .failure(let error):
                                    switch error {
                                    case .urlError(_):
                                        errorDescription = "URL Error"
                                        self.isRequestErrorViewPresented = true
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
                            Text("Register as Student")
                                .frame(maxWidth: .infinity, minHeight: 50)
                                .foregroundColor(.white)
                                .background(Image("buttonbg"))
                                .cornerRadius(9.0)
                                .opacity(viewModel.signUpComplete ? 1 : 0.5)
                        })
                            .disabled(!viewModel.signUpComplete)
                    }
                    .frame(minHeight: 650)
                    .padding(.bottom)
                }
                
            }.alert(isPresented: $isRequestErrorViewPresented){
                Alert(title: Text("Error"), message: Text(errorDescription), dismissButton: .default(Text("OK")))
            }.alert(isPresented: $successful){
                Alert(title: Text("Success"), message: Text("Account successfully created!"), dismissButton: .default(Text("OK")))
            }
            .navigationBarTitle("Register as Student", displayMode: .inline)
            .padding()
            
        }
        //.navigationBarBackButtonHidden(true)
    }
}


struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
