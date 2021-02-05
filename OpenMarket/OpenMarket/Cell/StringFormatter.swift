//
//  StringFormatter.swift
//  OpenMarket
//
//  Created by 김태형 on 2021/02/05.
//
import Foundation

extension Int {
    func addComma() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        guard let changedUnit = numberFormatter.string(from: NSNumber(value: self)) else {
            return ""
        }
        return changedUnit
    }
}
