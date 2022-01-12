//
//  ComakershipsView.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 31/12/2021.
//

import SwiftUI

struct ComakershipsKickoffView: View {
    // hier de applications halen om de team weer te geven if applicable
    @ObservedObject var viewModel = ComakershipVM.shared
    @ObservedObject var inboxvm = InboxVM.shared
    @State var isActive = false
    @State private var navigateTo = ""
    
    var body: some View {
        VStack{
            VStack {
                TopRect()
                VStack {
                    if (viewModel.loading){
                        ProgressView("Loading..")
                            .position(x: UIScreen.main.bounds.width/2, y: 0)
                    }
                    else{
                        if (viewModel.countNotStarted == 0){
                            Text("You dont have any unstarted comakerships yet!")
                                .position(x: UIScreen.main.bounds.width/2, y: 0)
                        } else{
                            VStack{
                                Group{
                                    Text("Unstarted Comakerships")
                                        .font(.title)
                                        .fontWeight(.bold)
                                    if #available(iOS 15.0, *) {
                                        List {
                                            ForEach(0..<viewModel.comakerships.count, id: \.self) { i in
                                                if viewModel.comakerships[i].status!.name == "Not started"{
                                                    NavigationLink(destination: ComakershipsKickoffView2(comakership: viewModel.comakerships[i])){
                                                        VStack{
                                                            Text("\(viewModel.comakerships[i].name)")
                                                                .font(.title2)
                                                                .fontWeight(.bold)
                                                            //  .frame(width: 320,alignment: .topLeading)
                                                                .padding()
                                                            Text(viewModel.comakerships[i].description)
                                                                .font(.subheadline)
                                                                .fontWeight(.light)
                                                                .padding()
                                                            if viewModel.comakerships[i].bonus{
                                                                Text("This comakership offers a monetary bonus upon completion.")
                                                                    .font(.caption)
                                                                    .padding()
                                                                //.frame(alignment: .leading)
                                                            } else{
                                                                Text("This comakership does not offer a monetary bonus upon completion.")
                                                                    .font(.caption)
                                                                    .padding()
                                                                //.frame(alignment: .leading)
                                                            }
                                                            if viewModel.comakerships[i].credits{
                                                                Text("This comakership will award study credit to the participantss.")
                                                                    .font(.caption)
                                                                    .padding()
                                                                //.frame(alignment: .leading)
                                                            } else{
                                                                Text("This comakership will not award study credits to the participants.")
                                                                    .font(.caption)
                                                                    .padding()
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        //.position(x: UIScreen.main.bounds.width/2, y: 0)
                                        .listStyle(PlainListStyle())
                                        .padding()
                                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                                        .padding()
                                        .refreshable{
                                            viewModel.getComakerships()
                                        }
                                        
                                    } else {
                                        // Fallback on earlier versions
                                        
                                    }
                                }
                            }
                            .frame(height: 600)
                            .onAppear{
//                                viewModel.getComakerships()
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Unstarted Comakerships", displayMode: .inline)
        }
    }
}

struct ComakershipsKickoffView_Previews: PreviewProvider {
    static var previews: some View {
        ComakershipsKickoffView()
    }
}
