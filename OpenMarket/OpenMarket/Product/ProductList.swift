//
//  ProductList.swift
//  OpenMarket
//
//  Created by dudu, safari on 2022/05/09.
//

import Foundation

struct ProductList: Codable {
    let pageNo: Int
    let itemsPerPage: Int
    let totalCount: Int
    let offset: Int
    let limit: Int
    let pages: [Page]
    let lastPage: Int
    let hasNext: Bool
    let hasPrev: Bool
    
    struct Page: Codable {
        let id: Int
        let vendorId: Int
        let name: String
        let thumbnail: String
        let currency: Currency
        let price: Double
        let bargainPrice: Double
        let discountedPrice: Double
        let stock: Int
        let createdAt: Date
        let issuedAt: Date
        
        enum Currency: String, Codable {
            case KRW = "KRW"
            case USD = "USD"
        }
    }
}


