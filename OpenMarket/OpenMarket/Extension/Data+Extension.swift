//
//  Data+Extension.swift
//  OpenMarket
//
//  Created by 이승재 on 2022/01/08.
//

import Foundation

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}
