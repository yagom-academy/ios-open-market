//
//  LayoutSize.swift
//  OpenMarket
//
//  Created by 박병호 on 2022/01/17.
//

import UIKit

struct LayoutConstant {
  static func cellSize(cellType: CellType, width: CGFloat) -> CGSize {
    switch cellType {
    case .list:
      return CGSize(width: width, height: width / 7)
    case .grid:
      return CGSize(width: width / 2.2, height: width / 1.55)
    }
  }
  
  static var insetForSectionAtList: UIEdgeInsets {
    return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
  }
  
  static var insetForSectionAtGrid: UIEdgeInsets {
    return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
  }
  
  static var minimumLineSpacingForSectionAtList: CGFloat {
    return 5
  }
  
  static var minimumLineSpacingForSectionAtGrid: CGFloat {
    return 8
  }
}
