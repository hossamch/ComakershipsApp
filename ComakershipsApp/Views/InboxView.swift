//
//  InboxView.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 18/12/2021.
//

import SwiftUI

struct InboxView: View {
    @ObservedObject var viewModel = InboxTeamsVM.shared
    
    var body: some View {
        NavigationView {
            VStack {
                TopRect()
                VStack{
                    if viewModel.loading{
                        MidProgressView()
                    } else if viewModel.joinRequests.results.count ==  0{
                        Text("You don't have any notifications yet!")
                            .font(.headline)
                            .fontWeight(.bold)
                            .frame(height: 600)
                    }
                    else{
                        if #available(iOS 15.0, *) {
                            List {
                                ForEach(0..<viewModel.joinRequests.results.count, id: \.self) { x in
                                    ForEach(0..<viewModel.joinRequests.results[x].count, id: \.self){ y in
                                        VStack{
                                            HStack{
                                                Image(systemName: "exclamationmark.circle")
                                                    .resizable()
                                                    .foregroundColor(.yellow)
                                                //.padding()
                                                    .frame(width: 35, height: 35)
                                                HStack{
                                                    //Text("\(viewModel.joinRequests.results[x][y].teamId)")
                                                    // .font(.headline)
                                                    Text("\(viewModel.joinRequests.results[x][y].studentUser.name) want to join \(viewModel.joinRequests.results[x][y].team.name)!")
                                                        .font(.headline)
                                                }
                                                .padding()
                                            }
                                            HStack{
                                                Button(action: {
                                                    viewModel.acceptJoinRequest(teamId: viewModel.joinRequests.results[x][y].team.id, studentId: viewModel.joinRequests.results[x][y].studentUser.id)
                                                    viewModel.joinRequests.results[x].remove(at: y)
                                                }, label: {
                                                    GreenButton(text: "Accept")
                                                        //.frame(width: 90,height: 30)
                                                })
                                                    .frame(width: 90,height: 30)
                                                    .buttonStyle(BorderlessButtonStyle())
                                                Button(action: {
                                                    viewModel.denyJoinRequest(teamId: viewModel.joinRequests.results[x][y].team.id, studentId: viewModel.joinRequests.results[x][y].studentUser.id)
                                                    viewModel.joinRequests.results[x].remove(at: y)
                                                }, label: {
                                                    RedButton(text: "Reject")
                                                })
                                                    .frame(width: 90,height: 30)
                                                    .buttonStyle(BorderlessButtonStyle())
                                            }
                                        }
                                        .padding(5)
                                        //.overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                                    }
                                }
                            }
                            .frame(height: 650)
                            //.listStyle(PlainListStyle())
                            .refreshable{
                                viewModel.refresh()
                            }
                        } else {
                            // Fallback on earlier versions
                        }
                        
                    }
                    
                }.alert(isPresented: $viewModel.isAlerted){
                    if viewModel.status == JoinRequestStatus.Accepted{
                        return Alert(title: Text("Accepted"), message: Text("You have accepted the join request."), dismissButton: .default(Text("OK")))
                    } else if viewModel.status == JoinRequestStatus.Rejected{
                        return Alert(title: Text("Rejected"), message: Text("You have denied the join request."), dismissButton: .default(Text("OK")))
                    }else if viewModel.status == JoinRequestStatus.Empty{
                        return Alert(title: Text("Notice"), message: Text("You don't have any notifications right now."), dismissButton: .default(Text("OK")))
                    } else{
                        return Alert(title: Text("Attention"), message: Text("Something went wrong."), dismissButton: .default(Text("OK")))
                    }
                }
                .padding()
                
                
            }
            .navigationTitle("Inbox")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button(action: {
                viewModel.refresh()
            }, label: {
                Image(systemName: "arrow.clockwise")
            }))
        }
        .onAppear{
            viewModel.getAllNotifications()
//            if API.shared.isAuthenticated{
//                viewModel.refresh()
//            }
//            viewModel.status = JoinRequestStatus.Default
//            if viewModel.joinRequests.results.count == 0{
//                viewModel.getAllNotifications()
            //}
            
            //if API.shared.isAuthenticated{
                //viewModel.checkIfEmpty()
            //}
        }
    }
        
}

struct InboxView_Previews: PreviewProvider {
    static var previews: some View {
        InboxView()
    }
}
