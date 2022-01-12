//
//  CompanyMainView.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 09/01/2022.
//

import SwiftUI

struct CompanyMainView: View {
    @ObservedObject var viewModel = CompanyVM.shared
    
    var body: some View {
        if viewModel.companyUser.company == nil || viewModel.companyUser.company!.name == ""{
            NoCompanyView()
                .onAppear{
                    viewModel.getCompany()
                    viewModel.getCompanyLogo()
                }
        }
        else{
            CompanyView()
                .onAppear{
                    viewModel.getCompany()
                    viewModel.getCompanyLogo()
                }
        }
        
    }
}

struct CompanyMainView_Previews: PreviewProvider {
    static var previews: some View {
        CompanyMainView()
    }
}


