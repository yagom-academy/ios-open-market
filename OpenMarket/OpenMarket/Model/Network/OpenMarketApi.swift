//
//  ApiUrl.swift
//  OpenMarket
//
//  Created by 우롱차, Donnie on 2022/05/11.
//

import Foundation

enum OpenMarketApi {
    private static let hostUrl = "https://market-training.yagom-academy.kr/"
    
    case pageInformation(pageNo: Int, itemsPerPage: Int)
    case productDetail(productNumber: Int)
    case productRegister
    
    private var urlString: String {
        switch self {
        case .pageInformation(let pageNo, let itemsPerPage):
            return Self.hostUrl + "api/products?page_no=\(pageNo)&items_per_page=\(itemsPerPage)"
        case .productDetail(let productNumber):
            return Self.hostUrl + "api/products/\(productNumber)"
        case .productRegister:
            return Self.hostUrl + "api/products"
        }
    }
    
    var url: URL? {
            let urlComponents = URLComponents(string: self.urlString)
            return urlComponents?.url
    }
}
