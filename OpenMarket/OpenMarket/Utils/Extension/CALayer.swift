//
//  CALayer.swift
//  OpenMarket
//
//  Created by 김동욱 on 2022/05/17.
//

import UIKit

extension CALayer {
    @discardableResult
    func addBorder(edges: [UIRectEdge], color: UIColor, thickness: CGFloat, bottomLeftSpacing: CGFloat = 0, radius: CGFloat = 0) -> CALayer {
        let border = CALayer()
        for edge in edges {
            switch edge {
            case .top:
                border.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: thickness)
            case .bottom:
                border.frame = CGRect.init(x: bottomLeftSpacing, y: frame.height - thickness, width: frame.width, height: thickness)
            case .left:
                border.frame = CGRect.init(x: 0, y: 0, width: thickness, height: frame.height)
            case .right:
                border.frame = CGRect.init(x: frame.width, y: 0, width: thickness, height: frame.height)
            case .all:
                borderColor = color.cgColor
                borderWidth = thickness
            default:
                return CALayer()
            }
            cornerRadius = radius
            border.backgroundColor = color.cgColor
        }
        return border
    }
}
