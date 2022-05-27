//
//  LayoutType.swift
//  OpenMarket
//
//  Created by 김동욱 on 2022/05/19.
//

import UIKit

enum LayoutType: Int, CaseIterable {
    case list = 0
    case grid = 1
    
    static var inventory: [String] {
        return Self.allCases.map { $0.description }
    }
    
    private var description: String {
        switch self {
        case .list:
            return "List"
        case .grid:
            return "Grid"
        }
    }
    
    var cell: CustomCell.Type {
        switch self {
        case .list:
            return ListCell.self
        case .grid:
            return GridCell.self
        }
    }
}
