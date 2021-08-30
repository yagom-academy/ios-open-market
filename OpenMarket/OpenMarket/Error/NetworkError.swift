//
//  APIError.swift
//  OpenMarket
//
//  Created by 홍정아 on 2021/08/11.
//

import Foundation

enum NetworkError: String, Error {
    case dataNotFound
    case invalidResponse
    case unknownError
    case failToDecode
    case failToInitializeImage
    case thumbnailNotFound
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        return self.rawValue
    }
}
