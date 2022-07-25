//
//  ProductURLQueryItem.swift
//  OpenMarket
//
//  Created by 데릭, 케이, 수꿍.
//

enum ProductURLQueryItem {
    case page_no
    case items_per_page
    
    var value: String {
        switch self {
        case .page_no:
            return "page_no"
        case .items_per_page:
            return "items_per_page"
        }
    }
}
