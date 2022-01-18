//
//  ComakershipsSearchView.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 30/12/2020.
//

import SwiftUI

struct ComakershipsSearchView: View {
    @ObservedObject var api = API.shared
    @ObservedObject var viewModel = ComakershipGetVM.shared
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var userInfo: UserInfo
    //gradient werkt alleen in ios 15

    
    var body: some View {
        VStack{
            VStack {
                ZStack{
                    TopRect()
                }
                VStack {
                    //Text("Home")
                    EntryField(symbolName: "exclamationmark.circle", placeHolder: "Search for skill", field: $viewModel.skill, prompt: viewModel.prompt)
                        .offset(y: -50)
                    if viewModel.loading{
                        ProgressView()
                            .padding()
                    }
                    NavigationLink(
                        destination: ComakershipsView(viewModel: viewModel),
                        isActive: $viewModel.fetched,
                        label: {
                            Button(action: {
                                viewModel.getComakershipBySkill()
                                
                                
                            }, label: {
                                Text("Search")
                                    .frame(maxWidth: .infinity, minHeight: 50)
                                    .foregroundColor(.white)
                                    .background(Image("buttonbg"))
                                    .cornerRadius(9.0)
                            })
                        })
                    Spacer()
                    .navigationBarTitle("Search Comakerships", displayMode: .inline)
                }
            }
        }
        .accentColor(.purple)
        .onAppear{
            ApplyVM.shared.teamsvm.getMyTeams()
        }
    }
}

struct ComakershipsSearchView_Previews: PreviewProvider {
    static var previews: some View {
        ComakershipsSearchView()
    }
}
