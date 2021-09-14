//
//  Extension+Data.swift
//  OpenMarket
//
//  Created by 이예원 on 2021/09/06.
//

import Foundation

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
