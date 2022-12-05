//
//  Data+Extensions.swift
//  OpenMarket
//
//  Created by Mangdi, woong on 2022/12/02.
//

import Foundation

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}
