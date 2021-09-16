//
//  CGFloat.swift
//  OpenMarket
//
//  Created by 박태현 on 2021/09/16.
//

import UIKit

extension CGFloat {
    static func / (lhs: CGFloat, rhs: Int) -> CGFloat {
        return lhs / CGFloat(rhs)
    }

    static func * (lhs: CGFloat, rhs: Int) -> CGFloat {
        return lhs * CGFloat(rhs)
    }
}
