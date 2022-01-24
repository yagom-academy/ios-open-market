//
//  GetType.swift
//  OpenMarket
//
//  Created by 고은 on 2022/01/22.
//

import Foundation

enum GetType {
    case healthChecker
    case productDetail(productID: Int)
    case productList(pageNo: Int, items: Int)
    
    func url(type: GetType) -> String {
        switch type {
        case .healthChecker:
            return "\(RequestType.apiHost)/\(self)"
        case .productDetail(let productID):
            return "\(RequestType.apiHost)/api/products/\(productID)"
        case .productList(let pageNo, let items):
            return "\(RequestType.apiHost)/api/products?page_no=\(pageNo)&items_per_page=\(items)"
        }
    }
}
