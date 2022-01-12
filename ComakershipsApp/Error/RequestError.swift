//
//  RequestError.swift
//  ComakershipsApp
//
//  Created by Hossam Chakroun on 11/12/2020.
//

import Foundation

enum RequestError: Error{
    case urlError(URLError)
    case decodingError(DecodingError)
    case genericError(Error)
    case invalidPurchaseKey
//    case wrongPassword
   // case notFound
    
    var errorDescription: String? {
        switch self {
        case .urlError(_):
            return "The server responded with garbage."
        case .decodingError(_):
            return "DecodingError"
        case .genericError(_):
            return "generic error"
        case .invalidPurchaseKey:
            return "The provided purchase key is invalid."
//        case .wrongPassword:
//            return "You entered the wrong password."
//        case .notFound:
//            return "The information you are looking for does not exist."
        }
    }
}

enum RequestErrors: LocalizedError {
    case invalidResponse(Error)
    case unAuthorized(Error)
    case decodingError(Error)
    case encodingError(Error)
    case addressUnreachable(URL, Error)
    case genericError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidResponse(let error):
            return "The server responded with garbage: \(error)"
        case .unAuthorized(let error):
            return "Youre unauthorized: \(error)"
        case .decodingError(let error):
            return "DecodingError: \(error)"
        case .encodingError(let error):
            return "EncodingError: \(error)"
        case .addressUnreachable(let url, let error):
            return "\(url.absoluteString) is unreachable: \(error)"
        case .genericError(_):
            return "Idk wtf happened"
        }
    }
}
