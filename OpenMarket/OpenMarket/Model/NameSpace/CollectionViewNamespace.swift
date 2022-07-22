//
//  CollectionViewNamespace.swift
//  OpenMarket
//
//  Created by unchain, hyeon2 on 2022/07/22.
//

enum CollectionViewNamespace {
    case list
    case grid
    case plus
    
    var name: String {
        switch self {
        case .list:
            return "LIST"
        case .grid:
            return "GRID"
        case .plus:
            return  "plus"
        }
    }
}
