//
//  UILabel+Extension.swift
//  OpenMarket
//
//  Created by Red, Mino on 2022/05/16.
//

import UIKit

extension UILabel {
    func addStrikeThrough() {
        guard let text = self.text else { return }
        
        let strikeThroughAttributedString = NSAttributedString(
            string: text,
            attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue]
        )
        self.attributedText = strikeThroughAttributedString
    }
    
    func update(stockStatus: String) {
        let contentString = NSMutableAttributedString(string: stockStatus)
        contentString.attach(systemName: "chevron.right")
        self.attributedText = contentString
    }
}
