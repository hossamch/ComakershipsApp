//
//  ImageUploadView.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 11/01/2022.
//

import SwiftUI

struct ImageUploadView: View {
    @ObservedObject var viewModel = CompanyVM.shared
    @State var isSelecting = false
    @State var selectedImage: Image? = Image("")
    @State var isSelected = false
    @State var uiImage: UIImage? = UIImage(contentsOfFile: "")
    
    var body: some View {
        VStack{
            selectedImage?.resizable().scaledToFit()
            if selectedImage != Image(""){
                Button(action: {
                    uiImage = selectedImage?.asUIImage()
                    viewModel.convertImage(image: uiImage!)
                    viewModel.uploadImage()
                }, label: {
                    PurpleButton(text: "Upload Company Image")
                })
            }
            
            
            Button(action: {
                isSelecting = true
            }, label: {
                GreenButton(text: "Select Company Image")
            })
        }
        .sheet(isPresented: $isSelecting, content: {
            ImagePicker(image: $selectedImage)
        })
    }
}

struct ImageUploadView_Previews: PreviewProvider {
    static var previews: some View {
        ImageUploadView()
    }
}
