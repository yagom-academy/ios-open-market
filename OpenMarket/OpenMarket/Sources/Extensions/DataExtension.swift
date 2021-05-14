//
//  DataExtension.swift
//  OpenMarket
//
//  Created by duckbok on 2021/05/14.
//

import Foundation

extension Data {
    mutating func append(_ other: String) {
        guard let validData = other.data(using: .utf8) else { return }

        self.append(validData)
    }
}
