//
//  ComakershipsView.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 31/12/2021.
//

import SwiftUI

struct ComakershipsMainView: View {
    @ObservedObject var viewModel = ComakershipVM.shared
    @State var isActive = false
    @State private var navigateTo = ""
    
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
                            Text("You dont have any active comakerships yet!")
                                .position(x: UIScreen.main.bounds.width/2, y: 0)
                        } else{
                            VStack{
                                Group{
                                    Text("Active Comakerships")
                                        .font(.title)
                                        .fontWeight(.bold)
                                    if #available(iOS 15.0, *) {
                                        List {
                                            ForEach(0..<viewModel.comakerships.count, id: \.self) { i in
                                                if viewModel.comakerships[i].status!.name == "Started"{
                                                    // vanaf hier naar de comakership progressview.
                                                    NavigationLink(destination: ComakershipOverView(comakership: viewModel.comakerships[i])){
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
//                                Group{
//                                    Text("Started")
//                                }
                            }
                            .frame(height: 600)
//                            .padding()
                        }
                    
                    }
                }
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        if #available(iOS 15.0, *) {
                            Menu {
                                Button("Create") {
                                    self.navigateTo = "c"
                                    self.isActive = true
                                }
                                Button("Kick-off") {
                                    self.navigateTo = "k"
                                    self.isActive = true
                                }
                                Button("Finished") {
                                    self.navigateTo = "f"
                                    self.isActive = true
                                }
                            } label: {
                                //Text("open menu")
                                Label("Create Comakership", systemImage: "ellipsis")
                                
                            }
                            .background{
                                if navigateTo == "c" && CompanyVM.shared.companyUser.company != nil && CompanyVM.shared.companyUser.isCompanyAdmin{
                                    NavigationLink(destination: ComakershipsCreateView(), isActive: $isActive) {
                                        //ComakershipsCreateView()
                                    }
                                }else if navigateTo == "k"{
                                    NavigationLink(destination: ComakershipsKickoffView(), isActive: $isActive) {
                                        //ComakershipsCreateView()
                                    }
                                } else if navigateTo == "f"{
                                    NavigationLink(destination: CompletedComakershipView(), isActive: $isActive) {
                                        //ComakershipsCreateView()
                                    }
                                }
                            }
                            
                        } else {
                            // Fallback on earlier versions
                        }
                                        
                                        
                    }
                }
                
            }
            .navigationBarTitle("Your Comakerships", displayMode: .inline)
            .onAppear{
                if CompanyVM.shared.companyUser.company != nil{
                    viewModel.getComakerships()
                }
            }
        }
    }
}

struct ComakershipsMainView_Previews: PreviewProvider {
    static var previews: some View {
        ComakershipsMainView()
    }
}

enum ComakershipStatusEnum: String{
    case status
}
