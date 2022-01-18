//
//  ComakershipOverView.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 06/01/2022.
//

import SwiftUI

struct ComakershipUploadView: View {
    @ObservedObject var viewModel = EditComakershipVM.shared
    @ObservedObject var filesvm = FilesGetVM.shared
    @ObservedObject var uploadvm = FilesVM.shared
    @ObservedObject var deliverablesvm = DeliverablesVM.shared
    let comakership: ComakershipCGet
    @State var isShowingConfirmAlert = false
    @State var isShowingConfirmAlertForLeave = false
    @State var errorDescription = ""
    @State var studentId: Int? = nil
    @State var studentName: String = ""
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack{
            TopRect()
            if uploadvm.loading{
                MidProgressView()
            }
            else if viewModel.loading{
                MidProgressView()
            }
            else{
                ScrollView{
                    Text("\(comakership.name)")
                        .font(.title2)
                        .fontWeight(.bold)
                      //  .frame(width: 320,alignment: .topLeading)
                        .padding()
                    ComakershipProgressBar(percentage: $deliverablesvm.progress)
                        .padding()
                        .animation(.spring())
                    
                    
                    Text(comakership.description)
                        .font(.subheadline)
                        .fontWeight(.light)
                        .padding()
                       // .frame(width: 350,alignment: .topLeading)
                    
                    Text("Deliverables: ")
                        .padding(.bottom, 4)
                    ForEach(0..<deliverablesvm.deliverables.count, id: \.self) { i in
                        Text(deliverablesvm.deliverables[i].name)
                            .font(.headline)
                            .fontWeight(.bold)
                            .padding()
                            .background(deliverablesvm.deliverables[i].finished ? Color.green : Color.yellow)
                            
                    }
                    //.padding()
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                    
                    VStack{
                        if !filesvm.hasFiles{
                            Text("There are no files uploaded yet!")
                                .padding()
                        }
                        else{
                            //show files
                        }
                    }
                    
                    VStack{
                        if viewModel.fetchingStudents{
                            ProgressView("Fetching..")
                                .padding()
                        }
                        if viewModel.hasMembers{
                            Text("Members")
                                .font(.headline)
                            ForEach(0..<viewModel.comakershipMembers.students.count, id: \.self){mem in
                                HStack{
                                    Text("\(viewModel.comakershipMembers.students[mem].name) - \(viewModel.comakershipMembers.students[mem].email)")
                                }
                                .padding(3)
                            }
                        } else{
                            Text("This comakership does not have any members yet.")
                        }
                        
                    }
                    VStack{
                        if deliverablesvm.progress == 1.0{
                            Text("The comakership has been completed!")
                                .font(.headline)
                                .padding()
                            
                            Text("Write a review")
                                .fontWeight(.bold)
                            EntryField(symbolName: "info", placeHolder: "Give your experience a review.", field: $uploadvm.review, isLarge: true, prompt: uploadvm.reviewPrompt)
                            
                            Picker("Rating", selection: $uploadvm.rating){
                                Text("Rating").tag(nil as Int?)
                                    .foregroundColor(.red)
                                
                                ForEach(1...10, id: \.self){ it in
                                    Text(String(it)).tag(it as Int?)
                                }
                            }
                            .padding(10)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                            
                            
                            Button(action: {
                                uploadvm.sendReview(companyId: comakership.company.id, studentUserId: Int(API.shared.userId!)!)
                                isShowingConfirmAlertForLeave = false
                                isShowingConfirmAlert = true
                                
                            }, label: {
                                GreenButton(text: "Send Review")
                                    .opacity(uploadvm.reviewComplete ? 1 : 0.5)
                            })
                                .disabled(!uploadvm.reviewComplete)
                        }
                    }
                    .padding()
                    
                    VStack{
                        if deliverablesvm.progress != 1.0{
                            FileUploadView(viewModel: uploadvm, id: comakership.id)
                            
                        }
                    }
                    
                    
                    .alert(isPresented: $isShowingConfirmAlert){
                        if isShowingConfirmAlertForLeave{
                            return Alert(
                                title: Text("Leave Comakership"),
                                message: Text("Are you sure you want to leave \(comakership.name)?"),
                                primaryButton: .destructive(Text("Leave")) {
                                    viewModel.loading = true
                                    viewModel.leaveComakership(comakershipId: self.comakership.id){ (result) in
                                        switch result {
                                        case .success(let response):
                                            self.presentationMode.wrappedValue.dismiss()
                                            print("response: \(response)")
                                            self.viewModel.kicked = true
                                            self.viewModel.loading = false
                                            self.viewModel.isAlerted = true
                                            errorDescription = "You have left the comakership."
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
                                        self.viewModel.getComakershipMembers(id: comakership.id)
                                        viewModel.kicking = false
                                    }
                                },
                                secondaryButton: .cancel()
                            )
                        } else{
                            return Alert(title: Text("Success"), message: Text("Review Sent"), dismissButton: .default(Text("OK")))
                        }
                    }
                    
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Leave"){
                                isShowingConfirmAlertForLeave = true
                                isShowingConfirmAlert = true
                            }
                            .foregroundColor(.red)
                        }
                    }
                    
            }
                        
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                .frame(height: 600)
                .onAppear{
                    self.viewModel.getComakershipMembers(id: comakership.id)
                    self.deliverablesvm.getDeliverables(id: comakership.id)
                }
                
//                .alert(isPresented: $viewModel.isAlerted){
//                    if viewModel.kicked{
//                        return Alert(title: Text("Success"), message: Text("Comakership succesfully created!"), dismissButton: .default(Text("OK")))
//                    }else{
//                        return Alert(title: Text("Attention"), message: Text(errorDescription), dismissButton: .default(Text("OK")))
//                    }
//                }
            }
            
        }
        .navigationBarTitle("Overview", displayMode: .inline)
        
    }
}

struct ComakershipUploadView_Previews: PreviewProvider {
    static var previews: some View {
        ComakershipUploadView(comakership: ComakershipCGet())
    }
}
