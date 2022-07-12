//
//  ItemListPage.swift
//  OpenMarket
//
//  Created by 민쏜, 예톤 on 2022/07/12.
//

// MARK: - ItemListPage
struct ItemListPage: Decodable {
    let pageNo, itemsPerPage, totalCount, offset: Int
    let limit: Int
    let items: [Item]
    let lastPage: Int
    let hasNext, hasPrev: Bool
    
    struct Item: Decodable {
        let id, vendorID: Int
        let name: String
        let thumbnail: String
        let currency: Currency
        let price, bargainPrice, discountedPrice, stock: Int
        let createdAt, issuedAt: String
        
        enum Currency: String, Decodable {
            case krw = "KRW"
            case usd = "USD"
            case hkd = "HKD"
            case jpy = "JPY"
        }

        private enum CodingKeys: String, CodingKey {
            case id
            case vendorID = "vendor_id"
            case name, thumbnail, currency, price
            case bargainPrice = "bargain_price"
            case discountedPrice = "discounted_price"
            case stock
            case createdAt = "created_at"
            case issuedAt = "issued_at"
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case pageNo = "page_no"
        case itemsPerPage = "items_per_page"
        case totalCount = "total_count"
        case offset, limit
        case items = "pages"
        case lastPage = "last_page"
        case hasNext = "has_next"
        case hasPrev = "has_prev"
    }
}
