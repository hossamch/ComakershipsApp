//
//  EntryField.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 20/12/2021.
//

import SwiftUI

struct EntryField: View{
    var symbolName: String
    var placeHolder: String
    @Binding var field: String
    var isSecure: Bool = false
    var isEmail: Bool = false
    var isLarge: Bool = false
    var required: Bool = false
    var prompt: String
    
    var body: some View{
        VStack(alignment: .leading){
            HStack{
                Image(systemName: symbolName)
                    .foregroundColor(.gray)
                    .font(.headline)
                if isSecure{
                    SecureField(placeHolder, text: $field).autocapitalization(.none)
                } else if isEmail{
                    TextField(placeHolder, text: $field).autocapitalization(.none)
                        .keyboardType(.emailAddress)
                } else if isLarge{
                    List{
                        ZStack{
                            TextEditor(text: $field).autocapitalization(.sentences)
                            Text(field).opacity(0).padding(.all, 8)
                        }
                        
                    }
                    .listStyle(PlainListStyle())
                    .frame(height: 200)
                    //.frame(maxHeight: 150)
//                    .shadow(radius: 1)
                } else{
                    TextField(placeHolder, text: $field).autocapitalization(.sentences)
                }
            }
            .padding(15)
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
            Text(prompt)
                .font(.caption)
        }
        .padding(.leading)
        .padding(.trailing)
    }
}
