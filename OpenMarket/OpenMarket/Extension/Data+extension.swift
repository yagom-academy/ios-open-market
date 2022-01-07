//
//  Data+extension.swift
//  OpenMarket
//
//  Created by 이호영 on 2022/01/04.
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
