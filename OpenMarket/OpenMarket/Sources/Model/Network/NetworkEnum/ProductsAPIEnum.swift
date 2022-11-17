//
//  OpenMarket - ProductsAPIEnum.swift
//  Created by Zhilly, Dragon. 22/11/16
//  Copyright © yagom. All rights reserved.
//

enum ProductsAPIEnum {
    case hostUrl
    case healthChecker
    case pageNumber
    case bridge
    case itemPerPage
    case searchValue
    case products
    
    var address: String {
        switch self {
        case .hostUrl:
            return "https://openmarket.yagom-academy.kr"
        case .healthChecker:
            return "/healthChecker"
        case .pageNumber:
            return "page_no="
        case .bridge:
            return "&"
        case .itemPerPage:
            return "items_per_page="
        case .searchValue:
            return "searchValue="
        case .products:
            return "/api/products?"
        }
    }
}
