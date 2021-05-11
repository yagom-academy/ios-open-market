//
//  decodeError.swift
//  OpenMarket
//
//  Created by 최정민 on 2021/05/11.
//

import Foundation

enum DecodeError: Error {
    case requestHeader
}

extension DecodeError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .requestHeader:
            return "message: Content-Type of request header must be multipart/form-data"
        }
    }
}
