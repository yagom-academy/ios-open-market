//
//  ItemListPage.swift
//  OpenMarket
//
//  Created by minsson, yeton on 2022/07/12.
//

struct ItemListPage: Decodable {
    
    // MARK: - Properties
    
    let pageNumber, itemsPerPage, totalCount, offset: Int
    let limit: Int
    let items: [Item]
    let lastPage: Int
    let hasNext, hasPrevious: Bool
    
    // MARK: - Enums
    
    private enum CodingKeys: String, CodingKey {
        case pageNumber = "page_no"
        case itemsPerPage = "items_per_page"
        case totalCount = "total_count"
        case offset, limit
        case items = "pages"
        case lastPage = "last_page"
        case hasNext = "has_next"
        case hasPrevious = "has_prev"
    }
    
    // MARK: - Nested Struct
    
    struct Item: Decodable {
        
        // MARK: - Properties
        
        let id, vendorID: Int
        let name: String
        let thumbnail: String
        let currency: Currency
        let price, bargainPrice, discountedPrice, stock: Int
        let createdAt, issuedAt: String

        // MARK: - Enums
        
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
}
