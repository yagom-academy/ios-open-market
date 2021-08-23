//
//  Data+Extensions.swift
//  OpenMarket
//
//  Created by Luyan, Ellen on 2021/08/20.
//

import Foundation

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
