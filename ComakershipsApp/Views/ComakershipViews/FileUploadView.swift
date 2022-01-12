//
//  FileUploadView.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 07/01/2022.
//

import SwiftUI

struct FileUploadView: View {
    let viewModel: FilesVM
    let id: Int
    @State private var isImporting = false
    @State var file = URL(string: "")
    @State var filedata = Data()

    let fileUrl = Bundle.main.path(forResource: "Resume", ofType: "pdf")

    var body: some View {
        VStack{
            //Text("File: \(try String(contentsOf: (file! )) catch{print("nigger")})")
            Button(action: {
                    isImporting = true
                }) {
                    PurpleButton(text: "Import file")
                }
                .fileImporter(
                    isPresented: $isImporting,
                    allowedContentTypes: [.image, .jpeg, .png],
                    allowsMultipleSelection: false
                ) { result in
                    if case .success = result {
                        do {
                            let fileURL: URL = try result.get().first!
                            viewModel.filePath = fileURL
                            viewModel.fileData = try result.get().first!.dataRepresentation
                            viewModel.fileName = fileURL.relativePath
                            viewModel.isFileSelected = true
                            
                            //viewModel.fileName = fileURL.
                            
    //                        let audioURL: URL = try result.get().first!
    //
    //                        let audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
    //                        audioPlayer.delegate = ...
    //                        audioPlayer.prepareToPlay()
    //                        audioPlayer.play() // ← ERROR raised here

                        } catch {
                            let nsError = error as NSError
                            fatalError("File Import Error \(nsError), \(nsError.userInfo)")
                        }
                    } else {
                        print("File Import Failed")
                    }
                }
            if viewModel.isFileSelected{
                Text(viewModel.fileName)
                    .font(.headline)
                    .padding()
                Button(action: {
                    viewModel.uploadFile(id: id){ (result) in
                        
                    }
                }, label: {
                    GreenButton(text: "Upload file")
                })
            }
        }
    }
}

struct FileUploadView_Previews: PreviewProvider {
    static var previews: some View {
        FileUploadView(viewModel: FilesVM.shared, id: 0)
    }
}
