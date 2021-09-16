//
//  Int.swift
//  OpenMarket
//
//  Created by 박태현 on 2021/09/16.
//

import Foundation

extension Int {
    var withDigit: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let result = numberFormatter.string(for: self) ?? ""
        return result
    }
}
