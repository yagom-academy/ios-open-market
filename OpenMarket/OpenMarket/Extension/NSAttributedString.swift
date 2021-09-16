//
//  NSAttributedString.swift
//  OpenMarket
//
//  Created by 박태현 on 2021/09/16.
//

import Foundation

extension NSAttributedString {
    static func + (lhs: NSAttributedString, rhs: String) -> NSAttributedString {
        let rhs = NSAttributedString(string: rhs)
        let resultString = NSMutableAttributedString()
        resultString.append(lhs)
        resultString.append(rhs)
        return resultString
    }
}
