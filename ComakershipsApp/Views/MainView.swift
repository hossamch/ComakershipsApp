//
//  MainView.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 15/12/2021.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var api = API.shared
    @ObservedObject var manager = NavigationManager.shared
    
    var body: some View {
        if(api.isAuthenticated){
            
            if (api.userType == UserTypes.student.rawValue){
                TabView(selection: $manager.selected){
                    HomeView()
                        .tabItem{
                            Label("Home", systemImage: "house")
                        }.tag(1)
                    ProfileView().navigationTitle("").navigationBarHidden(true)
                        .tabItem{
                            Label("Profile", systemImage: "list.dash")
                        }.tag(2)
                    ComakershipSummaryView().navigationTitle("").navigationBarHidden(true)
                        .tabItem {
                            Label("Comakerships", systemImage: "tray.full")
                        }.tag(3)
                    MyTeamsView().navigationTitle("").navigationBarHidden(true)
                        .tabItem{
                            Label("Teams", systemImage: "person.3")
                        }.tag(4)
                    if api.notification{
                        InboxView()
                            .tabItem{
                                Label("Inbox", systemImage: "envelope.badge")
                            }.tag(5)
                    }else{
                        InboxView().navigationTitle("").navigationBarHidden(true)
                            .tabItem{
                                Label("Inbox", systemImage: "envelope")
                            }.tag(5)
                    }
                    
                }
                .onAppear{
                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: {success, error in
                        if success{
                            
                        }else{
                            print(error)
                        }
                    })
                }
            }
            else{
                TabView(selection: $manager.selected){
                    CompanyHomeView()
                        .tabItem{
                            Label("Home", systemImage: "house")
                        }.tag(1)
                        .transition(.scale)
                    CompanyUserProfileView()
                        .tabItem{
                            Label("Profile", systemImage: "list.dash")
                        }.tag(2)
                    ComakershipsMainView()
                        .tabItem {
                            Label("Comakerships", systemImage: "tray.full")
                        }.tag(3)
                    CompanyMainView()
                        .tabItem{
                            Label("Company", systemImage: "person.3")
                        }.tag(4)
                        .transition(.scale)
                    InboxCompanyView()
                        .tabItem{
                            Label("Inbox", systemImage: "envelope")
                        }.tag(5)
                }
                .onAppear{
                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: {success, error in
                        if success{
                            //
                        }else{
                            print(error)
                        }
                    })
                }
            }
        }
        else{
            LoginView()
        }
        
    }
}


struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

enum UserTypes: String{
    case student = "StudentUser"
    case companyUser = "CompanyUser"
}
