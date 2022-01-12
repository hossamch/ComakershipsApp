//
//  TopRect.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 29/12/2021.
//

import SwiftUI

struct TopRect: View {
    var body: some View {
        Rectangle()
            .fill(Color.clear)
            .frame(width: UIScreen.main.bounds.width, height: 100)
            .background(Image("newtopbg")
                            .resizable()
                            .ignoresSafeArea())
            .ignoresSafeArea()
            .position(x: UIScreen.main.bounds.width/2, y: 0)
    }
}

struct TopRect_Previews: PreviewProvider {
    static var previews: some View {
        TopRect()
    }
}
