//
//  Int.swift
//  OpenMarket
//
//  Created by Ryan-Son on 2021/05/29.
//

import Foundation

extension Int {
    var decimalStyleFormat: String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        return numberFormatter.string(for: self)
    }
}
