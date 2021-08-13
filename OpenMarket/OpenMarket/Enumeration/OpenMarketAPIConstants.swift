//
//  OpenMarketAPIConstants.swift
//  OpenMarket
//
//  Created by 김준건 on 2021/08/13.
//

import Foundation

enum OpenMarketAPIConstants {
    case listGet
    case post
    case itemGet
    case patch
    case delete
    
    static let baseURL = "https://camp-open-market-2.herokuapp.com/"
    static let rangeOfSuccessState = 200...299

    var path: String {
        switch self {
        case .listGet:
            return Self.baseURL + "items/"
        case .post:
            return Self.baseURL + "item"
        case .itemGet, .patch, .delete:
            return Self.baseURL + "item/"
        }
    }
    
    var method: String {
        switch self {
        case .listGet, .itemGet:
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
