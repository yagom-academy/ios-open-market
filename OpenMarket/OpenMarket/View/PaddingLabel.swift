//
//  PaddingLabel.swift
//  OpenMarket
//
//  Created by BaekGom, Brad on 2022/07/20.
//

import UIKit

@IBDesignable class PaddingLabel: UILabel {
    
    @IBInspectable private var topInset: CGFloat = 0.0
    @IBInspectable private var bottomInset: CGFloat = 0.0
    @IBInspectable private var leftInset: CGFloat = 0.0
    @IBInspectable private var rightInset: CGFloat = 0.0
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset, height: size.height + topInset + bottomInset)
    }
}
