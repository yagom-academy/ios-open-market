//
//  OpenMarketURL.swift
//  OpenMarket
//
//  Created by Kiwi, Hugh on 2022/07/28.
//

enum OpenMarketURL: CustomStringConvertible {
    case baseURL
    case pageNumberQuery
    case itemsPerPageQuery
    
    var description: String {
        switch self {
        case .baseURL:
            return "https://market-training.yagom-academy.kr/api/products"
        case .pageNumberQuery:
            return "page_no"
        case .itemsPerPageQuery:
            return "items_per_page"
        }
    }
}
