//
//  DecodingError+.swift
//  OpenMarket
//
//  Created by Gundy, Wonbi on 2022/11/21.
//

import Foundation

extension DecodingError {
    var errorDescription: String? {
        switch self {
        case .typeMismatch(let type, let context):
            return "type mismatch for type \(type) in JSON: \(context.debugDescription)"
        case .valueNotFound(let type, let context):
            return "could not find type \(type) in JSON: \(context.debugDescription)"
        case .keyNotFound(let key, let context):
            return "could not find key \(key) in JSON: \(context.debugDescription)"
        case .dataCorrupted(let context):
            return "data found to be corrupted in JSON: \(context.debugDescription)"
        @unknown default:
            return localizedDescription
        }
    }
}
