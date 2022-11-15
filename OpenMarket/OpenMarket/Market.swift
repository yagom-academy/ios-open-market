//
//  Market.swift
//  OpenMarket
//
//  Created by 써니쿠키, 메네 on 15/11/2022.
//

import Foundation

struct Market: Decodable {
    let pageNo: Int
    let itemsPerPage: Int
    let totalCount: Int
    let offset: Int
    let limit: Int
    let pages: [Page]
    let lastPage: Int
    let hasNext: Bool
    let hasPrev: Bool
    
    struct Page: Decodable {
        let id: Int
        let vendorId: Int
        let name: String
        let description: String
        let thumbnail: String
        let currency: Currency
        let price: Double
        let bargainPrice: Double
        let discountedPrice: Double
        let stock: Int
        let createdAt: String
        let issuedAt: String
        let images: [Image]?
        let vendors: Vendors?
        
        struct Image: Decodable {
            let id: Int
            let url: String
            let thumbnailUrl: String
            let issuedAt: String
        }

        struct Vendors: Decodable {
            let id: Int
            let name: String
        }
    }
    
    enum Currency: String, Decodable {
        case krw = "KRW"
        case usd = "USD"
    }
    
    
}
