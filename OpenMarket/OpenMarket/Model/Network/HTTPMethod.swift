//
//  HTTPMethod.swift
//  OpenMarket
//
//  Created by Kiwi, Hugh on 2022/07/28.
//

enum HTTPMethod {
    case get
    
    var request: String {
        switch self {
        case .get:
            return "GET"
        }
    }
}
