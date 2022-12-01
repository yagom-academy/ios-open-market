//
//  Data+Extensions.swift
//  OpenMarket
//
//  Created by Mangdi on 2022/12/01.
//

import Foundation

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}
