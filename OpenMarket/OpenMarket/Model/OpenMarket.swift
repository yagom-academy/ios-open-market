import Foundation

struct OpenMarket: Codable {
    let pageNo, itemsPerPage, totalCount, offset: Int
    let limit: Int
    let pages: [OpenMarketPage]
    let lastPage: Int
    let hasNext, hasPrev: Bool

    enum CodingKeys: String, CodingKey {
        case pageNo = "page_no"
        case itemsPerPage = "items_per_page"
        case totalCount = "total_count"
        case offset, limit, pages
        case lastPage = "last_page"
        case hasNext = "has_next"
        case hasPrev = "has_prev"
    }
}

struct OpenMarketPage: Codable {
    let id, vendorID: Int
    let name: String
    let thumbnail: String
    let currency: String
    let price, bargainPrice, discountedPrice, stock: Int
    let createdAt, issuedAt: String

    enum CodingKeys: String, CodingKey {
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
