//
//  Double+Extension.swift
//  OpenMarket
//
//  Created by 노유빈 on 2022/11/23.
//

import Foundation

extension Double {
    var formattedString: String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal

        guard let string = numberFormatter.string(for: self) else {
            return nil
        }
        return string
    }
}
