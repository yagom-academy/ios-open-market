//  UILabel+.swift
//  OpenMarket
//  Created by SummerCat on 2022/12/06.

import UIKit

extension UILabel {
    static func createLabel(font: UIFont, textAlignment: NSTextAlignment, textColor: UIColor = .label) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = font
        label.textAlignment = textAlignment
        label.textColor = textColor
        return label
    }
}
