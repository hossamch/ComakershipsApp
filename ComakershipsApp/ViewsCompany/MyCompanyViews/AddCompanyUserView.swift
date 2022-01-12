//
//  AddCompanyUserView.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 08/01/2022.
//

import SwiftUI

struct AddCompanyUserView: View {
    @ObservedObject var viewModel = AddCompanyUserVM.shared
    @State var errorDescription = ""
    let companyId: Int
    let companyName: String
    
    var body: some View {
        VStack{
            VStack{
                TopRect()
                
                if viewModel.loading{
                    MidProgressView()
                } else{
                    VStack{
                        EntryField(symbolName: "exclamationmark.circle", placeHolder: "Enter email", field: $viewModel.email, isEmail: true, prompt: viewModel.prompt)
                            .padding()
                        
                        
                        CheckBox(checked: $viewModel.isAdmin)
                        Text("Should the user become an admin?")
                            .font(.caption)
                        
                        Button(action: {
                            self.viewModel.addCompanyUser(id: companyId){ (result) in
                                switch result {
                                case .success(let response):
                                    print("response: \(response)")
                                    //self.viewModel.applied = true
                                    self.viewModel.loading = false
                                    self.viewModel.isAlerted = true
                                    errorDescription = "Comakership successfully created!"
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
                                    
                                    viewModel.isAlerted = true
                                }
                            }
                        }, label: {
                            GreenButton(text: "Add User")
                        })
                            .opacity(viewModel.validateEmail ? 1 : 0.5)
                            .disabled(!viewModel.validateEmail)
                    }
                    .frame(height: 600)
                    .alert(isPresented: $viewModel.isAlerted){
                        if viewModel.added{
                            return Alert(title: Text("Success"), message: Text("\(viewModel.email) has been added to your company."), dismissButton: .default(Text("OK")))
                        }
                        return Alert(title: Text("Attention"), message: Text("\"\(viewModel.email)\" could not be found"), dismissButton: .default(Text("OK")))
                    }
                    .onAppear{
                        viewModel.getTopLevel(name: companyName)
                    }
                    
                    .navigationBarTitle("Add Company User", displayMode: .inline)
                }
            }
        }
    }
}

struct AddCompanyUserView_Previews: PreviewProvider {
    static var previews: some View {
        AddCompanyUserView(companyId: 0, companyName: "default")
    }
}
