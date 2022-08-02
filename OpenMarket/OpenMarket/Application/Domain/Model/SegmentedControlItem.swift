//
//  SegmentedControlItem.swift
//  OpenMarket
//
//  Created by 데릭, 수꿍.
//

enum SegmentedControlItem {
    case list
    case grid
    
    var name: String {
        switch self {
        case .list:
            return "LIST"
        case .grid:
            return "GRID"
        }
    }
}
