//
//  RequestType.swift
//  OpenMarket
//
//  Created by Kiwi, Hugh on 2022/07/12.
//

enum RequestType {
    case get
    
    var method: String {
        switch self {
        case .get:
            return "GET"
        }
    }
}
