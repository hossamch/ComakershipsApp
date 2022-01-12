//
//  ComakershipSummaryView.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 07/01/2022.
//

import SwiftUI

struct ComakershipSummaryView: View {
    @ObservedObject var viewModel = ComakershipVM.shared
    
    
    var body: some View {
        NavigationView{
            VStack {
                TopRect()
                VStack {
                    if (viewModel.loading){
                        ProgressView("Loading..")
                            .position(x: UIScreen.main.bounds.width/2, y: 0)
                    }
                    else{
                        if (viewModel.countStarted == 0){
                            Text("You have yet to participate in a comakerships!")
                                .position(x: UIScreen.main.bounds.width/2, y: 0)
                        } else{
                            VStack{
                                Group{
                                    Text("Your Comakerships")
                                        .font(.title)
                                        .fontWeight(.bold)
                                    if #available(iOS 15.0, *) {
                                        List {
                                            ForEach(0..<viewModel.comakerships.count, id: \.self) { i in
                                                if viewModel.comakerships[i].status!.name == "Started"{
                                                    // hier andere info showen.
                                                    NavigationLink(destination: ComakershipUploadView(comakership: viewModel.comakerships[i])){
                                                        VStack{
                                                            Text("\(viewModel.comakerships[i].name)")
                                                                .font(.title2)
                                                                .fontWeight(.bold)
                                                                .padding()
                                                            Text(viewModel.comakerships[i].description)
                                                                .font(.subheadline)
                                                                .fontWeight(.light)
                                                                .padding()
                                                            if viewModel.comakerships[i].bonus{
                                                                Text("This comakership offers a monetary bonus upon completion.")
                                                                    .font(.caption)
                                                                    .padding()
                                                            } else{
                                                                Text("This comakership does not offer a monetary bonus upon completion.")
                                                                    .font(.caption)
                                                                    .padding()
                                                            }
                                                            if viewModel.comakerships[i].credits{
                                                                Text("This comakership will award you study credits.")
                                                                    .font(.caption)
                                                                    .padding()
                                                            } else{
                                                                Text("This comakership will not award you study credits.")
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
                        }
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: ComakershipsSearchView()) {
                            Image(systemName: "magnifyingglass")
                                .font(.title)
                        }
            
                    }
                }
            }
            .navigationBarTitle("Your Comakerships", displayMode: .inline)
            .onAppear{
                viewModel.getComakerships()
            }
        }
    }
}

struct ComakershipSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        ComakershipSummaryView()
    }
}
