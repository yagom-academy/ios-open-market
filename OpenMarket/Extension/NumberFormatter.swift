//
//  Formatter.swift
//  OpenMarket
//
//  Created by kjs on 2021/08/27.
//

import Foundation

extension NumberFormatter {
    private static let tool = NumberFormatter()
    static func toDecimal(from int: Int?, withPrefix prefix: String?) -> String? {
        guard let int = int else {
            return nil
        }
        
        let number = NSNumber(value: int)
        tool.numberStyle = .decimal
        let description = tool.string(from: number) ?? int.description
        
        if let prefix = prefix {
            return prefix + description
        } else {
            return description
        }
    }
}
