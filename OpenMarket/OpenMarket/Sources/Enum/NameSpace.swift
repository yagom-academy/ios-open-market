//
//  OpenMarket - NameSpace.swift
//  Created by Zhilly, Dragon. 22/11/25
//  Copyright © yagom. All rights reserved.
//

enum NameSpace {
    case whiteSpace
    case doubleWhiteSpace
    case nextLine
    
    var text: String {
        switch self {
        case .whiteSpace:
            return " "
        case .doubleWhiteSpace:
            return "  "
        case .nextLine:
            return "\n"
        }
    }
}
