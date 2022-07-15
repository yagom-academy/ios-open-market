//
//  APIError.swift
//  OpenMarket
//
//  Created by Derrick kim on 2022/07/11.
//

import Foundation

enum APIError: Error, LocalizedError {
    case invalidURL
    case failedToDecode
    case jsonFileNotFound
    case networkConnectionIsBad
    case unknownErrorOccured
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "URL is not valid."
        case .failedToDecode:
            return "Falied to decode response data."
        case .jsonFileNotFound:
            return "JSON file not found."
        case .networkConnectionIsBad:
            return "Network connection is bad."
        case .unknownErrorOccured:
            return "Unknown error occured."
        }
    }
}
