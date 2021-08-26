//
//  Formatter.swift
//  OpenMarket
//
//  Created by kjs on 2021/08/27.
//

import Foundation

struct PrefixFormatter {
    private static let tool = NumberFormatter()
    
    static func toDecimal(from int: Int) -> String {
        let number = NSNumber(value: int)
        tool.numberStyle = .decimal
        return tool.string(from: number) ?? int.description
    }
}
