//
//  Data+Extension.swift
//  OpenMarket
//
//  Created by 우롱차, Donnie on 2022/06/01.
//

import Foundation

extension Data {
    mutating func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}
