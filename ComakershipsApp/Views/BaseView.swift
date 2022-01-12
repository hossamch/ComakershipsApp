//
//  BaseView.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 21/12/2020.
//

import SwiftUI

struct BaseView<Content:View>: View {
    let content: Content
    
    init(@ViewBuilder content:()->Content){
        self.content = content()
    }
    
    var body: some View {
        VStack{
            HStack{
                Rectangle()
            }.foregroundColor(.green)
            .frame(width: .infinity, height: 120, alignment: .center)
            .ignoresSafeArea(.all, edges: .top)
            
            Image("comakerships.png")
            
            Spacer()
        }
        .foregroundColor(.green)

        content
        //Divider()
        //Spacer()
    }
}

struct BaseView_Previews: PreviewProvider {
    static var previews: some View {
        BaseView{
            Text("hi")
        }
    }
}
