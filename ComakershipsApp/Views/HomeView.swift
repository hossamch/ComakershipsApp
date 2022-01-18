//
//  HomeView.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 17/12/2020.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var api = API.shared
    @ObservedObject var viewModel = StudentVM.shared
    @ObservedObject var inboxvm = InboxTeamsVM.shared
    @ObservedObject var comakershipvm = ComakershipVM.shared
    @ObservedObject var manager = NavigationManager.shared
    //final
    var body: some View {
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
                                .multilineTextAlignment(.center)
                            if inboxvm.joinRequests.results.count > 0{
                                Text("Check out your inbox, you got mail!")
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .padding()
                                    .frame(width: 350, alignment: .center)
                            }
                            if comakershipvm.countStarted > 0{
                                Text("You're participating in a comakership, check it out!")
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .padding()
                                    .frame(width: 350, alignment: .center)
                            }
                            
                            Spacer()
                            VStack{
                                Button(action: {
                                    manager.changeTab(tab: 4)
                                }, label: {
                                    GreenButton(text: "Search Team")
                                })
                                
                                Button(action: {
                                    manager.changeTab(tab: 3)
                                }, label: {
                                    PurpleButton(text: "Search Comakership")
                                })
                            }
                        }
                        .frame(height: 600)
                        .background(Color.white // any non-transparent background
                                        .shadow(color: Color.black, radius: 1, x: 0, y: 0)
                          )
                        .padding()
                    }
                }

                .navigationBarItems(trailing: Button(action: {
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
            .onAppear{
                viewModel.getStudent()
                inboxvm.getAllNotifications()
                comakershipvm.getComakerships()
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
