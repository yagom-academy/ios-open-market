//
//  Data+.swift
//  OpenMarket
//
//  Created by Gundy, Wonbi on 2022/11/29.
//

import Foundation

extension Data {
    mutating func append(_ string: String, using encodingStyle: String.Encoding) {
        guard let data = string.data(using: encodingStyle) else {
            return
        }
        self.append(data)
    }
}
