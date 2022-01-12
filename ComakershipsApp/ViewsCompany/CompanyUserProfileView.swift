//
//  CompanyUserProfileView.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 26/12/2021.
//

import SwiftUI

struct CompanyUserProfileView: View {
    @ObservedObject var viewModel = EditCompanyUserVM.shared
    @EnvironmentObject var viewRouter: ViewRouter
    @State var errorDescription: String = ""
    @State var isRequestErrorViewPresented: Bool = false
    @State var successful: Bool = false
    @State var successfulPassChange: Bool = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        NavigationView {
            VStack {
                TopRect()
                    //.frame(maxHeight: 100)
                if viewModel.loading{
                    ProgressView("Processing...")
                        .position(x: UIScreen.main.bounds.width/2, y: 0)
                }
                else{
                    //Spacer()
                    ScrollView{
                        
                        VStack{
                            Text("Your full name")
                                .padding(.top, 4)
                                .font(.caption)
                            EntryField(symbolName: "info", placeHolder: "Enter Your Name", field: $viewModel.name, prompt: viewModel.namePrompt)
                            Text("Change Password")
                                .padding(.top)
                                .font(.caption)
                            
                            VStack{
                                Text("Current password")
                                    .padding(.top, 4)
                                    .font(.caption)
                                EntryField(symbolName: "info", placeHolder: "Enter password", field: $viewModel.oldPassword, isSecure: true, prompt: viewModel.oldPassPrompt)
                                Text("New password")
                                    .padding(.top, 4)
                                    .font(.caption)
                                EntryField(symbolName: "info", placeHolder: "Enter new password", field: $viewModel.newPassword, isSecure: true, prompt: viewModel.newPassPrompt)
                                Text("Confirm password")
                                    .padding(.top, 4)
                                    .font(.caption)
                                EntryField(symbolName: "info", placeHolder: "Confirm password", field: $viewModel.confirmPass, isSecure: true, prompt: viewModel.confirmPassPrompt)
                            }
                            .padding()
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                            .padding(.leading)
                            .padding(.trailing)
                        }
                        

                        Spacer()
                        Button(action: {
                            viewModel.editCompanyUser(){result in
                                switch result{
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
                                case .success(_):
                                    self.successful = true
                                    self.presentationMode.wrappedValue.dismiss()
                                    
                                }
                                self.viewModel.loading = false
                                self.viewModel.isAlerted = true
                            }
        
                            
                            if viewModel.completeChangePass && viewModel.oldPassword != ""{
                                viewModel.changePassword(){result in
                                    switch result{
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
                                    case .success(_):
                                        self.successfulPassChange = true
                                        self.presentationMode.wrappedValue.dismiss()
                                    }
                                    self.viewModel.loading = false
                                    self.viewModel.isAlerted = true
                                }
                            }
                        }
                        ,label: {
                            Text("Edit Profile")
                                .frame(maxWidth: .infinity, minHeight: 50)
                                .foregroundColor(.white)
                                .background(Image("buttonbg"))
                                .cornerRadius(9.0)
                                .opacity(viewModel.completeChangePass ? 1 : 0.5)
                                .padding()
                        })
                            .disabled(!viewModel.completeChangePass)
                    }
                    .frame(height: 600)
                }
                
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            
            .alert(isPresented: $viewModel.isAlerted){
                if viewModel.success{
                    return Alert(title: Text("Success"), message: Text("Saved!"), dismissButton: .default(Text("OK")))
                } else if viewModel.wrongPass{
                    return Alert(title: Text("Attention"), message: Text("You entered the wrong password."), dismissButton: .default(Text("OK")))
                }
                else{
                    return Alert(title: Text("Attention"), message: Text(errorDescription), dismissButton: .default(Text("OK")))
                }
            }
            .onAppear{
                viewModel.getCompanyUser()
                self.successful = false
                self.successfulPassChange = false
            }
//            .navigationBarItems(trailing: Button(action: {
//                api.logout()
//            }, label: {
//                Image(systemName: "escape")
//                //Text("Log out")
//            }))
        }
        //.navigationViewStyle(StackNavigationViewStyle())
        //upper title
        //.navigationTitle("Edit Profile")
    }
}

struct CompanyUserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        CompanyUserProfileView()
    }
}
