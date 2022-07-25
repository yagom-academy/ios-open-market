//
//  NetworkError.swift
//  OpenMarket
//
//  Created by 데릭, 케이, 수꿍.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case failedToDecode
    case jsonFileNotFound
    case emptyData
    case unknownErrorOccured
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "URL is not valid."
        case .failedToDecode:
            return "Falied to decode response data."
        case .jsonFileNotFound:
            return "JSON file not found."
        case .emptyData:
            return "There is no data."
        case .unknownErrorOccured:
            return "Unknown error occured."
        }
    }
}
