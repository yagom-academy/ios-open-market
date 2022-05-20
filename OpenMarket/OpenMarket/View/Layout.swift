//
//  Layout.swift
//  OpenMarket
//
//  Created by cathy, mmim.
//

import UIKit

enum Layout: Int {
  case list = 0
  case grid = 1
  
  var string: String {
    switch self {
    case .list:
      return "LIST"
    case .grid:
      return "GRID"
    }
  }
  
  var builder: UICollectionViewLayout {
    let layout = UICollectionViewFlowLayout()
    layout.sectionInset = UIEdgeInsets(top: 10, left: 5, bottom: 5, right: 5)
    layout.minimumLineSpacing = 8
    layout.minimumInteritemSpacing = 13
    
    switch self {
    case .list:
      layout.itemSize = CGSize(
        width: UIScreen.main.bounds.width - (layout.sectionInset.left + layout.sectionInset.right),
        height: UIScreen.main.bounds.height/Constant.listCellCountPerColumn
      )
    case .grid:
      layout.itemSize = CGSize(
        width:
          UIScreen.main.bounds
          .width/Constant.cellCountPerRow - (layout.minimumInteritemSpacing + layout.sectionInset.left + layout.sectionInset.right),
        height:
          UIScreen.main.bounds
          .height/Constant.gridCellCountPerColumn - layout.minimumInteritemSpacing
      )
    }
    return layout
  }
}
