//
//  OpenMarket - HttpMethod.swift
//  Created by Zhilly, Dragon. 22/11/16
//  Copyright © yagom. All rights reserved.
//

enum HttpMethod {
    case get
    case post
    case patch
    case delete
    
    var name: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .patch:
            return "PATCH"
        case .delete:
            return "DELETE"
        }
    }
}
