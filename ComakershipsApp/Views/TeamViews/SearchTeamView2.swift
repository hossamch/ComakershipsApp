//
//  SearchTeamView2.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 02/01/2022.
//

import SwiftUI

struct SearchTeamView2: View {
    @ObservedObject var viewModel: TeamsVM
    @State var errorDescription = ""
    @State var isAlerted = false
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
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
                            Text("\(viewModel.teamById?.id ?? 0)")
                                .font(.headline)
                                .padding()
                            Text(viewModel.teamById?.name ?? "Error")
                                .font(.title)
                                .fontWeight(.bold)
                                .padding()
                            Text(viewModel.teamById?.description ?? "Error")
                                .font(.subheadline)
                                .padding()
                        }
                        .padding()
                        //.frame(height: 400)
                        .navigationTitle("Results")
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                        .position(x: UIScreen.main.bounds.width/2, y: 200)
                        
                        Spacer()
                        
                        
                        Button(action: {
                            isAlerted = true
                            if viewModel.myJoinRequests.contains(viewModel.teamById!.id){
                                viewModel.cancelJoinRequest(id: viewModel.teamById!.id){result in
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
                                viewModel.joinTeam(id: viewModel.teamById!.id){result in
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
                            if viewModel.myJoinRequests.contains(viewModel.teamById!.id){
                                RedButton(text: "Cancel")
                            } else{
                                GreenButton(text: "Join Team")
                            }
                        })
                            .offset(y: 300)
                        
                        
                        .navigationBarTitleDisplayMode(.inline)
                    }
                    .position(x: 190, y: -160)
                }
                // joined case to be tested
            }.alert(isPresented: $isAlerted){
                if viewModel.requestStatus == RequestStatus.Joined{
                    return Alert(title: Text("Requested"), message: Text("You have sent a join request to the team."), dismissButton: .default(Text("OK")))
                } else if viewModel.requestStatus == RequestStatus.Canceled{
                    return Alert(title: Text("Canceled"), message: Text("You have canceled your join request to the team."), dismissButton: .default(Text("OK")))
                } else {
                    return Alert(title: Text("Attention"), message: Text("You are already part of this team."), dismissButton: .default(Text("OK")))
                }
                
            }
        }
    }
}

struct SearchTeamView2_Previews: PreviewProvider {
    static var previews: some View {
        SearchTeamView2(viewModel: TeamsVM.shared)
    }
}
