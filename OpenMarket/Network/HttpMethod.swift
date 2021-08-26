//
//  HttpMethod.swift
//  OpenMarket
//
//  Created by kjs on 2021/08/17.
//

import Foundation

enum HttpMethod {
    case getGoodsList(pageIndex: UInt)
    case getGoods(id: String)
    case getImage(path: String)
    case postGoods
    case patchGoods(id: String)
    case deleteGoods(id: String)
    
    var type: String {
        switch self {
        case .postGoods:
            return "POST"
        case .deleteGoods:
            return "DELETE"
        case .patchGoods:
            return "PATCH"
        default:
            return "GET"
        }
    }
}
