//
//  Int+extension.swift
//  OpenMarket
//
//  Created by dhoney96 on 2022/07/28.
//

import Foundation

extension Int {
    func formatNumber() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        guard let number = numberFormatter.string(for: self) else { return "" }
        return number
    }
}
