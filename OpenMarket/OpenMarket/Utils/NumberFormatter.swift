//
//  NumberFormatter.swift
//  OpenMarket
//
//  Created by 김동욱 on 2022/05/18.
//

import Foundation

struct Formatter {
    static let numberFormatter = NumberFormatter()
    static func convertNumber(by inputNumber: String?) -> String {
        numberFormatter.numberStyle = .decimal
        guard let resultNumber = inputNumber else {
            return ""
        }
        guard let result = numberFormatter.string(for: Int(resultNumber)) else {
            return ""
        }
        return result
    }
    private init() {}
}

