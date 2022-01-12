//
//  ComakershipsView.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 31/12/2021.
//

import SwiftUI

struct CompletedComakershipView: View {
    @ObservedObject var viewModel = ComakershipVM.shared
    @State var isActive = false
    @State private var navigateTo = ""
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
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
                        VStack{
                            if viewModel.countFinished == 0{
                                Text("You dont have any completed comakerships yet!")
                                    .frame(height: 600)
                            } else{
                                Group{
                                    Text("Completed Comakerships")
                                        .font(.title)
                                        .fontWeight(.bold)
                                    if #available(iOS 15.0, *) {
                                        List {
                                            ForEach(0..<viewModel.comakerships.count, id: \.self) { i in
                                                if viewModel.comakerships[i].status!.name == "Finished"{
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
                                                                Text("This comakership will award you study credits.")
                                                                    .font(.caption)
                                                                    .padding()
                                                                //.frame(alignment: .leading)
                                                            } else{
                                                                Text("This comakership will not award you study credits.")
                                                                    .font(.caption)
                                                                    .padding()
                                                                //.frame(alignment: .leading)
                                                            }
//                                                            VStack{
//                                                                if viewModel.hasMembers{
//                                                                    Text("Members")
//                                                                        .font(.headline)
//                                                                    ForEach(0..<viewModel.comakershipMembers.students.count, id: \.self){mem in
//                                                                        HStack{
//                                                                            Text("\(viewModel.comakershipMembers.students[mem].name) - \(viewModel.comakershipMembers.students[mem].email)")
//                                                                                .font(.caption)
//                                                                                .fontWeight(.bold)
//                                                                        }
//                                                                        .padding(3)
//
//                                                                    }
//                                                                }
//                                                            }
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
                            
                        }
                        .frame(height: 600)
//                            .padding()
                        .onAppear{
                            
                        }
                    }
                }
            }
            .navigationBarTitle("Your Completed Comakerships", displayMode: .inline)
        }
    }
}

struct CompletedComaerkshipView_Previews: PreviewProvider {
    static var previews: some View {
        CompletedComakershipView()
    }
}

