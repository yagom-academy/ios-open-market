//
//  Data+Extension.swift
//  OpenMarket
//
//  Created by 김준건 on 2021/08/17.
//

import Foundation

extension Data {
    mutating func append(_ newElement: String) {
        newElement.data(using: .utf8).flatMap { append($0) }
    }
}
