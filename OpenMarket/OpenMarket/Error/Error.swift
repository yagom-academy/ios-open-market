//
//  Error.swift
//  OpenMarket
//
//  Created by ysp on 2021/06/11.
//

import Foundation

enum invalidError: Error {
    case invalidURL
}

extension invalidError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "유효하지 않은 URL입니다."
        }
    }
}
