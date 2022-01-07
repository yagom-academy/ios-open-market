//
//  APIAddress.swift
//  OpenMarket
//
//  Created by 고은 on 2022/01/07.
//

import Foundation

enum APIType: CustomStringConvertible {
    static let apiHost = "https://market_training.yagom_academy.kr/"
    
    case healthChecker
    case productDetail(id: Int)
    case productList(pageNo: Int, items: Int)
    
    var description: String {
        switch self {
        case .healthChecker:
            return "\(APIType.apiHost)\(self)"
        case .productDetail(let id):
            return "\(APIType.apiHost)api/products/\(id)"
        case .productList(let pageNo, let items):
            return "\(APIType.apiHost)api/products?page_no=\(pageNo)&items_per_page=\(items)/"
        }
    }
}
