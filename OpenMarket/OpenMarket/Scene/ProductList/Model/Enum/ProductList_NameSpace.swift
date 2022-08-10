//
//  ProductList_NameSpace.swift
//  OpenMarket
//
//  Created by groot, bard on 2022/07/19.
//

enum Product {
    case page
    case itemPerPage
    
    var text: String {
        switch self {
        case .page:
            return "page_no"
        case .itemPerPage:
            return "items_per_page"
        }
    }
    
    var number: Int {
        switch self {
        case .page:
            return 1
        case .itemPerPage:
            return 30
        }
    }
}
