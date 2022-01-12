//
//  LoginView.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 11/12/2020.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel = LoginVM.shared
    
    @State var isLoggingin: Bool = false
    @State var isLoggedin: Bool = false
    @State var isRequestErrorViewPresented: Bool = false
    @State var errorDescription: String = ""
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var userInfo: UserInfo
    
    var body: some View {
            NavigationView {
                    VStack {
                        TopRect()
                        //content
                        VStack{
                            VStack{
                                if (isLoggingin){
                                    ProgressView("Logging in...")
                                        .position(x: UIScreen.main.bounds.width/2, y: 0)
                                }
                                else{
                                    Image("comakershipimg")
                                        .padding(.bottom, 10)
                                        .offset(y: -110)
                                    HStack{
                                        Image("Avatar")
                                        TextField("Enter email", text: $viewModel.email)
                                            .padding()
                                            .border(Color.black, width: 1)
                                            .autocapitalization(.none)
                                    }
                                    HStack{
                                        Image("Lock")
                                        SecureField("Enter password", text: $viewModel.password)
                                            .padding()
                                            .border(Color.black, width: 1)
                                            .autocapitalization(.none)
                                    }
                                    
                                    Button(action: {
                                        isLoggingin = true
                                        viewModel.api.login(email: viewModel.email, password: viewModel.password){ (result) in
                                            switch result {
                                            case .success(let response):
                                                viewModel.api.accessToken = response.accessToken
                                                viewModel.api.userId = response.userId
                                                viewModel.api.userType = response.userType
                                                self.viewModel.api.userType = response.userType
                                                self.presentationMode.wrappedValue.dismiss()
                                                self.isLoggedin = true
                                            case .failure(let error):
                                                switch error {
                                                case .addressUnreachable(_):
                                                    errorDescription = "Something went wrong processing your request, check your internet connectivity."
                                                case .invalidResponse:
                                                    errorDescription = "Invalid Credentials"
                                                case .genericError(_):
                                                    errorDescription = "Something went wrong, try again later."
                                                case .unAuthorized:
                                                    errorDescription = "Youre unauthorized."
                                                case .decodingError(_):
                                                    errorDescription = "Something changed in the backend, try again later."
                                                case .encodingError(_):
                                                    errorDescription = error.failureReason ?? "Encodingerror"
                                                }
                                                
                                                self.isRequestErrorViewPresented = true
                                            }
                                            isLoggingin = false
                                        }
                                        
                                    }, label: {
                                        GreenButton(text: "Login")
                                            .opacity(viewModel.loginComplete ? 1 : 0.5)
                                    })
                                        .disabled(!viewModel.loginComplete)
                                    
//                                    NavigationLink(
//                                        destination: MainView().navigationBarTitle("").navigationBarBackButtonHidden(true).navigationBarHidden(true),
//                                        isActive: $isLoggedin,
//                                        label: {
//                                            Button(action: {
//                                                isLoggingin = true
//                                                viewModel.api.login(email: viewModel.email, password: viewModel.password){ (result) in
//                                                    switch result {
//                                                    case .success(let response):
//                                                        viewModel.api.accessToken = response.accessToken
//                                                        viewModel.api.userId = response.userId
//                                                        viewModel.api.userType = response.userType
//                                                        self.viewModel.api.userType = response.userType
//                                                        //self.presentationMode.wrappedValue.dismiss()
//                                                        self.isLoggedin = true
//                                                    case .failure(let error):
//                                                        switch error {
//                                                        case .addressUnreachable(_):
//                                                            errorDescription = "Something went wrong processing your request, check your internet connectivity."
//                                                        case .invalidResponse:
//                                                            errorDescription = "Invalid Credentials"
//                                                        case .genericError(_):
//                                                            errorDescription = "Something went wrong, try again later."
//                                                        case .unAuthorized:
//                                                            errorDescription = "Youre unauthorized."
//                                                        case .decodingError(_):
//                                                            errorDescription = "Something changed in the backend, try again later."
//                                                        case .encodingError(_):
//                                                            errorDescription = error.failureReason ?? "Encodingerror"
//                                                        }
//
//                                                        self.isRequestErrorViewPresented = true
//                                                    }
//                                                    isLoggingin = false
//                                                }
//
//                                            }, label: {
//                                                Text("Login")
//                                                    .frame(maxWidth: .infinity, minHeight: 50)
//                                                    .foregroundColor(.white)
//                                                    .background(Image("buttonbg"))
//                                                    .cornerRadius(9.0)
//                                                    .opacity(viewModel.loginComplete ? 1 : 0.5)
//                                            })
//                                        })
//                                        .navigationBarBackButtonHidden(true)
//                                        .disabled(!viewModel.loginComplete)
                                    
                                    NavigationLink(
                                        destination: RegisterView(),
                                        label: {
                                                Text("Dont have an account? Register")
                                                .font(.system(size: 15, weight: .medium, design: .default))
                                                    .padding(.top, 20)
                                            }
                //                        }
                                )
                                    
                                    NavigationLink(
                                        destination: RegisterCompanyView(),
                                        label: {
                //                            Button(action:{
                ////                                self.presentationMode.wrappedValue.
                //                            }){
                                                Text("Got an assignment for students? Sign up here.")
                                                .font(.system(size: 15, weight: .medium, design: .default))
                                                    .padding(.top, 5)
                                            }
                //                        }
                                )
                                        .navigationBarBackButtonHidden(true)
                                }
                                
                            }.alert(isPresented: $isRequestErrorViewPresented){
                                Alert(title: Text("Attention"), message: Text(errorDescription), dismissButton: .default(Text("OK")))
                            }
                            .padding()
                            
                            
                        }
                    }
                  //  .navigationViewStyle(StackNavigationViewStyle())
                    .navigationBarTitle("Login", displayMode: .inline)
                    .font(.title2)
                    
//                }
            }
        }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView().environmentObject(UserInfo())
//        LoginView()
    }
}
