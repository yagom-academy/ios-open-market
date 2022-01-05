//
//  OpenMarketURL.swift
//  OpenMarket
//
//  Created by Seul Mac on 2022/01/05.
//

import Foundation

enum URLManager {
    static let apiHost: String = "https://market-training.yagom-academy.kr/"
    case healthChecker
    case checkProductDetail(id: Int)
    case checkProductList
    
    var url: URL {
        switch self {
        case .healthChecker:
            return URL(string: URLManager.apiHost + "healthChecker")!
        case .checkProductDetail(let id):
            return URL(string: URLManager.apiHost + "api/products/" + "\(id)")!
        case .checkProductList:
            return URL(string: URLManager.apiHost + "api/products?page-no=1&items-per-page=10")!
        }
    }
    
}
