//
//  RedButton.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 02/01/2022.
//

import SwiftUI

struct RedButton: View {
    let text: String
    
    var body: some View {
        Text(text)
            .frame(maxWidth: .infinity, minHeight: 50)
            .foregroundColor(.white)
            .background(Image("redbuttonbg"))
            .cornerRadius(9.0)
            .padding()
    }
}

struct RedButton_Previews: PreviewProvider {
    static var previews: some View {
        RedButton(text: "preview")
    }
}
