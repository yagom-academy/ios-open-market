//
//  UIView+extension.swift
//  OpenMarket
//
//  Created by groot, bard on 2022/07/27.
//
import UIKit.UIView

extension UIView {
    func setupBoder(cornerRadius: CGFloat, borderWidth: CGFloat, borderColor: CGColor?) {
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor
    }
}
