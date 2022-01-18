//
//  ProfileView.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 30/12/2020.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var viewModel = EditStudentVM.shared
    @ObservedObject var api = API.shared
    @EnvironmentObject var viewRouter: ViewRouter
    @State var errorDescription: String = ""
    @State var isRequestErrorViewPresented: Bool = false
    @State var successful: Bool = false
    @State var successfulPassChange = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        NavigationView {
            VStack {
                TopRect()
                    //.frame(maxHeight: 100)
                if (viewModel.name == ""){
                    MidProgressView()
                }
                else if viewModel.isLoading{
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
                            EntryField(symbolName: "exclamationmark.circle", placeHolder: "Enter Your Name", field: $viewModel.name, prompt: "")
                            Text("Your nickname")
                                .padding(.top, 4)
                                .font(.caption)
                            EntryField(symbolName: "info", placeHolder: "Enter Your Nickname", field: $viewModel.nickName, prompt: "")
                            Text("Say something about yourself")
                                .padding(.top, 4)
                                .font(.caption)
                            EntryField(symbolName: "info", placeHolder: "Say something about yourself", field: $viewModel.about, isLarge: true, prompt: "")
                        }
                        .padding()
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                        .padding(.leading)
                        .padding(.trailing)
                        
                        
                            
                        VStack{
                            if viewModel.isAddingLink {
                                Form {
                                    Section(header: Text("Link to Add")) {
                                        HStack {
                                            TextField("Link", text: $viewModel.link)
                                                .autocapitalization(.none)
                                                //.keyboardType(.numberPad)
                                            Button(action: {
                                                viewModel.addLink()
                                            }) {
                                                Text("Add")
                                            }
                                        }

                                    }
                                }
                                .frame(height: 150)
                            }
                            
                            Text("Click on the plus box to add a personal link, or on the minus box to delete.")
                                .font(.caption)
                                .padding(.top, 4)
                            
                            HStack{
                                Button(action: {
                                    viewModel.isAddingLink = true
                                }) {
                                    Image(systemName: "plus.square.fill")
                                        .padding(3)
                                }
                                
                                Button(action: {
                                    viewModel.removeLinks()
                                }) {
                                    Image(systemName: "minus.square.fill")
                                        .padding(3)
                                }
                            }
                            
                            
                            if viewModel.links.count == 0{
                                Text("You haven't shared any of your links yet!")
                                    .font(.caption)
                                    .padding(.top)
                            } else{
                                Text("Your links:")
                                    .font(.caption)
                                    .padding(.top)
                            }
                            ForEach(0..<viewModel.links.count, id: \.self) { i in
                                Link("\"\(viewModel.links[i] ?? "")\"", destination: URL(string: viewModel.links[i] ?? "")!)
                                    .font(.footnote)
                                    
                            }
                        }
                        
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
    
                        Spacer()
                        Button(action: {
                            viewModel.editStudent(){result in
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
//                                        self.presentationMode.wrappedValue.dismiss()
                                    viewModel.isLoading = false
                                }
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
                                    self.viewModel.isLoading = false
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
                                .opacity(viewModel.editComplete && viewModel.completeChangePass ? 1 : 0.5)
                                .padding()
                        })
                            .disabled(!viewModel.editComplete || !viewModel.completeChangePass)
                    }
                    .frame(height: 600)
                }
            }.alert(isPresented: $viewModel.isAlerted){
                if viewModel.successful && !viewModel.wrongPass{
                    return Alert(title: Text("Success"), message: Text("Saved!"), dismissButton: .default(Text("OK")))
                } else if viewModel.wrongPass{
                    return Alert(title: Text("Attention"), message: Text("You entered the wrong password."), dismissButton: .default(Text("OK")))
                } else if isRequestErrorViewPresented{
                    return Alert(title: Text("Attention"), message: Text(errorDescription), dismissButton: .default(Text("OK")))
                }
                return Alert(title: Text("Attention"), message: Text("Something went wrong, try again later."), dismissButton: .default(Text("OK")))
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear{
                viewModel.getStudent()
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

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView().environmentObject(ViewRouter())
    }
}
