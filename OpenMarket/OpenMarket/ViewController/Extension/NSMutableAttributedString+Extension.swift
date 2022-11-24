//
//  NSMutableAttributedString+Extension.swift
//  OpenMarket
//
//  Created by 써니쿠키, 메네 on 2022/11/23.
//

import UIKit

extension NSMutableAttributedString {
    func strikethrough(string: String) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: string)
        attributedString.addAttribute(NSMutableAttributedString.Key.strikethroughStyle,
                                      value: NSUnderlineStyle.single.rawValue,
                                      range: NSMakeRange(0, attributedString.length))
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor,
                                      value: UIColor.systemRed,
                                      range: NSMakeRange(0, attributedString.length))
        
        return attributedString
    }
    
    func normal(string: String) -> NSMutableAttributedString {
        self.append(NSAttributedString(string: string))
        
        return self
    }
    
    func orangeColor(string: String) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: string)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor,
                                      value: UIColor.systemOrange,
                                      range: NSMakeRange(0, attributedString.length))
        
        return attributedString
    }
}
