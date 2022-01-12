//
//  MyTeamsView.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 01/01/2022.
//

import SwiftUI

struct MyTeamsView: View {
    @ObservedObject var viewModel = TeamsVM.shared
    @State var edited = false
    
    var body: some View {
        NavigationView{
            VStack{
                TopRect()
                VStack{
                    if (viewModel.loadingMyTeams){
                        MidProgressView()
                            .navigationBarTitle("Teams", displayMode: .inline)
                    }
                    else{
                        VStack{
                            if #available(iOS 15.0, *) {
                                List{
                                    ForEach(0..<viewModel.myTeams.count, id: \.self) { i in
                                        NavigationLink(destination: EditTeamView(id: viewModel.myTeams[i].teamId, teamsvm: viewModel)){
                                            VStack{
                                                HStack{
                                                    Text("\(viewModel.myTeams[i].teamId)")
                                                        .font(.headline)
                                                    Text(viewModel.myTeams[i].team.name)
                                                        .font(.headline)
                                                    Text(viewModel.myTeams[i].team.description)
                                                        .font(.subheadline)
                                                }
                                                .padding()
                                            }
                                        }
                                    }
                                }
                                .listStyle(PlainListStyle())
                                .frame(height: 450)
                                .navigationTitle("Your Teams")
                                .font(.title2)
                                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 0.5))
                                .refreshable{
                                    viewModel.getMyTeams()
                                }
                            } else {
                                // Fallback on earlier versions
                            }
                            
                            
                            Spacer()
                            NavigationLink(
                                destination: SearchTeamView(viewModel: viewModel),
                                    label: {
                                        GreenButton(text: "Search Specific Team")
                                    }
                            )
                               // .padding()
                            
                            NavigationLink(
                                destination: TeamsView(viewModel: viewModel),
                                    label: {
                                        PurpleButton(text: "Search All Team")
                                    }
                            )
                              //  .padding()
                            .navigationBarTitleDisplayMode(.inline)
                            
                            
                        }
                        .onAppear{
                            guard (viewModel.api.userId != nil) else{
                                return self.viewModel.api.logout()
                            }
                            if viewModel.myTeams.count == 0 || viewModel.myTeams[0].studentUserId != Int(viewModel.api.userId!)!{
                                viewModel.getMyTeams()
                            }
                            
                            if viewModel.edited == true{
                                viewModel.getMyTeams()
                                viewModel.edited = false
                            }
                        }
                        //.position(x: 190, y: -160)
                        //.frame(minHeight: )
                        .navigationBarItems(trailing: NavigationLink(
                            destination: CreateTeamView(viewModel: viewModel),
                                label: {
                                    Text("Create")
                                        .foregroundColor(.blue)
                                        //.opacity(api.isAuthenticated ? 0 : 1)
                                }
                        ))
                    }
                }
            }
        }
    }
}

struct MyTeamsView_Previews: PreviewProvider {
    static var previews: some View {
        MyTeamsView(viewModel: TeamsVM.shared)
    }
}
