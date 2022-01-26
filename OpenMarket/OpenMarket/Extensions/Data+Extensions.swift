//
//  Data+Extensions.swift
//  OpenMarket
//
//  Created by 권나영 on 2022/01/19.
//

import Foundation

extension Data {
    mutating func append(_ string: String) {
        guard let data = string.data(using: .utf8) else {
            return
        }
        self.append(data)
    }
}
