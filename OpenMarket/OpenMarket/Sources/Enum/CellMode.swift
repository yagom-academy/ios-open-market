//
//  OpenMarket - CellMode.swift
//  Created by Zhilly, Dragon. 22/11/29
//  Copyright © yagom. All rights reserved.
//

enum CellMode {
    case listType
    case gridType
    
    var index: Int {
        switch self {
        case .listType:
            return 0
        case .gridType:
            return 1
        }
    }
}
