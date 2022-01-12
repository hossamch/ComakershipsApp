//
//  ComakershipOverView.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 06/01/2022.
//

import SwiftUI

struct ComakershipOverView: View {
    @ObservedObject var viewModel = EditComakershipVM.shared
    @ObservedObject var filesvm = FilesGetVM.shared
    @ObservedObject var deliverablesvm = DeliverablesVM.shared
    let comakership: ComakershipCGet
    @State var isShowingConfirmAlert = false
    @State var isShowingConfirmAlertForKick = false
    @State var isShowingConfirmAlertForEnd = false
    @State var errorDescription = ""
    @State var studentId: Int? = nil
    @State var studentName: String = ""
    @State var cg: CGFloat = 7.5
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack{
            TopRect()
            if viewModel.kicking{
                MidProgressView()
            } else{
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
                    if deliverablesvm.loading{
                        ProgressView()
                    }
                    Text("Assignments")
                        .padding(.bottom, 4)
                    ForEach(0..<deliverablesvm.deliverables.count, id: \.self) { i in
                        Button(action: {
                            if deliverablesvm.deliverables[i].finished{
                                deliverablesvm.unfinishAssignment(deliverable: deliverablesvm.deliverables[i], comakershipId: comakership.id)
                            } else{
                                deliverablesvm.finishAssignment(deliverable: deliverablesvm.deliverables[i], comakershipId: comakership.id)
                            }
                            
                        }, label: {
                            Text(deliverablesvm.deliverables[i].name)
                                .font(.headline)
                                .fontWeight(.bold)
                                .padding()
                                .background(deliverablesvm.deliverables[i].finished ? Color.green : Color.yellow)
                                .opacity(deliverablesvm.deliverables[i].finished ? 0.5 : 1)
                        })
                    }
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
                                        .font(.caption)
                                        .fontWeight(.bold)
                                    Button(action: {
                                        studentId = viewModel.comakershipMembers.students[mem].id
                                        studentName = viewModel.comakershipMembers.students[mem].name
                                        isShowingConfirmAlertForEnd = false
                                        isShowingConfirmAlertForKick = true
                                        isShowingConfirmAlert = true
                                        
                                    }, label: {
                                        Image(systemName: "minus.square.fill")
                                    })
                                }
                                .padding(3)
                            }
                        } else{
                            Text("This comakership does not have any members yet.")
                        }
                        
                    }
                    
                    NavigationLink(
                        destination: ComakershipsMainView().navigationBarTitle("").navigationBarHidden(true).navigationBarBackButtonHidden(true),
                        isActive: $viewModel.started,
                        label: {
                            Button("End Comakership"){
                                isShowingConfirmAlertForKick = false
                                isShowingConfirmAlertForEnd = true
                                isShowingConfirmAlert = true
                            }
                                .frame(maxWidth: .infinity, minHeight: 50)
                                .foregroundColor(.white)
                                .background(Image("buttonbg"))
                                .cornerRadius(9.0)
                                .alert(isPresented: $isShowingConfirmAlert){
                                    if isShowingConfirmAlertForKick{
                                        return Alert(
                                            title: Text("Kick"),
                                            message: Text("Are you sure you want to kick \(studentName)?"),
                                            primaryButton: .destructive(Text("Kick").foregroundColor(Color.green)) {
                                                viewModel.loading = true
                                                viewModel.kickStudent(comakershipId: self.comakership.id, studentId: self.studentId!){ (result) in
                                                    switch result {
                                                    case .success(let response):
                                                        self.presentationMode.wrappedValue.dismiss()
                                                        print("response: \(response)")
                                                        self.viewModel.kicked = true
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
                                                    self.viewModel.getComakershipMembers(id: comakership.id)
                                                    viewModel.kicking = false
                                                }
                                            },
                                            secondaryButton: .cancel()
                                        )
                                    }
                                    else if isShowingConfirmAlertForEnd{
                                        return Alert(
                                            title: Text("End Comakership"),
                                            message: Text("Are you sure you want to end this comakership?"),
                                            primaryButton: .destructive(Text("End Comakership").foregroundColor(Color.green)) {
                                                viewModel.loading = true
                                                viewModel.startComakership(id: comakership.id, name: comakership.name, description: comakership.description, credits: comakership.credits, bonus: comakership.bonus, comakershipStatusId: 3){ (result) in
                                                    switch result {
                                                    case .success(let response):
                                                        print("response: \(response)")
                                                        self.viewModel.started = true
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
                                                    
                                                    viewModel.loading = false
                                                }
                                                self.presentationMode.wrappedValue.dismiss()
                                            },
                                            secondaryButton: .cancel()
                                        )
                                    }
                                    else{
                                        return Alert(title: Text("Error"), message: Text(errorDescription), dismissButton: .default(Text("OK")))
                                    }
                                }
                                .padding()
                        })
                        .disabled(!viewModel.hasMembers)
                        .opacity(viewModel.hasMembers ? 1 : 0.5)
                }
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                .frame(height: 600)
                .padding(.bottom)
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

struct ComakershipOverView_Previews: PreviewProvider {
    static var previews: some View {
        ComakershipOverView(comakership: ComakershipCGet())
    }
}
