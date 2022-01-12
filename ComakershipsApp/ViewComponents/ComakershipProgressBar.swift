//
//  ComakershipProgressBar.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 08/01/2022.
//

import SwiftUI

struct ComakershipProgressBar: View {
    var finished: Color? = nil
    @Binding var percentage: CGFloat
    
    
    var body: some View {
        ZStack(alignment: .leading){
            ZStack(alignment: .trailing){
                Capsule()
                    .fill(.black.opacity(0.08))
                    .frame(height: 22)
                Text(String(format: "%.0f", percentage*100) + "%").font(.caption).foregroundColor(.gray.opacity(0.75)).padding(.trailing)
            }
            Capsule()
                .fill(getGradient())
                .frame(width: self.getProgress(), height: 22)
        }
        .padding(18)
        .background(Color.black.opacity(0.085))
        .cornerRadius(15)
    }
    
    func getProgress() -> CGFloat{
        return ((UIScreen.main.bounds.width - 66) * self.percentage)
    }
    
    func getGradient() -> LinearGradient{
        if self.percentage == 1.0{
            return LinearGradient(colors: [.green], startPoint: .leading, endPoint: .trailing)
        }
        return LinearGradient(colors: [.red, .yellow, .green], startPoint: .leading, endPoint: .trailing)
    }
}

//struct ComakershipProgressBar_Previews: PreviewProvider {
//    static var previews: some View {
//        ComakershipProgressBar(percentage: $0)
//    }
//}
