//
//  CompanyView.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 24/12/2021.
//

import SwiftUI

struct CompanyView: View {
    @ObservedObject var api = API.shared
    @ObservedObject var viewModel = CompanyVM.shared
    let loader = ImageVM()
    @State var isLoggingin: Bool = false
    @State var errorDescription: String = ""
    @State var isRequestErrorViewPresented: Bool = false
    @State var successful: Bool = false;
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body : some View{
        NavigationView{
            VStack{
                TopRect()
                VStack{
                    VStack{
                        if UIImage(data: loader.loadImage(url: viewModel.companyUser.company!.logoGuid!)) != nil{
                            HStack{
                                Image(uiImage: UIImage(data: loader.loadImage(url: viewModel.companyUser.company!.logoGuid!))!)
                                    .padding()
                                Text(viewModel.companyUser.company!.name)
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                            }
                            
                        } else{
                            HStack{
                                Image(systemName: "photo")
                                    .resizable()
                                    .frame(width: 50, height: 50, alignment: .leading)
                                    .padding()
                                Text(viewModel.companyUser.company!.name)
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                            }
                            
                        }
                    }
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                    
                    Text(viewModel.companyUser.company!.description)
                        .font(.subheadline)
                        .padding()
                    Spacer()
                    VStack{
                        Text("Reviews")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        if viewModel.companyUser.company!.reviews == nil{
                            Text("Your company does not have any reviews yet!")
                        } else{
                            ForEach(0..<viewModel.companyUser.company!.reviews!.count, id: \.self){i in
                                HStack{
                                    Text("\(viewModel.companyUser.company!.reviews![i].reviewersName)")
                                        .font(.headline)
                                    Text("Rating: \(viewModel.companyUser.company!.reviews![i].rating)")
                                        .font(.headline)
                                }
                                Text("\(viewModel.companyUser.company!.reviews![i].comment)")
                                    .font(.subheadline)
                            }
                        }
                    }
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                    Spacer()
                 //   Text(viewModel.companyUser.company.reviews)
                    ImageUploadView()
                }
                .frame(height: 600)
                .onAppear{
                    viewModel.getCompanyLogo()
                }
            }
            
            .navigationBarTitle("Your Company", displayMode: .inline)
            .navigationBarItems(trailing: NavigationLink(destination: AddCompanyUserView(companyId: viewModel.companyUser.companyId!, companyName: viewModel.companyUser.company!.name)) {
                Image(systemName: "person.badge.plus")
                    .foregroundColor(.purple)
            })
        }
        .accentColor(.purple)
    }
}

struct CompanyView_Previews: PreviewProvider {
    static var previews: some View {
        CompanyView()
    }
}
