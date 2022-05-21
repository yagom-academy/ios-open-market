//
//  Encodable+extension.swift
//  OpenMarket
//
//  Created by dudu, safari on 2022/05/16.
//

import Foundation

extension Encodable {
    func encodeData() -> Data? {
        return try? JSONEncoder().encode(self)
    }
}
