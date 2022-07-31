//
//  Int+extension.swift
//  OpenMarket
//
//  Created by groot, bard on 2022/07/19.
//

import Foundation

extension Double {
    func formatNumber() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        return numberFormatter.string(for: self) ?? ""
    }
}
