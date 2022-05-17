//
//  UILabel+Extension.swift
//  OpenMarket
//
//  Created by Red, Mino on 2022/05/16.
//

import UIKit

extension UILabel {
    func addStrikeThrough(price: Double) {
        let underlineAttriString = NSAttributedString(
            string: String(price),
            attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue]
        )
        
        self.attributedText = underlineAttriString
    }
    
    func update(with currency: String, price: Double) {
        let numberfommater = NumberFormatter()
        numberfommater.numberStyle = .decimal

        guard let fomattedNumber = numberfommater.string(from: price as NSNumber) else {
            return
        }
        
        self.text = "\(currency) \(fomattedNumber)"
    }
    
    func update(by stock: Int) {
        let attachment = NSTextAttachment()
        attachment.image = UIImage(systemName: "chevron.right")?.withTintColor(.systemGray)
        attachment.bounds = CGRect(x: 0, y: 1, width: 10, height: 10)
        let attachmentString = NSAttributedString(attachment: attachment)
        let contentString = NSMutableAttributedString(string: stock == 0 ? "품절 " : "잔여수량 : \(stock) ")
        contentString.append(attachmentString)
        self.attributedText = contentString
    }
}
