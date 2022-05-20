//
//  NumberFormatterAssistant.swift
//  OpenMarket
//
//  Created by Grumpy, OneTool on 2022/05/15.
//

import Foundation

extension NumberFormatter {
    func numberFormatString(for value: Double) -> String {
        self.numberStyle = .decimal
        guard let result = self.string(for: value) else { return String(value) }
        return result
    }
}
