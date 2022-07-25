//
//  Int+Extensions.swift
//  OpenMarket
//
//  Created by 데릭, 케이, 수꿍. 
//

import Foundation

extension Int {
    func numberFormatter() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        return numberFormatter.string(from: NSNumber(value: self))!
    }
}
