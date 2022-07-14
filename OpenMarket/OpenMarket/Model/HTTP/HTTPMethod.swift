//
//  RequestType.swift
//  OpenMarket
//
//  Created by Kiwi, Hugh on 2022/07/12.
//

enum HTTPMethod {
    case get
    
    var type: String {
        switch self {
        case .get:
            return "GET"
        }
    }
}
