//
//  ComakershipsCreateView2.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 29/12/2021.
//

import SwiftUI

struct ComakershipsCreateView2: View {
    @ObservedObject var viewModel: CreateComakershipVM
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack{
            List {
                ForEach(0..<viewModel.deliverables.count, id: \.self) { i in
                    if #available(iOS 15.0, *) {
                        Text("\(viewModel.deliverables[i].name)")
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive, action: {print(viewModel.deliverables[i]); viewModel.removeDeliverable(name: viewModel.deliverables[i].name) } ) {
                                Label("Delete", systemImage: "trash")
                              }
                            }
                        
                        
                        
                        
                    } else {
                        // Fallback on earlier versions
                    }
                }
            }
            Form {
                Section(header: Text("Deliverable to Add")) {
                    HStack {
                        TextField("Deliverable", text: $viewModel.deliverable)
                            //.keyboardType(.numberPad)
                        Button(action: {
                            viewModel.addDeliverable()
                            viewModel.isAddingDeliverable = true
                        }) {
                            Text("Add")
                        }
                    }

                }
            }
            .frame(height: 150)
//            HStack{
//                Button(action: {
//                    viewModel.isAddingDeliverable = true
//                }) {
//                    Image(systemName: "plus.square.fill")
//                        .padding(3)
//                }
//
//                Button(action: {
//                    viewModel.removeDeliverables()
//                }) {
//                    Image(systemName: "minus.square.fill")
//                        .padding(3)
//                }
//            }
            
            Text("Swipe to delete a deliverable.")
                .font(.caption)
            
            
            NavigationLink(
                destination: ComakershipsCreateView3(viewModel: viewModel).navigationBarTitle("Skills"),
                label: {
                    Text("Next")
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .foregroundColor(.white)
                        .background(Image("buttonbg"))
                        .cornerRadius(9.0)
                        .padding(.bottom, 10)
                        .opacity(viewModel.partTwoComplete ? 1 : 0.5)
                }
            )
                .disabled(!viewModel.partTwoComplete)
        }
    }
}

struct ComakershipsCreateView2_Previews: PreviewProvider {
    static var previews: some View {
        ComakershipsCreateView2(viewModel: CreateComakershipVM.shared)
    }
}
