//
//  NoCompanyView.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 09/01/2022.
//

import SwiftUI

struct NoCompanyView: View {
    var body: some View {
        NavigationView{
            VStack{
                TopRect()
                
                Text("You are not part of a company yet!")
                    .frame(height: 600)
            }
            .navigationBarTitle("Your Company", displayMode: .inline)
        }
    }
}

struct NoCompanyView_Previews: PreviewProvider {
    static var previews: some View {
        NoCompanyView()
    }
}
