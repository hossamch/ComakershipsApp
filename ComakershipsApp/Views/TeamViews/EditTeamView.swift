//
//  EditTeamView.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 01/01/2022.
//

import SwiftUI

struct EditTeamView: View {
    @ObservedObject var viewModel = EditTeamVM.shared
    @State var id: Int
    @State var errorDescription = ""
    @State var isLeaving = false
    @State var isKicking = false
    @State var currentMate = ""
    @State var currentMateId = 0
    let teamsvm: TeamsVM
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack {
            VStack {
                TopRect()
                    .frame(maxHeight: 100)
                if viewModel.isLoading{
                    ProgressView("Processing...")
                        .position(x: UIScreen.main.bounds.width/2, y: 0)
                }
                else{
                    ScrollView{
//                        Text("Enter team ID")
//                            .padding(.top, 4)
//                            .font(.caption)
                        Text("Enter team name")
                            .padding(.top, 4)
                            .font(.caption)
                        EntryField(symbolName: "exclamationmark.circle", placeHolder: "Enter Team name", field: $viewModel.name, prompt: viewModel.namePrompt)
                        Text("Give your team a description")
                            .padding(.top, 4)
                            .font(.caption)
                        EntryField(symbolName: "exclamationmark.circle", placeHolder: "Team description", field: $viewModel.description, isLarge: true, prompt: viewModel.descriptionPrompt)
                        
                        
                        Text("Members")
                            .font(.headline)
                        ForEach(0..<viewModel.members.count, id: \.self){i in
                            HStack{
                                Text("\(viewModel.members[i].name) --- \(viewModel.members[i].email)")
                                    .font(.headline)
                                if viewModel.members[i].id != Int(API.shared.userId!){
                                    Button(action: {
                                        currentMate = viewModel.members[i].name
                                        currentMateId = viewModel.members[i].id
                                        isLeaving = false
                                        isKicking = true
                                        viewModel.isAlerted = true
                                        
                                    }, label: {
                                        Image(systemName: "minus.square.fill")
                                    })
                                }
                            }
                            .padding(3)
                        }
                        
                        
                        VStack{
                            Spacer()
                            Button(action: {
                                teamsvm.edited = true
                                viewModel.editTeam(teamId: id){result in
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
                                        
                                        self.viewModel.isAlerted = true
                                    case .success(_):
                                        
                                        self.viewModel.successful = true
                                        viewModel.isLoading = false
                                    }
                                }
                                self.teamsvm.getMyTeams()
                                
                            }
                            ,label: {
                                Text("Edit Profile")
                                    .frame(maxWidth: .infinity, minHeight: 50)
                                    .foregroundColor(.white)
                                    .background(Image("buttonbg"))
                                    .cornerRadius(9.0)
                                    .opacity(viewModel.complete ? 1 : 0.5)
                                    .padding()
                            })
                                .disabled(!viewModel.complete)
                    }
                }
                .alert(isPresented: $viewModel.isAlerted){
                    if isLeaving{
                        return Alert(
                            title: Text("Leave"),
                            message: Text("Are you sure you want to leave \(viewModel.name)"),
                            primaryButton: .destructive(Text("Leave")) {
                                viewModel.isLoading = true
                                viewModel.leaveTeam(teamId: self.id)
                                self.presentationMode.wrappedValue.dismiss()
                            },
                            secondaryButton: .cancel()
                        )
                    }
                    else if isKicking{
                        return Alert(
                            title: Text("Kick"),
                            message: Text("Are you sure you want to kick \(currentMate)"),
                            primaryButton: .destructive(Text("Kick")) {
                                viewModel.isLoading = true
                                viewModel.kickFromTeam(teamId: self.id, studentId: currentMateId)
                                //self.presentationMode.wrappedValue.dismiss()
                            },
                            secondaryButton: .cancel()
                        )
                    }
                    else{
                        return Alert(title: Text("Success"), message: Text("Saved!"), dismissButton: .default(Text("OK")))
                    }
                
            }
            .navigationTitle("Edit Team")
        
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button(action: {
                //leaveteam
                isLeaving = true
                isKicking = false
                viewModel.isAlerted = true
            }, label: {
                Text("Leave")
            }))
        }

        }.onAppear{
            viewModel.getTeamById(id: id)
        }
    }
}

//struct EditTeamView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditTeamView(viewModel: TeamsVM(), team: LinkedTeam())
//    }
//}
}
