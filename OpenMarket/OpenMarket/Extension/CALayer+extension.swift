//
//  CALayer+extension.swift
//  OpenMarket
//
//  Created by tae hoon park on 2021/09/09.
//

import UIKit

extension CALayer {
    func addBorder(
        edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        let border = CALayer()
        switch edge {
        case .top:
            border.frame =
                CGRect(x: 0, y: 0, width: frame.width, height: thickness)
        case .bottom:
            border.frame =
                CGRect(x: 0, y: frame.height - thickness, width: frame.width * 3, height: thickness)
        case .left:
            border.frame =
                CGRect(x: 0, y: 0, width: thickness, height: frame.height)
        case .right:
            border.frame =
                CGRect(x: frame.width - thickness, y: 0, width: thickness, height: frame.height)
        default:
            break
        }
        border.backgroundColor = color.cgColor
        addSublayer(border)
    }
}
