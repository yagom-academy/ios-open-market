//
//  Data+Extension.swift
//  OpenMarket
//  Created by inho, Hamo, Jeremy on 2022/12/10.
//

import Foundation

extension Data {
    mutating func appendString(_ input: String) {
        if let input = input.data(using: .utf8) {
            self.append(input)
        }
    }
}
