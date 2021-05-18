//
//  Data.swift
//  OpenMarket
//
//  Created by 배은서 on 2021/05/18.
//

import Foundation

extension Data {
    mutating func appendString(_ string: String) {
        guard let data = string.data(using: .utf8) else { return }
        self.append(data)
    }
}
