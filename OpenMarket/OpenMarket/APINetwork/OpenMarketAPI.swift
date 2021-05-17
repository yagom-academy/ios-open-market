//
//  OpenMarketAPI.swift
//  OpenMarket
//
//  Created by Seungjin Baek on 2021/05/13.
//

import Foundation

enum OpenMarketAPI {
    static let baseURL = "https://camp-open-market-2.herokuapp.com/"
    
}

enum HTTPMethod {
    case get
    case post
    case patch
    case delete
    
    var description: String {
        switch self {
        case .get : return "GET"
        case .post : return "POST"
        case .patch : return "PATCH"
        case .delete : return "DELETE"
        }
    }
}

enum OpenMarketAPIPathByDescription: CustomStringConvertible {
    // customdebugstringconvertible
    case itemListSearch
    case itemRegister
    case itemSearch
    case itemEdit
    case itemDeletion

    var description: String {
        switch self {
        case .itemListSearch:
            return "items/"
        default:
            return "item/"
        }
    }
}
