//
//  APIAddress.swift
//  OpenMarket
//
//  Created by 고은 on 2022/01/07.
//

import Foundation

enum RequestType {
    static let apiHost = "https://market_training.yagom_academy.kr/"

    case healthChecker
    case productRegistration
    case productModification(productID: Int)
    case searchSecretIDForDelete(productID: Int)
    case productDelete(productID: Int, productSecretKey: Int)
    case productDetail(productID: Int)
    case productList(pageNo: Int, items: Int)

    func url(type: RequestType) -> String {
        switch type {
        case .healthChecker:
            return "(RequestType.apiHost)(self)"
        case .productRegistration:
            return "(RequestType.apiHost)/api/products"
        case .productModification(let productID):
            return "(RequestType.apiHost)/api/products/\(productID)"
        case .searchSecretIDForDelete(let productID):
            return "(RequestType.apiHost)/api/products/\(productID)/secret"
        case .productDelete(let productID, let productSecretKey):
            return "(RequestType.apiHost)/api/products/\(productID)/\(productSecretKey)"
        case .productDetail(let productID):
            return "(RequestType.apiHost)api/products/\(productID)"
        case .productList(let pageNo, let items):
            return "(RequestType.apiHost)api/products?page_no=\(pageNo)&items_per_page=\(items)/"
        }
    }
}
