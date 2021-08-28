//
//  Formatter.swift
//  OpenMarket
//
//  Created by kjs on 2021/08/27.
//

import Foundation

extension NumberFormatter {
    func toDecimalString(from int: Int) -> String {
        numberStyle = .decimal
        
        let number = NSNumber(value: int)
        let description = string(from: number) ?? int.description
        
        return description
    }
}
