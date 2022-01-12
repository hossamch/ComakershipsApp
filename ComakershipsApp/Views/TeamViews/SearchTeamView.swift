//
//  SearchTeamView.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 01/01/2022.
//

import SwiftUI

struct SearchTeamView: View {
    @ObservedObject var viewModel: TeamsVM
    
    var body: some View {
        VStack {
            ZStack{
                TopRect()
            }
            VStack {
                if viewModel.loadingTeamsById{
                    ProgressView()
                        .padding()
                } else{
                    EntryField(symbolName: "exclamationmark.circle", placeHolder: "Enter Team ID", field: $viewModel.teamIdField, prompt: viewModel.teamIdPrompt)
                        .keyboardType(.numberPad)
                        .offset(y: -50)

                    Spacer()
                    //misschien proberen met completion
                    NavigationLink(
                        destination: SearchTeamView2(viewModel: viewModel),
                        isActive: $viewModel.fetchedTeamById,
                        label: {
                            Button(action: {
                                viewModel.getTeamById()
                                //viewModel.fetchedTeamById = false
                                
                            }, label: {
                                GreenButton(text: "Search")
                                    .opacity(viewModel.searchIdComplete ? 1 : 0.5)
                            })
                        })
                        .disabled(!viewModel.searchIdComplete)
                    
                    .navigationBarTitle("Search Teams", displayMode: .inline)
                    .font(.title2)
                }
            }.alert(isPresented: $viewModel.notFound){
                Alert(title: Text("Attention"), message: Text("There is no team associated with the id you entered."), dismissButton: .default(Text("OK")))
            }
        }
    }
}

struct SearchTeamView_Previews: PreviewProvider {
    static var previews: some View {
        SearchTeamView(viewModel: TeamsVM.shared)
    }
}
