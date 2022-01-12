//
//  SearchTeamView2.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 01/01/2022.
//

import SwiftUI

struct TeamDetailView: View {
    @ObservedObject var viewModel: TeamsVM
    @State var team: TeamResponse?
    @State var errorDescription = ""
    @State var isAlerted = false
    
    var body: some View {
        VStack{
            TopRect()
            VStack{
                if (viewModel.loadingJoin){
                    ProgressView("Loading..")
                        .position(x: UIScreen.main.bounds.width/2, y: 0)
                }
                else{
                    VStack{
                        VStack{
                            Text("")
                            Text(team?.name ?? "Error")
                                .font(.title)
                                .fontWeight(.bold)
                                .padding()
                            Text(team?.description ?? "Error")
                                .font(.subheadline)
                                .padding()
                        }
                        .padding(5)
                        //.frame(height: 400)
                        .navigationTitle("Results")
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                        .position(x: UIScreen.main.bounds.width/2, y: 200)
                    
                        
                        Spacer()
                        
                        Button(action: {
                            isAlerted = true
                            if viewModel.myJoinRequests.contains(team!.id){
                                viewModel.cancelJoinRequest(id: team!.id){result in
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
//                                        viewModel.isAlerted = true
                                    case .success(_):
                                        print("")
//                                        viewModel.loadingJoin = false
//                                        viewModel.isAlerted = true
                                    }
                                }
                            } else{
                                isAlerted = true
                                viewModel.joinTeam(id: team!.id){result in
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
//                                        viewModel.isAlerted = true
                                    case .success(_):
                                        print("")
//                                        viewModel.loadingJoin = false
//                                        viewModel.isAlerted = true
                                    }
                                }
                            }
                        }
                        ,label: {
                            if viewModel.myJoinRequests.contains(team!.id){
                                RedButton(text: "Cancel")
                            } else{
                                GreenButton(text: "Join Team")
                            }
                        })
                            .offset(y: 300)
                        .navigationBarTitleDisplayMode(.inline)
                    }
                    .position(x: UIScreen.main.bounds.width/2, y: -160)
                }
            }
//            .alert("Title", isPresented: $viewModel.isAlerted, actions: {})
            .alert(isPresented: $isAlerted){
                if viewModel.requestStatus == RequestStatus.Joined{
                    return Alert(title: Text("Requested"), message: Text("You have sent a join request to the team."), dismissButton: .default(Text("OK")))
                } else {
                    return Alert(title: Text("Canceled"), message: Text("You have canceled your join request."), dismissButton: .default(Text("OK")))
                }
            }
        }
    }
}

struct TeamDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TeamDetailView(viewModel: TeamsVM.shared)
    }
}
