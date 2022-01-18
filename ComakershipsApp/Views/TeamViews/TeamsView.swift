//
//  TeamsView.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 18/12/2021.
//

import SwiftUI

struct TeamsView: View {
    @ObservedObject var viewModel = TeamsVM.shared
    @ObservedObject var api = API.shared
    //all teams view
    var body: some View {
        VStack{
            VStack{
                TopRect()
                VStack{
                    if (viewModel.loading){
                        ProgressView("Loading..")
                    }
                    else{
                        VStack{
                            List{
                                ForEach(0..<viewModel.teams.count, id: \.self){i in
                                    if viewModel.teams[i].description != "This is my private team"{
                                        NavigationLink(destination: TeamDetailView(viewModel: viewModel, team: viewModel.teams[i])){
                                            VStack{
                                                HStack{
                                                    Text("\(viewModel.teams[i].id)")
                                                        .font(.headline)
                                                        .padding(.trailing)
                                                    Text(viewModel.teams[i].name)
                                                        .font(.headline)
                                                        .padding(.trailing)
                                                    Text(viewModel.teams[i].description)
                                                        .font(.subheadline)
                                                }
                                                .padding()
                                            }
                                        }
                                    }
                                }
                            }
                            .listStyle(PlainListStyle())
                            .frame(height: 620)
                            .navigationTitle("All Teams")
                            .font(.title2)
                            Spacer()
                        }
                    }
                }
            }
        }.onAppear{
            viewModel.getAllTeamsExceptMine()
        }
    }
}

struct TeamsView_Previews: PreviewProvider {
    static var previews: some View {
        TeamsView()
    }
}
