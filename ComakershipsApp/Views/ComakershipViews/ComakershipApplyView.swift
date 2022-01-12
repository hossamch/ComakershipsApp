//
//  ComakershipApplyView.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 01/01/2022.
//

import SwiftUI

struct ComakershipApplyView: View {
    let comakership: ComakershipSearch
    @ObservedObject var viewModel = ApplyVM.shared
    @State var errorDescription: String = ""
    @State var isShowingConfirmAlert: Bool = false
    @State var isApplied = false
    @State var isAlerted = false
    @State var message = "Are you sure you want to join this comakership by yourself?"
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack {
            TopRect()
            VStack(alignment: .trailing) {
                    ScrollView{
                        Text("\(comakership.name)")
                            .font(.title2)
                            .fontWeight(.bold)
                          //  .frame(width: 320,alignment: .topLeading)
                            .padding()
                        Text(comakership.description)
                            .font(.subheadline)
                            .fontWeight(.light)
                            .padding()
                           // .frame(width: 350,alignment: .topLeading)
                        
                        Text("Required skills: ")
                            .padding(.top)
                        ForEach(0..<comakership.skills.count, id: \.self) { i in
                            Text(comakership.skills[i].name)
                                .font(.caption)
                                .fontWeight(.bold)
                        }
                        .padding()
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                        
                        if comakership.bonus{
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
                        if comakership.credits{
                            Text("This comakership will award you study credits.")
                                .font(.caption)
                                .fontWeight(.ultraLight)
                                .padding()
                                .frame(width: 300, alignment: .leading)
                        } else{
                            Text("This comakership will not award you study credits.")
                                .font(.caption)
                                .fontWeight(.ultraLight)
                                .padding()
                                .frame(width: 300, alignment: .leading)
                        }
                        
                        Picker("Select Team to Apply", selection: $viewModel.currentlySelectedTeam){
                            Text("Select Your Team").tag(nil as Int?)
                            
                            ForEach(0..<viewModel.teamsvm.myTeams.count){ i in
                                Text(viewModel.teamsvm.myTeams[i].team.name).tag(viewModel.teamsvm.myTeams[i].teamId as Int?)
                                    .onAppear{
                                        for teamapplication in viewModel.appl{
                                            for appl in teamapplication{
                                                if appl.comakershipId != comakership.id{
                                                    continue
                                                }
                                                if viewModel.currentlySelectedTeam == appl.teamId && appl.comakershipId == comakership.id{
                                                    self.isApplied = true
                                                }
                                                else{
                                                    self.isApplied = false
                                                }
                                            }
                                        }
                                    }
                            }
                        }
                        .padding(10)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                        .onReceive([self.viewModel.currentlySelectedTeam].publisher.first()) { (value) in
                            //dit wordt elke ker gexececute als picker value changed
                                    print(value)
                        }
                    
                        Text(viewModel.teamPrompt)
                            .font(.caption)
                        Spacer()
                        
                        if (isApplied){
                            Button(action: {
                                viewModel.status = ApplyStatus.Default
                                isAlerted = true
                            }
                            ,label: {
                                RedButton(text: "Cancel")
                                    .opacity(viewModel.complete ? 1 : 0.5)
                                    .padding()
                            })
                                .disabled(!viewModel.complete)
                                .opacity(viewModel.complete ? 1 : 0.5)
                            
                        } else{
                            Button(action: {
                                viewModel.status = ApplyStatus.Default
                                isAlerted = true
                            }
                            ,label: {
                                GreenButton(text: "Apply")
                                    .opacity(viewModel.complete ? 1 : 0.5)
                                    .padding()
                            })
                                .disabled(!viewModel.complete)
                                .opacity(viewModel.complete ? 1 : 0.5)
                        }
                    }
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
    
                        
                .frame(height: 600)
                .padding()
            }
            .alert(isPresented:$isAlerted) {
                if viewModel.status == ApplyStatus.Applied{
                    if viewModel.currentIndex != nil{
                        return Alert(title: Text("Success"), message: Text("You have successfully applied to the comakership with team \(viewModel.teamsvm.myTeams[viewModel.currentIndex!].team.name)!"), dismissButton: .default(Text("OK")))
                    }
                    return Alert(title: Text("Success"), message: Text("You have successfully applied to the comakership by yourself!!"), dismissButton: .default(Text("OK")))
                }else if viewModel.status == ApplyStatus.Canceled{
                    return Alert(title: Text("Success"), message: Text("You have canceled your application"), dismissButton: .default(Text("OK")))
                }else if !isApplied{
                   // if viewModel.currentIndex != nil{ message = "Are you sure you want to request to join this comakership with \(viewModel.teamsvm.myTeams[viewModel.currentIndex!].team.name)?"}
                    if viewModel.teamsvm.myTeams[viewModel.currentIndex!].team.name == API.shared.userFullName{
                        return Alert(
                            title: Text("Apply"),
                            message: Text("Are you sure you want to request to join this comakership by yourself?"),
                            primaryButton: .default(Text("Confirm").foregroundColor(Color.green)) {
                                viewModel.loading = true
                                viewModel.applyForComakership(comakershipId: comakership.id){ (result) in
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
                                viewModel.status = ApplyStatus.Applied
                                isAlerted = true
                                viewModel.loading = false
                                self.presentationMode.wrappedValue.dismiss()
                            },
                            secondaryButton: .cancel()
                        )
                    }
                    return Alert(
                        title: Text("Apply"),
                        message: Text("Are you sure you want to request to join this comakership with \(viewModel.teamsvm.myTeams[viewModel.currentIndex!].team.name)?"),
                        primaryButton: .default(Text("Confirm").foregroundColor(Color.green)) {
                            viewModel.loading = true
                            viewModel.applyForComakership(comakershipId: comakership.id){ (result) in
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
                            viewModel.status = ApplyStatus.Applied
                            isAlerted = true
                            viewModel.loading = false
                            self.presentationMode.wrappedValue.dismiss()
                        },
                        secondaryButton: .cancel()
                    )
                }
                else{
                    if viewModel.teamsvm.myTeams[viewModel.currentIndex!].team.name == API.shared.userFullName{
                        return Alert(
                            title: Text("Cancel"),
                            message: Text("Are you sure you want to cancel your application?"),
                            primaryButton: .default(Text("Confirm").foregroundColor(Color.green)) {
                                viewModel.loading = true
                                viewModel.cancelApplicationForComakership(comakershipId: comakership.id){ (result) in
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
                                viewModel.status = ApplyStatus.Canceled
                                isAlerted = true
                                viewModel.loading = false
                                self.presentationMode.wrappedValue.dismiss()
                            },
                            secondaryButton: .cancel()
                        )
                    }
                    return Alert(
                        title: Text("Cancel"),
                        message: Text("Are you sure you want to cancel your application? with \(viewModel.teamsvm.myTeams[viewModel.currentIndex!].team.name)"),
                        primaryButton: .default(Text("Confirm").foregroundColor(Color.green)) {
                            viewModel.loading = true
                            viewModel.cancelApplicationForComakership(comakershipId: comakership.id){ (result) in
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
                            viewModel.status = ApplyStatus.Canceled
                            isAlerted = true
                            viewModel.loading = false
                            self.presentationMode.wrappedValue.dismiss()
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
            
        }
        .onAppear{
            viewModel.refresh()
            //viewModel.teamsvm.getMyTeams()
        }
        .navigationBarTitle("Your Comakerships", displayMode: .inline)
        
    }
}

struct ComakershipApplyView_Previews: PreviewProvider {
    static var previews: some View {
        ComakershipApplyView(comakership: ComakershipSearch())
    }
}
