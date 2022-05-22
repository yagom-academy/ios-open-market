//
//  NSMutableAttributedString.swift
//  OpenMarket
//
//  Created by 박세리 on 2022/05/20.
//

import UIKit

extension NSMutableAttributedString {
    func attach(systemName: String) {
        let attachment = NSTextAttachment()
        attachment.image = UIImage(systemName: systemName)?.withTintColor(.systemGray)
        attachment.bounds = CGRect(x: 0, y: 1, width: 10, height: 10)
        let attachmentString = NSAttributedString(attachment: attachment)
        self.append(attachmentString)
    }
}
