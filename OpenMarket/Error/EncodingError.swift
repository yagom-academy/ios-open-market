//
//  EncodingError.swift
//  OpenMarket
//
//  Created by 최정민 on 2021/05/15.
//

import Foundation

enum EncodingError: Error {
    case invalidParameter
}

extension EncodingError: LocalizedError {
    var errorDescription: String? {
        return "Error: Invalid Parameter"
    }
}
