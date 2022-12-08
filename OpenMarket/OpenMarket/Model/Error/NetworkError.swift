//
//  NetworkError.swift
//  OpenMarket
//  Created by inho, Hamo, Jeremy on 2022/11/15.
//

import Foundation

enum NetworkError: Error {
    case transportError
    case serverError
    case missingData
    case failedToParse
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .transportError:
            return NSLocalizedString("transport error", comment: "transport error")
        case .serverError:
            return NSLocalizedString("server error", comment: "server error")
        case .missingData:
            return NSLocalizedString("missing data", comment: "missing data")
        case .failedToParse:
            return NSLocalizedString("failed to parse", comment: "failed to parse")
        }
    }
}
