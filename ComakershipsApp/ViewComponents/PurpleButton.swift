//
//  PurpleButton.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 01/01/2022.
//

import SwiftUI

struct PurpleButton: View {
    let text: String
    var body: some View {
        Text(text)
            .frame(maxWidth: .infinity, minHeight: 50)
            .foregroundColor(.white)
            .background(Image("purplebuttonbg"))
            .cornerRadius(9.0)
            .padding()
    }
}

struct PurpleButton_Previews: PreviewProvider {
    static var previews: some View {
        PurpleButton(text: "preview")
    }
}
