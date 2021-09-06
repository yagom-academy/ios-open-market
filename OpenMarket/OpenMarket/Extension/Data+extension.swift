//
//  BaseTypeExtension.swift
//  OpenMarket
//
//  Created by tae hoon park on 2021/08/31.
//

import UIKit

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
