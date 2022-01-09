import Foundation

enum ProductListAsk {
    struct Response: Decodable {
        let pageNo: Int
        let itemsPerPage: Int
        let totalCount: Int
        let offset: Int
        let limit: Int
        let lastPage: Int
        let hasNext: Bool
        let hasPrev: Bool
        let pages: [Page]
        
        enum CodingKeys: String, CodingKey {
            case offset, limit, pages
            case pageNo = "page_no"
            case itemsPerPage = "items_per_page"
            case totalCount = "total_count"
            case lastPage = "last_page"
            case hasNext = "has_next"
            case hasPrev = "has_prev"
        }
        
        struct Page: Decodable {
            let id: Int
            let vendorId: Int
            let name: String
            let thumbnail: String
            let currency: Currency
            let price: Int
            let bargainPrice: Int
            let discountedPrice: Int
            let stock: Int
            let createdAt: String
            let issuedAt: String
            
            enum CodingKeys: String, CodingKey {
                case id, name, thumbnail, currency, price, stock
                case vendorId = "vendor_id"
                case bargainPrice = "bargain_price"
                case discountedPrice = "discounted_price"
                case createdAt = "created_at"
                case issuedAt = "issued_at"
            }
        }
    }
}

