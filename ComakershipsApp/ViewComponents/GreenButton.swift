//
//  GreenButton.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 01/01/2022.
//

import SwiftUI

struct GreenButton: View {
    let text: String
    var body: some View {
        Text(text)
            .frame(maxWidth: .infinity, minHeight: 50)
            .foregroundColor(.white)
            .background(Image("buttonbg"))
            .cornerRadius(9.0)
            .padding()
    }
}

struct GreenButton_Previews: PreviewProvider {
    static var previews: some View {
        GreenButton(text: "preview")
    }
}
