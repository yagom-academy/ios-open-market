//
//  NetworkNamespace.swift
//  OpenMarket
//
//  Created by unchain, hyeon2 on 2022/07/14.
//

enum NetworkNamespace: String {
    case get
    case post
    case patch
    case del
    case url
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
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .patch:
            return "PATCH"
        case .del:
            return "DEL"
        case .url:
            return "https://market-training.yagom-academy.kr/api/products"
        case .pageNo:
            return "pageNo"
        case .itemsPerPage:
            return "itemsPerPage"
        case .totalCount:
            return "totalCount"
        case .offset:
            return "offset"
        case .limit:
            return "limit"
        case .pages:
            return "pages"
        case .lastPage:
            return "lastPage"
        case .hasNext:
            return "hasNext"
        case .hasPrev:
            return "hasPrev"
        case .id:
            return "id"
        case .vendorId:
            return "vendorId"
        case .name:
            return "name"
        case .thumbnail:
            return "thumbnail"
        case .currency:
            return "currency"
        case .price:
            return "price"
        case .bargainPrice:
            return "bargainPrice"
        case .dicountedPrice:
            return "dicountedPrice"
        case .stock:
            return "stock"
        case .createdAt:
            return "createdAt"
        case .issuedAt:
            return "issuedAt"
        }
    }
}
