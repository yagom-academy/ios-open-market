//
//  Double+Extensions.swift
//  OpenMarket
//
//  Created by 웡빙, 보리사랑 on 2022/07/21.
//

import Foundation

extension Double {
    func adoptDecimalStyle() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber.init(value: self)) ?? ""
    }
}
