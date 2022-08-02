//
//  Data+extension.swift
//  OpenMarket
//
//  Created by groot, bard on 2022/07/31.
//

import Foundation

extension Data {
    mutating func append(_ text: String) {
        guard let data = text.data(using: .utf8) else { return }
        self.append(data)
    }
}
