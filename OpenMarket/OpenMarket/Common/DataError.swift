//
//  DataError.swift
//  OpenMarket
//
//  Created by Kyo, LJ on 2022/11/14.
//

import Foundation

enum DataError: Error {
    case empty
    case decoding
    case unknown
}

extension DataError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .empty:
            return "None Data Error"
        case .decoding:
            return "Decoding Error"
        case .unknown:
            return "Unknown Error"
        }
    }
}
