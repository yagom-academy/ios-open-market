//
//  ModelNameSpace.swift
//  OpenMarket
//
//  Created by unchain, hyeon2 on 2022/07/19.
//

enum ModelNameSpace {
    case pageNo
    case itemsPerPage
    case totalCount
    case offset
    case limit
    case pages
    case lastPage
    case hasNext
    case hasPrev
    case id
    case vendorId
    case name
    case thumbnail
    case currency
    case price
    case bargainPrice
    case dicountedPrice
    case stock
    case createdAt
    case issuedAt
    
    var name: String {
        switch self {
        case .pageNo:
            return "page_no"
        case .itemsPerPage:
            return "items_per_page"
        case .totalCount:
            return "total_count"
        case .offset:
            return "offset"
        case .limit:
            return "limit"
        case .pages:
            return "pages"
        case .lastPage:
            return "last_page"
        case .hasNext:
            return "has_next"
        case .hasPrev:
            return "has_prev"
        case .id:
            return "id"
        case .vendorId:
            return "vendor_id"
        case .name:
            return "name"
        case .thumbnail:
            return "thumbnail"
        case .currency:
            return "currency"
        case .price:
            return "price"
        case .bargainPrice:
            return "bargain_price"
        case .dicountedPrice:
            return "dicounted_price"
        case .stock:
            return "stock"
        case .createdAt:
            return "created_at"
        case .issuedAt:
            return "issued_at"
        }
    }
}
