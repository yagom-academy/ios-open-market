//
//  String+Extensions.swift
//  OpenMarket
//
//  Created by 데릭, 수꿍.
//

import Foundation

extension String {
    func strikeThrough(value: Int) -> NSAttributedString {
        let attributeString = NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle,
                                     value: value,
                                     range: NSMakeRange(0,
                                                        attributeString.length))
        
        return attributeString
    }
    
    func convertToInt() -> Int {
        guard let convertedString = Int(self) else {
            return 0
        }
        
        return convertedString
    }
    
    func convertToOptionalInt() -> Int? {
        guard let convertedString = Int(self) else {
            return nil
        }
        
        return convertedString
    }
}
