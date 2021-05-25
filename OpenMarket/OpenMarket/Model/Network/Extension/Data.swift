//
//  Data.swift
//  OpenMarket
//
//  Created by Hailey, Ryan on 2021/05/18.
//

import Foundation

extension Data {
    mutating func append(_ string: String) {
        guard let data = string.data(using: .utf8) else { return }
        self.append(data)
    }
}
