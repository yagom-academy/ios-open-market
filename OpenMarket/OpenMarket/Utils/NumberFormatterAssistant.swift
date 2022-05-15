//
//  NumberFormatterAssistant.swift
//  OpenMarket
//
//  Created by Grumpy, OneTool on 2022/05/15.
//

import Foundation

final class NumberFormatterAssistant {
    static let shared = NumberFormatterAssistant()
    
    private init() { }
    
    private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    func numberFormatString(for value: Double) -> String {
        guard let result = self.numberFormatter.string(for: value) else { return String(value) }
        return result
    }
}
