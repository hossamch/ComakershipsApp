//
//  FormPicker.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 29/12/2021.
//

import SwiftUI

struct FormPicker: View {
    @State private var selectedStrength = "Mild"
    let strengths = ["Mild", "Medium", "Mature"]
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Strength", selection: $selectedStrength) {
                        ForEach(strengths, id: \.self) {
                            Text($0).tag($0)
                        }
                    }
                }
            }
        }
    }
}

struct FormPicker_Previews: PreviewProvider {
    static var previews: some View {
        FormPicker()
    }
}
