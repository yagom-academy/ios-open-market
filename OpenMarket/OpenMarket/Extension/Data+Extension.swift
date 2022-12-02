//
//  Data+Extension.swift
//  OpenMarket
//
//  Created by leewonseok on 2022/12/02.
//

import Foundation

extension Data {
    mutating func append(_ str: String) {
        if let data = str.data(using: .utf8) {
            self.append(data)
        }
    }
}

