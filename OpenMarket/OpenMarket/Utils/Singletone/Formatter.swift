//
//  NumberFormatter.swift
//  OpenMarket
//
//  Created by marlang, Taeangel on 2022/05/18.
//

import Foundation

fileprivate enum Constant {
    static let empty = ""
}

struct Formatter {
    static let numberFormatter = NumberFormatter()
    
    private init() {}

    static func convertNumber(by inputNumber: String?) -> String {
        numberFormatter.numberStyle = .decimal
        
        guard let resultNumber = inputNumber else {
            return Constant.empty
        }
        
        guard let result = numberFormatter.string(for: Int(resultNumber)) else {
            return Constant.empty
        }
        
        return result
    }
}
