//
//  Int+.swift
//  OpenMarket
//
//  Created by Wonbi on 2022/11/22.
//

extension Int {
    var isZero: Bool {
        return self == 0
    }
    
    var decimal: Int {
        return String(self).count
    }
}
