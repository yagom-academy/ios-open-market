//
//  Data.swift
//  OpenMarket
//
//  Created by KimJaeYoun on 2021/08/13.
//

import Foundation

extension Data {
    mutating func append(_ string: String) {
        string.data(using: .utf8).flatMap {
            append($0)
        }
    }
}
