//
//  OpenMarket - NameSpace.swift
//  Created by Zhilly, Dragon. 22/11/25
//  Copyright © yagom. All rights reserved.
//

enum NameSpace {
    case nextLine
    
    var text: String {
        switch self {
        case .nextLine:
            return "\n"
        }
    }
}
