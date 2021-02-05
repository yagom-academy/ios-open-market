//
//  String+Style.swift
//  OpenMarket
//
//  Created by 임성민 on 2021/02/05.
//

import UIKit

extension String {
    func strikeThrough() -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue, NSAttributedString.Key.strikethroughColor: UIColor.systemRed, NSAttributedString.Key.foregroundColor: UIColor.systemGray]
        let attributeString = NSAttributedString(string: self, attributes: attributes)
        return attributeString
    }
    
    
}
