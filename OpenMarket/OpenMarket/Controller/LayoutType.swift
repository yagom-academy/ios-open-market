//
//  LayoutType.swift
//  OpenMarket
//
//  Created by 김동욱 on 2022/05/19.
//

import UIKit

enum LayoutType {
    case list
    case grid
    
    var layout: FlowLayout {
        switch self {
        case .list:
            Self.flowLayout.changeLayout(.list)
            return Self.itemSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 14)
        case .grid:
            Self.flowLayout.changeLayout(.grid)
            return Self.itemSize(width: UIScreen.main.bounds.width / 2.2, height: UIScreen.main.bounds.height / 3)
        }
    }
}

extension LayoutType {
    static let flowLayout = FlowLayout()
    
    static func itemSize(width: CGFloat, height: CGFloat) -> FlowLayout {
        flowLayout.itemSize = CGSize(width: width, height: height)
        return flowLayout
    }
}
