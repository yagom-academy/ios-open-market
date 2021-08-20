//
//  Data+Extension.swift
//  OpenMarket
//
//  Created by 김준건 on 2021/08/17.
//

import Foundation

extension Data {
    func appending(_ newElement: String) -> Data {
        var copyData = self
        newElement.data(using: .utf8).flatMap { copyData.append($0) }
        return copyData
    }
}
