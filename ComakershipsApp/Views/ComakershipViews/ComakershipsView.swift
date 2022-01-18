//
//  ComakershipsView.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 28/12/2021.
//

import SwiftUI

struct ComakershipsView: View {
    let viewModel: ComakershipGetVM
    
    var body: some View {
        VStack{
            TopRect()
            if viewModel.comakerships.count == 0{
                Text("Sorry, but there aren't any comakerships based on your request.")
                    .padding()
                    .position(x: UIScreen.main.bounds.width/2, y: 0)
            }
            else{
                if #available(iOS 15.0, *) {
                    List {
                        ForEach(0..<viewModel.comakerships.count, id: \.self) { i in
                            NavigationLink(destination: ComakershipApplyView(comakership: viewModel.comakerships[i])){
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
                                }
                            }

                        }
                    }
                    //.position(x: UIScreen.main.bounds.width/2, y: 0)
                    .frame(height: 600)
                    .listStyle(PlainListStyle())
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                    .padding()
                    .refreshable{
                        viewModel.getComakershipBySkill()
                    }
                } else {
                    // Fallback on earlier versions
                    
                }
            }
        }
        .navigationBarTitle("Results")
        .accentColor(.purple)
    }
}

struct ComakershipsView_Previews: PreviewProvider {
    static var previews: some View {
        ComakershipsView(viewModel: ComakershipGetVM.shared)
    }
}
