import Foundation

struct ProductList {
    var pageNu: Int
    var itemsPerPage: Int
    var totalCount: Int
    var offset: Int
    var limit: Int
    var lastPage: Int
    var hasNext: Bool
    var hasPrev: Bool
    var pages: [Product]

    enum CodingKeys: String, CodingKey {
        case pageNu = "page_no"
        case itemsPerPage = "items_per_page"
        case totalCount = "total_count"
        case offset
        case limit
        case lastPage = "last_page"
        case hasNext = "has_next"
        case hasPrev = "has_prev"
        case pages
    }
}
