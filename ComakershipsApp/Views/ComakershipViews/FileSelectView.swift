//
//  FileSelectView.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 06/01/2022.
//

import SwiftUI

struct FileSelectView: View {
    @State private var document: FileInput = FileInput(input: "")
    @State private var isImporting: Bool = false
    //@State var isExporting: Bool = false
    lazy var applicationSupportURL: URL = {
            let urls = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)
            return urls[0]
    }()

    
    var body: some View {
        VStack {
            GroupBox(label: Text("File:")) {
                //TextEditor(text: $document.input)
                Text(document.input)
            }
            GroupBox {
                Button(action: { isImporting = true }, label: {
                    GreenButton(text: "Upload file")
                })
            }
        }
        .padding()
//        .fileExporter(
//              isPresented: $isExporting,
//              document: document,
//              contentType: .plainText,
//              defaultFilename: "'filename'"
//          ) { result in
//              if case .success = result {
//                  // Handle success.
//              } else {
//                  // Handle failure.
//              }
//          }
          .fileImporter(
              isPresented: $isImporting,
              allowedContentTypes: [.plainText, .pdf, .utf16ExternalPlainText],
              allowsMultipleSelection: false
          ) { result in
              do {
                  guard let selectedFile: URL = try result.get().first else { return }
                  guard let message = String(data: try Data(contentsOf: selectedFile), encoding: .utf8) else { return }

                  document.input = message
              } catch {
                  // Handle failure.
              }
          }
        
    }
}

struct FileSelectView_Previews: PreviewProvider {
    static var previews: some View {
        FileSelectView()
    }
}














//VStack {
//    GroupBox(label: Text("Message:")) {
//        TextEditor(text: $document.input)
//    }
//    GroupBox {
//        HStack {
//            Spacer()
//
//            Button(action: { isImporting = true }, label: {
//                Text("Import")
//            })
//
//            Spacer()
//
//            Button(action: { isExporting = true }, label: {
//                Text("Export")
//            })
//
//            Spacer()
//        }
//    }
//}
//.padding()
//.fileExporter(
//      isPresented: $isExporting,
//      document: document,
//      contentType: .plainText,
//      defaultFilename: "'filename'"
//  ) { result in
//      if case .success = result {
//          // Handle success.
//      } else {
//          // Handle failure.
//      }
//  }
//  .fileImporter(
//      isPresented: $isImporting,
//      allowedContentTypes: [.plainText, .pdf, .utf16ExternalPlainText],
//      allowsMultipleSelection: false
//  ) { result in
//      do {
//          guard let selectedFile: URL = try result.get().first else { return }
//          guard let message = String(data: try Data(contentsOf: selectedFile), encoding: .utf8) else { return }
//
//          document.input = message
//      } catch {
//          // Handle failure.
//      }
//  }













//        HStack {
//            Button(action: { isImporting = true}, label: {
//                GreenButton(text: "File Upload")
//            })
//            Text(document.input)
//        }
//        .padding()
//        .fileImporter(
//            isPresented: $isImporting,
//            allowedContentTypes: [.plainText],
//            allowsMultipleSelection: false
//        ) { result in
//            do {
//                guard let selectedFile: URL = try result.get().first else { return }
//                if selectedFile.startAccessingSecurityScopedResource() {
//                    guard let input = String(data: try Data(contentsOf: selectedFile), encoding: .utf8) else { return }
//                    defer { selectedFile.stopAccessingSecurityScopedResource() }
//                    document.input = input
//                } else {
//                    // Handle denied access
//                }
//            } catch {
//                // Handle failure.
//                print("Unable to read file contents")
//                print(error.localizedDescription)
//            }
//        }
//        .fileExporter(
//              isPresented: $isExporting,
//              document: document,
//              contentType: .plainText,
//              defaultFilename: "Message"
//          ) { result in
//              if case .success = result {
//                  // Handle success.
//              } else {
//                  // Handle failure.
//              }
//          }
