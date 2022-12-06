//  LayoutConstants.swift
//  OpenMarket
//  Created by SummerCat on 2022/12/06.

enum LayoutConstants {
    case listCellContentInset
    case gridCellSectionInset
    case gridCellMinimumLineSpacing
    case gridCellMinimumInteritemSpacing
    case gridPerRow
    case gridPerCol
    
    var value: Double {
        switch self {
        case .listCellContentInset:
            return 5
        case .gridCellSectionInset:
            return 10
        case .gridCellMinimumLineSpacing:
            return 10
        case .gridCellMinimumInteritemSpacing:
            return 5
        case .gridPerRow:
            return 2
        case .gridPerCol:
            return 3
        }
    }
}
