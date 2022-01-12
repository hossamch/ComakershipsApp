//
//  ComakershipOverView.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 31/12/2021.
//

import SwiftUI

struct ComakershipsKickoffView2: View {
    @State var comakership: ComakershipCGet
    @ObservedObject var viewModel = EditComakershipVM.shared
    @ObservedObject var inboxvm = InboxVM.shared
    @State var studentId: Int? = nil
    @State var studentName: String = ""
    @State var isShowingConfirmAlert = false
    @State var isShowingConfirmAlertForKick = false
    @State var errorDescription: String = ""
    @State var isAlerting: Bool = false
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    //hier alle info met comakership progress.
    var body: some View {
        VStack {
            TopRect()
            VStack(alignment: .trailing) {
                    ScrollView{
                        Text("\(viewModel.editedComakership?.name ?? comakership.name)")
                            .font(.title2)
                            .fontWeight(.bold)
                          //  .frame(width: 320,alignment: .topLeading)
                            .padding()
                        Text(viewModel.editedComakership?.description ?? comakership.description)
                            .font(.subheadline)
                            .fontWeight(.light)
                            .padding()
                           // .frame(width: 350,alignment: .topLeading)
                        
                        Text("Deliverables: ")
                            .padding(.bottom, 4)
                        ForEach(0..<comakership.deliverables.count, id: \.self) { i in
                            Text(comakership.deliverables[i]!.name)
                                .font(.caption)
                                .fontWeight(.bold)
                        }
                        .padding()
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                        
                        Text("Required skills: ")
                            .padding(.top)
                        ForEach(0..<comakership.skills.count, id: \.self) { i in
                            Text(comakership.skills[i].name)
                                .font(.caption)
                                .fontWeight(.bold)
                        }
                        .padding()
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                        
                        if viewModel.editedComakership?.bonus ?? comakership.bonus{
                            Text("This comakership offers a monetary bonus upon completion.")
                                .font(.caption)
                                .fontWeight(.ultraLight)
                                .padding()
                                .frame(width: 300, alignment: .leading)
                        } else{
                            Text("This comakership does not offer a monetary bonus upon completion.")
                                .font(.caption)
                                .fontWeight(.ultraLight)
                                .padding()
                                .frame(width: 300, alignment: .leading)
                        }
                        if viewModel.editedComakership?.credits ?? comakership.credits{
                            Text("This comakership will award study credits to the participants.")
                                .font(.caption)
                                .fontWeight(.ultraLight)
                                .padding()
                                .frame(width: 300, alignment: .leading)
                        } else{
                            Text("This comakership will not award study credits to the participants.")
                                .font(.caption)
                                .fontWeight(.ultraLight)
                                .padding()
                                .frame(width: 300, alignment: .leading)
                        }
                        VStack{
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
                                            isShowingConfirmAlert = false
                                            isShowingConfirmAlertForKick = true
                                            isAlerting = true
                                            
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
                                Button("Start Comakership"){
                                    isShowingConfirmAlertForKick = false
                                    isShowingConfirmAlert = true
                                    isAlerting = true
                                }
                                    .frame(maxWidth: .infinity, minHeight: 50)
                                    .foregroundColor(.white)
                                    .background(Image("buttonbg"))
                                    .cornerRadius(9.0)
//                                    .alert(isPresented: $isShowingConfirmAlert){
//                                        Alert(
//                                            title: Text("Start comakership"),
//                                            message: Text("Are you sure you want to start this comakership?"),
//                                            primaryButton: .default(Text("Start").foregroundColor(Color.green)) {
//                                                viewModel.loading = true
//                                                viewModel.startComakership(id: comakership.id, name: comakership.name, description: comakership.description, credits: comakership.credits, bonus: comakership.bonus, comakershipStatusId: 2){ (result) in
//                                                    switch result {
//                                                    case .success(let response):
//                                                        self.presentationMode.wrappedValue.dismiss()
//                                                        print("response: \(response)")
//                                                        self.viewModel.started = true
//                                                        self.viewModel.loading = false
//                                                        self.viewModel.isAlerted = true
//                                                        errorDescription = "Comakership successfully created!"
//                                                    case .failure(let error):
//                                                        switch error {
//                                                        case .urlError(_):
//                                                            errorDescription = "URL Error"
//                                                        case .decodingError(_):
//                                                            errorDescription = "DecodingError"
//                                                        case .genericError(_):
//                                                            errorDescription = "GenericError"
//                                                        case .invalidPurchaseKey:
//                                                            errorDescription = "The purchase key is invalid."
//                                                        }
//
//                                                        viewModel.isAlerted = true
//                                                    }
//                                                    viewModel.loading = false
//                                                }
//                                            },
//                                            secondaryButton: .cancel()
//                                        )
//                                    }
//                                    .padding()
                            })
                            .disabled(!viewModel.hasMembers)
                            .opacity(viewModel.hasMembers ? 1 : 0.5)
                    }
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
    
                    .navigationBarItems(trailing: NavigationLink(
                        destination: EditComakershipView(id: comakership.id, name: comakership.name, description: comakership.description, credits: comakership.credits, bonus: comakership.bonus, comakershipStatusId: comakership.status!.id),
                            label: {
                                Text("Edit")
                                    .foregroundColor(.blue)
                                    //.opacity(api.isAuthenticated ? 0 : 1)
                            }
                    ))
                
                
                .frame(height: 600)
                .padding()
                .alert(isPresented: $isAlerting){
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
                    else{
                        return Alert(
                            title: Text("Start comakership"),
                            message: Text("Are you sure you want to start this comakership?"),
                            primaryButton: .default(Text("Start").foregroundColor(Color.green)) {
                                viewModel.loading = true
                                viewModel.startComakership(id: comakership.id, name: comakership.name, description: comakership.description, credits: comakership.credits, bonus: comakership.bonus, comakershipStatusId: 2){ (result) in
                                    switch result {
                                    case .success(let response):
                                        self.presentationMode.wrappedValue.dismiss()
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
                                    self.presentationMode.wrappedValue.dismiss()
                                    viewModel.loading = false
                                }
                            },
                            secondaryButton: .cancel()
                        )
                    }
                }
            }
            .onAppear{
                viewModel.checkChanges(comakership: comakership)
            }
//            .alert(isPresented:$viewModel.isAlerted) {
//                if viewModel.started{
//                    return Alert(title: Text("Success"), message: Text("Comakership succesfully started, good luck!"), dismissButton: .default(Text("OK")))
//                } else{
//                    return Alert(
//                        title: Text("Start comakership"),
//                        message: Text("Are you sure you want to start this comakership?"),
//                        primaryButton: .default(Text("Start")) {
//
//                        },
//                        secondaryButton: .cancel()
//                    )
//                }
//            }
            
        }
        .navigationBarTitle("Your Comakerships", displayMode: .inline)
        .onAppear{
            self.viewModel.getComakershipMembers(id: comakership.id)
        }
    }
}

struct ComakershipsKickoffView2_Previews: PreviewProvider {
    static var previews: some View {
        ComakershipsKickoffView2(comakership: ComakershipCGet())
    }
}
