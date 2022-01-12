//
//  MidProgressView.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 02/01/2022.
//

import SwiftUI

struct MidProgressView: View {
    var body: some View {
        ProgressView("Loading...")
            .position(x: UIScreen.main.bounds.width/2, y: 0)
    }
}

struct MidProgressView_Previews: PreviewProvider {
    static var previews: some View {
        MidProgressView()
    }
}
