//
//  Formatter.swift
//  OpenMarket
//
//  Created by kjs on 2021/08/27.
//

import Foundation

extension NumberFormatter {
    func toDecimal(from int: Int?, withPrefix prefix: String?) -> String? {
        guard let int = int else {
            return nil
        }
        
        numberStyle = .decimal
        
        let number = NSNumber(value: int)
        let description = string(from: number) ?? int.description
        
        if let prefix = prefix {
            return prefix + description
        } else {
            return description
        }
    }
}
