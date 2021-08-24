//
//  NumberFormatter.swift
//  OpenMarket
//
//  Created by Ellen on 2021/08/24.
//

import Foundation

struct PriceFormatter {
    let iso: String
    let price: Int
    init(iso: String, price: Int) {
        self.iso = iso
        self.price = price
    }
    
    func formatNumber() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = iso
        let number = NSNumber(value: price)
        guard let formattedNumber = formatter.string(from: number) else { fatalError() }
        return formattedNumber
    }
}
