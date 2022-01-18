//
//  CompanyHomeView.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 26/12/2021.
//

import SwiftUI

struct CompanyHomeView: View {
    @ObservedObject var api = API.shared
    @ObservedObject var viewModel = CompanyVM.shared
    @ObservedObject var inboxvm = InboxVM.shared
    @ObservedObject var comakershipvm = ComakershipVM.shared
    @ObservedObject var manager = NavigationManager.shared
    
    var body: some View {
        if(api.isAuthenticated){
            NavigationView{
                VStack {
                    TopRect()
                    VStack {
                        if (viewModel.loading){
                            MidProgressView()
                        }
                        else{
                            VStack{
                                Text("Welcome " + api.userFullName!)
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .padding()
                                
                                if inboxvm.applications.count > 0{
                                    Text("Check out your inbox, you got mail!")
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                        .padding()
                                        .frame(width: 350, alignment: .center)
                                }
                                Spacer()
                                Text("For comakership key inquiries, send an email to hossam_c@icloud.com.")
                                    .font(.headline)
                                    .padding()
                                
                               // Spacer()
                                VStack{
                                    Button(action: {
                                        manager.changeTab(tab: 4)
                                    }, label: {
                                        GreenButton(text: "Your Company")
                                    })
                                    
                                    Button(action: {
                                        manager.changeTab(tab: 3)
                                    }, label: {
                                        PurpleButton(text: "Manage Comakerships")
                                    })
                                }
                            }
                            .frame(height: 600)
                            //.overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                           // .shadow(color: .black, radius: 1, x: 600, y: 0)
                            .background(Color.white // any non-transparent background
                                            .shadow(color: Color.black, radius: 1, x: 0, y: 0)
                              )
                            .padding()
                        }
                    }
                    //.navigationTitle("Home")
                    .font(.title2)
                    //.offset(y: 1000)
                
                    //.navigationBarTitleDisplayMode(.inline)
                    
                    .navigationBarItems(leading: NavigationLink(
                            destination: LoginView(),
                            label: {
                                Text("Login")
                                    .foregroundColor(.blue)
                                    .opacity(api.isAuthenticated ? 0 : 1)
                            }
                    ),
                    trailing: Button(action: {
                        withAnimation{
                            api.logout()
                        }
                    }, label: {
                        Image(systemName: "escape")
                            .foregroundColor(.purple)
                    })
                    )
                }
                .navigationBarTitle("Home", displayMode: .inline)
            }
            .onAppear{
                viewModel.getCompany()
                viewModel.getCompanyLogo()
                inboxvm.refresh()
                //comakershipvm.getComakerships()
            }
        }
    }
}

struct CompanyHomeView_Previews: PreviewProvider {
    static var previews: some View {
        CompanyHomeView()
    }
}
