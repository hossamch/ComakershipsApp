//
//  ComakershipsCreateView3.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 30/12/2021.
//

import SwiftUI

struct ComakershipsCreateView3: View {
    @ObservedObject var viewModel: CreateComakershipVM
    @ObservedObject var api = API.shared
    
    @State var isRequestErrorViewPresented: Bool = false
    @State var errorDescription: String = ""
    @State var finished = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack{
            //TopRect()
            
            List {
                ForEach(0..<viewModel.skills.count, id: \.self) { i in
                    if #available(iOS 15.0, *) {
                        Text("\(viewModel.skills[i].name)")
                            .swipeActions(edge: .trailing) {
                                    Button(role: .destructive, action: {viewModel.removeSkill(name: viewModel.skills[i].name) } ) {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                       } else {
                    // Fallback on earlier versions
                    }
                }
            }
            Form {
                Section(header: Text("Skill to Add")) {
                    HStack {
                        TextField("Skill", text: $viewModel.skill)
                            //.keyboardType(.numberPad)
                        Button(action: {
                            viewModel.addSkill()
                            viewModel.isAddingSkill = true
                        }) {
                            Text("Add")
                        }
                    }

                }
            }
            .frame(height: 150)
//            HStack{
//                Button(action: {
//                    viewModel.isAddingSkill = true
//                }) {
//                    Image(systemName: "plus.square.fill")
//                        .padding(3)
//                }
//
//                Button(action: {
//                    viewModel.removeSkills()
//                }) {
//                    Image(systemName: "minus.square.fill")
//                        .padding(3)
//                }
//            }
            
            Text("Swipe to delete a skill.")
                .font(.caption)
            
            Button(action: {
                viewModel.createComakership(){ (result) in
                    switch result {
                    case .success(_):
                        self.finished = true
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
                    }
                }
//                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                GreenButton(text: "Create Comakership")
                    .opacity(viewModel.partThreeComplete ? 1 : 0.5)
            })
            .disabled(!viewModel.partThreeComplete)

        }.alert(isPresented: $viewModel.isAlerted){
            if viewModel.success{
                return Alert(title: Text("Success"), message: Text("Comakership succesfully created!"), dismissButton: .default(Text("OK")))
            }else{
                return Alert(title: Text("Attention"), message: Text(errorDescription), dismissButton: .default(Text("OK")))
            }
        }
        .padding()
        .navigationBarItems(leading: Text(""))
    }
}

struct ComakershipsCreateView3_Previews: PreviewProvider {
    static var previews: some View {
        ComakershipsCreateView3(viewModel: CreateComakershipVM.shared)
    }
}
