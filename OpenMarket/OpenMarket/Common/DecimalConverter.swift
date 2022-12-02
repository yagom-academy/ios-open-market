//
//  DecimalConverter.swift
//  OpenMarket
//
//  Created by Ayaan, junho on 2022/11/24.
//

import Foundation

enum DecimalConverter {
    static func convert<T: Numeric>(_ number: T) -> String? {
        let numberFormatter: NumberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(for: number)
    }
}
