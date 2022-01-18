//
//  InboxCompanyView.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 01/01/2022.
//

import SwiftUI

struct InboxCompanyView: View {
    @ObservedObject var viewModel = InboxVM.shared
    
    var body: some View {
        NavigationView {
            VStack {
                TopRect()
                VStack{
                    if viewModel.loading{
                        MidProgressView()
                    } else if viewModel.applications.count ==  0{
                        Text("You don't have any notifications yet!")
                            .frame(height: 600)

                    } else{
                        if #available(iOS 15.0, *) {
                            List {
                                ForEach(0..<viewModel.applications.count, id: \.self) { x in
                                    ForEach(0..<viewModel.applications[x].count, id: \.self){ y in
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
                                                    Text("\(viewModel.applications[x][y].team.name) want to join \(viewModel.comakerships[viewModel.comakerships.firstIndex(where: {$0.id ==  viewModel.applications[x][y].comakershipId})!].name)!")
                                                        .font(.headline)
                                                }
                                                .padding()
                                            }
                                            HStack{
                                                Button(action: {
                                                    viewModel.acceptApplication(comakershipId: viewModel.applications[x][y].comakershipId, teamId: viewModel.applications[x][y].teamId)
                                                    viewModel.applications[x].remove(at: y)
                                                }, label: {
                                                    GreenButton(text: "Accept")
                                                        //.frame(width: 90,height: 30)
                                                })
                                                    .frame(width: 90,height: 30)
                                                    .buttonStyle(BorderlessButtonStyle())
                                                Button(action: {
                                                    viewModel.rejectApplication(comakershipId: viewModel.applications[x][y].comakershipId, teamId: viewModel.applications[x][y].teamId)
                                                    viewModel.applications[x].remove(at: y)
                                                }, label: {
                                                    RedButton(text: "Reject")
                                                })
                                                    .frame(width: 90,height: 30)
                                                    .buttonStyle(BorderlessButtonStyle())
                                            }
                                        }
                                        .padding(.bottom)
                                    }
                                }
                            }
                            .frame(height: 650)
                           // .listStyle(PlainListStyle())
                            .refreshable{
                                viewModel.refresh()
                            }
                        } else {
                            // Fallback on earlier versions
                        }
                        
                    }
                    
                }.alert(isPresented: $viewModel.isAlerted){
                    if viewModel.status == JoinRequestStatus.Accepted{
                        return Alert(title: Text("Accepted"), message: Text("You have accepted the join request."), dismissButton: Alert.Button.default(Text("OK"), action: {}))
                    } else if viewModel.status == JoinRequestStatus.Rejected{
                        return Alert(title: Text("Rejected"), message: Text("You have rejected the join request."), dismissButton: .default(Text("OK")))
                    }else if viewModel.status == JoinRequestStatus.Empty{
//                        return Alert(
//                            title: Text("Attention"),
//                            message: Text("You don't have any notifications yet!"),
//                            dismissButton: Alert.Button.default(
//                                    Text("OK"), action: { print("Hier een action die user terug stuurt.") }
//                        ))
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
                    .foregroundColor(.purple)
            }))
        }
        .onAppear{
            guard CompanyVM.shared.companyUser.company != nil else{return}
            if API.shared.isAuthenticated && CompanyVM.shared.companyUser.company!.name != ""{
               // viewModel.refresh()
            }
        }
    }
}

struct InboxCompanyView_Previews: PreviewProvider {
    static var previews: some View {
        InboxCompanyView()
    }
}
