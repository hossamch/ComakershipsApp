//
//  CreateTeamView.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 31/12/2021.
//

import SwiftUI

struct CreateTeamView: View {
    @ObservedObject var viewModel: TeamsVM
    @State var isRequestErrorViewPresented: Bool = false
    @State var errorDescription: String = ""
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var userInfo: UserInfo
    
    var body: some View {
        VStack{
            VStack{
                TopRect()
                if viewModel.loadingCreate{
                    ProgressView("One moment please..")
                }
                else{
                    VStack{
                        EntryField(symbolName: "exclamationmark.circle", placeHolder: "Name", field: $viewModel.name, prompt: viewModel.namePrompt)
                        EntryField(symbolName: "exclamationmark.circle", placeHolder: "Description", field: $viewModel.description, prompt: viewModel.descriptionPrompt)
                        
                        
            
                    }
                    //.position(x: UIScreen.main.bounds.width/2, y: 0)
                    .frame(height: 520)
                    .animation(.linear)
                    
                    NavigationLink(
                        destination: MyTeamsView(viewModel: viewModel).navigationBarBackButtonHidden(true).navigationBarTitle("").navigationBarHidden(true),
                        isActive: $viewModel.success,
                        label: {
                            Button(action: {
                                viewModel.loadingCreate = true
                                viewModel.createTeam(){ (result) in
                                    switch result {
                                    case .success(let response):
                                        //self.presentationMode.wrappedValue.dismiss()
                                        errorDescription = "Comakership successfully created!"
                                        print("response: \(response)")
                                        self.viewModel.success = true
                                        self.viewModel.getMyTeams()
                                        //self.isAlerted = true
                                    case .failure(let error):
                                        switch error {
                                        case .urlError(_):
                                            errorDescription = "URL Error"
                                        case .decodingError(_):
                                            errorDescription = "DecodingError"
                                        case .genericError(_):
                                            errorDescription = "GenericError"
                                        case .invalidPurchaseKey:
                                            errorDescription = "The purchase key is invalid."
                                        }
                                        
//                                        self.isAlerted = true
//                                        viewModel.isAlerted = true
                                    }
                                    viewModel.loading = false
                                }
                            }, label: {
                                Text("Create Team")
                                    .frame(maxWidth: .infinity, minHeight: 50)
                                    .foregroundColor(.white)
                                    .background(Image("buttonbg"))
                                    .cornerRadius(9.0)
                                    .opacity(viewModel.complete ? 1 : 0.5)
                            })
                        })
                        .disabled(!viewModel.complete)
                        .padding(.bottom)
                }
            }
            .navigationBarTitle("Create a Comakership", displayMode: .inline)
        }
        .alert(isPresented: $viewModel.success){
            Alert(title: Text("Success"), message: Text("Created"), dismissButton: Alert.Button.default(
                Text("OK"), action: { self.presentationMode.wrappedValue.dismiss() }
            ))
        }
        .padding()
    }
}

struct CreateTeamView_Previews: PreviewProvider {
    static var previews: some View {
        CreateTeamView(viewModel: TeamsVM.shared)
    }
}
