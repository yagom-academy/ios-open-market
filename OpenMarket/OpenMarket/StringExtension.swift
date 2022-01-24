//
//  StringExtension.swift
//  OpenMarket
//
//  Created by 서녕 on 2022/01/21.
//

import Foundation

extension String {
    func insertComma() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        guard let doublaValue = Double(self),
              let insertedCommaDouble = numberFormatter.string(from: NSNumber(value: floor(doublaValue))) else {
         return  ""
        }
            return insertedCommaDouble
    }
    
}
