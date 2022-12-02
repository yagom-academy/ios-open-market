//
//  Data+.swift
//  OpenMarket
//
//  Created by Ayaan, junho on 2022/12/02.
//

import Foundation

extension Data {
    mutating public func append(_ newElement: String) {
        if let newData: Data = newElement.data(using: .utf8) {
            self.append(newData)
        }
    }
}
