//
//  Int+Style.swift
//  OpenMarket
//
//  Created by 임성민 on 2021/02/05.
//

import Foundation

extension Int {
    func convertedToStringWithComma() -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value:self))
    }
}
