//
//  String+Extension.swift
//  OpenMarket
//
//  Created by 써니쿠키, 메네 on 2022/12/02.
//

import UIKit

extension String {
    func applyHangulAttribute() -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        
        if #available(iOS 14.0, *) {
            paragraphStyle.lineBreakStrategy = .hangulWordPriority
        }
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.preferredFont(forTextStyle: .body),
            .paragraphStyle: paragraphStyle
        ]
        
        return NSAttributedString(string: self, attributes: attributes)
    }
}
