//
//  Request.swift
//  OpenMarket
//
//  Created by 이윤주 on 2021/09/02.
//

import Foundation

enum Request: RequestAPI {
    case getList
    case getItem
    case postItem
    case patchItem
    case deleteItem
    
    static let baseURL = "https://camp-open-market-2.herokuapp.com"
    
    var path: String {
        switch self {
        case .getList:
            return "/items"
        default:
            return "/item"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getList, .getItem :
            return .get
        case .postItem:
            return .post
        case .patchItem:
            return .patch
        case .deleteItem:
            return .delete
        }
    }
    
    var body: Data? {
        return Data()
    }
}
