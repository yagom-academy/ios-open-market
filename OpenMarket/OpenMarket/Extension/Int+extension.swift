//
//  Int+extension.swift
//  OpenMarket
//
//  Created by tae hoon park on 2021/09/07.
//

import Foundation

extension Int {
    var withComma: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let result = numberFormatter.string(for: self) ?? ""
        return result
    }
}
