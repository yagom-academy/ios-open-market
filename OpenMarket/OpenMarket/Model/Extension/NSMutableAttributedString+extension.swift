//
//  NSMutableAttributedString+extension.swift
//  OpenMarket
//
//  Created by groot, bard on 2022/07/19.
//

import UIKit

extension NSMutableAttributedString {
    func makePriceText(string: String) -> NSMutableAttributedString {
        let attributes: [NSAttributedString.Key: Any] =
        [
            .font: UIFont.preferredFont(forTextStyle: .footnote),
            .strikethroughStyle: NSUnderlineStyle.single.rawValue,
            .foregroundColor: UIColor.systemRed
        ]
        self.append(NSAttributedString(string: string, attributes: attributes))
        return self
    }
    
    func makeBargainPriceText(string: String) -> NSMutableAttributedString {
        let attributes: [NSAttributedString.Key: Any] =
        [
            .font: UIFont.preferredFont(forTextStyle: .footnote),
            .foregroundColor: UIColor.systemGray
        ]
        self.append(NSAttributedString(string: string, attributes: attributes))
        return self
    }
}
