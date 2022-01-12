//
//  ComakershipsCreateView.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 22/12/2021.
//

import SwiftUI

struct ComakershipsCreateView: View {
    @ObservedObject var api = API.shared
    @ObservedObject var viewModel = CreateComakershipVM.shared
    @State var clicked: Bool = false
    @State var finished: Bool = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack{
            VStack{
                TopRect()
                if viewModel.loading{
                    ProgressView("One moment please..")
                }
                else{
                    ScrollView{
                        EntryField(symbolName: "exclamationmark.circle", placeHolder: "Name", field: $viewModel.name, prompt: viewModel.namePrompt)
                        EntryField(symbolName: "exclamationmark.circle", placeHolder: "Description", field: $viewModel.description, prompt: viewModel.desciptionPrompt)
                        EntryField(symbolName: "exclamationmark.circle", placeHolder: "Purchase Key", field: $viewModel.purchaseKey, isSecure: true, prompt: viewModel.purchaseKeyPrompt)
                        
                        
                        Picker("Program", selection: $viewModel.currentlySelectedProgram){
                            Text("Select Specified Study").tag(nil as Int?)
                                .foregroundColor(.red)
                            
                            ForEach(viewModel.programs){ it in
                                Text(it.name).tag(it.id as Int?)
                            }
                        }
                        .padding(10)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                        Text(viewModel.programPrompt)
                            .font(.caption)
                        
                        HStack{
                            CheckBox(checked: $viewModel.bonus)
                                .padding(15)
                                .padding(.bottom, -15)
                            //Spacer()
                            
                        }
                        Text("Will this comakership award a monetary bonus to the participants?")
                            .font(.caption)
                        
                        HStack{
                            CheckBox(checked: $viewModel.credits)
                                .padding(15)
                                .padding(.bottom, -15)
                            //Spacer()
                            
                        }
                        Text("Will the comakership yield study points for the participants?")
                            .font(.caption)
                        
            
                    }
                    //.position(x: UIScreen.main.bounds.width/2, y: 0)
                    .frame(height: 520)
                    .animation(.linear)
                    
                    NavigationLink(
                        destination: ComakershipsCreateView2(viewModel: viewModel).navigationBarTitle("Deliverables"),
                        isActive: $clicked,
                        label: {
                            Button(action: {
                                clicked = true
                                
                            }, label: {
                                Text("Next")
                                    .frame(maxWidth: .infinity, minHeight: 50)
                                    .foregroundColor(.white)
                                    .background(Image("buttonbg"))
                                    .cornerRadius(9.0)
                                    .opacity(viewModel.partOneComplete ? 1 : 0.5)
                            })
                        })
                        .disabled(!viewModel.partOneComplete)
                        .padding(.bottom)
                }
            }
            .navigationBarTitle("Create a Comakership", displayMode: .inline)
            .onAppear{
                if viewModel.success{
                //    viewModel.success = false
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
        }
        
    }
}

struct ComakershipsCreateView_Previews: PreviewProvider {
    static var previews: some View {
        ComakershipsCreateView()
    }
}
