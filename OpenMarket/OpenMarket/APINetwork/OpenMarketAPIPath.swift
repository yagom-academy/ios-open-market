//
//  OpenMarketAPI.swift
//  OpenMarket
//
//  Created by Seungjin Baek on 2021/05/13.
//

import Foundation

//enum OpenMarketAPIPath {
//
//    static let baseURL = "https://camp-open-market-2.herokuapp.com/"
//
//    case itemListSearch
//    case itemRegister
//    case itemSearch
//    case itemEdit
//    case itemDeletion
//
//    var path: String {
//        switch self {
//        case .itemListSearch:
//            return OpenMarketAPIPath.baseURL + "items/"
//        default:
//            return OpenMarketAPIPath.baseURL + "item/"
//        }
//    }
//}

struct OpenMarketAPIPath {
    private let baseURL = "https://camp-open-market-2.herokuapp.com/"
    let isItemList: Bool
    
    var path: String {
        if isItemList {
            return baseURL + "items/"
        } else {
            return baseURL + "item/"
        }
    }
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
