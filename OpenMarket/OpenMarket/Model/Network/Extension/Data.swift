//
//  Data.swift
//  OpenMarket
//
//  Created by 윤재웅 on 2021/05/20.
//

import Foundation

extension Data {
    mutating func append(_ string: String) {
        guard let data = string.data(using: .utf8) else { return }
        self.append(data)
    }
}
