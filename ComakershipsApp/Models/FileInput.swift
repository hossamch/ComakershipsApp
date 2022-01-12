//
//  FileInput.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 06/01/2022.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

struct FileInput: FileDocument{
    // die readablecontenttypes doet nog jack shit
    static var readableContentTypes: [UTType] { [.pdf, .plainText, .text, .flatRTFD, .utf8PlainText] }

    var input: String

    init(input: String) {
        self.input = input
    }

    init(configuration: FileDocumentReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents,
              let string = String(data: data, encoding: .utf8)
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        input = string
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        return FileWrapper(regularFileWithContents: input.data(using: .utf8)!)
    }
}
