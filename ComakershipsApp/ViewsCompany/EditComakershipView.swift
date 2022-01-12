//
//  EditComakershipView.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 06/01/2022.
//

import SwiftUI

struct EditComakershipView: View {
    @ObservedObject var viewModel = EditComakershipVM.shared
    @State var id: Int
    @State var name: String
    @State var description: String
    @State var credits: Bool
    @State var bonus: Bool
    @State var comakershipStatusId: Int
    @State var namePrompt = ""
    @State var descriptionPrompt = ""
    @State var errorDescription = ""
    @State var errorAlert = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack{
            TopRect()
            if viewModel.editing{
                MidProgressView()
                    .navigationBarTitle("Edit Comakership", displayMode: .inline)
            } else{
                VStack{
                    EntryField(symbolName: "exclamationmark.circle", placeHolder: "Name", field: $name, prompt: namePrompt)
                        .onChange(of: name){value in
                            if name == ""{
                                namePrompt = "Please enter a name for your comakership."
                            }else{namePrompt = ""}
                        }
                    EntryField(symbolName: "exclamationmark.circle", placeHolder: "Description", field: $description, prompt: descriptionPrompt)
                        .onChange(of: description){value in
                            if description == ""{
                                descriptionPrompt = "Please enter a name for your comakership."
                            }else{descriptionPrompt = ""}
                        }
                    
                    HStack{
                        CheckBox(checked: $bonus)
                            .padding(15)
                            .padding(.bottom, -15)
                        //Spacer()
                        
                    }
                    Text("Will this comakership award a monetary bonus to the participants?")
                        .font(.caption)
                    
                    HStack{
                        CheckBox(checked: $credits)
                            .padding(15)
                            .padding(.bottom, -15)
                        //Spacer()
                        
                    }
                    Text("Will the comakership yield study points for the participants?")
                        .font(.caption)
                    
                    
                    NavigationLink(
                        destination: ComakershipsMainView().navigationBarTitle("").navigationBarHidden(true).navigationBarBackButtonHidden(true),
                        isActive: $viewModel.loading,
                        label: {
                            Button("Edit Comakership"){
                                //isShowingConfirmAlert = true
                                viewModel.editComakership(id: id, name: name, description: description, credits: credits, bonus: bonus, comakershipStatusId: comakershipStatusId){result in
                                    switch result {
                                    case .success(let response):
                                        self.presentationMode.wrappedValue.dismiss()
                                        print("response: \(response)")
                                        self.viewModel.editing = false
                                        self.viewModel.isAlertedEdited = true
                                        errorDescription = "Comakership successfully created!"
                                    case .failure(let error):
                                        switch error {
                                        case .urlError(_):
                                            errorDescription = "Something went wrong with your connection, try again later."
                                            self.errorAlert = true
                                        case .decodingError(_):
                                            errorDescription = "DecodingError"
                                            self.errorAlert = true
                                        case .genericError(_):
                                            errorDescription = "Something went wrong with your connection, try again later."
                                            self.errorAlert = true
                                        case .invalidPurchaseKey:
                                            errorDescription = "The purchase key is invalid."
                                            self.errorAlert = true
                                        }
                                        
                                        viewModel.isAlertedEdited = true
                                    }
                                    viewModel.editing = false
                                }
                            }
                                .frame(maxWidth: .infinity, minHeight: 50)
                                .foregroundColor(.white)
                                .background(Image("buttonbg"))
                                .cornerRadius(9.0)
                        })
                        .disabled(name == "" || description == "")
                        .opacity(name == "" || description == "" ? 0.5 : 1)
                    
                }
                .frame(height: 600)
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                .alert(isPresented: $viewModel.isAlertedEdited){
                    if errorAlert{
                        return Alert(title: Text("Error"), message: Text(errorDescription), dismissButton: .default(Text("OK")))
                    }
                    return Alert(title: Text("Success"), message: Text("Saved!"), dismissButton: .default(Text("OK")))
                }
                .navigationBarTitle("Edit Comakership", displayMode: .inline)
            }
            
            
            
        }
    }
}

struct EditComakershipView_Previews: PreviewProvider {
    static var previews: some View {
        EditComakershipView(id: 0, name: "Defaultname", description: "defaultdescription", credits: true, bonus: true, comakershipStatusId: 0)
    }
}
