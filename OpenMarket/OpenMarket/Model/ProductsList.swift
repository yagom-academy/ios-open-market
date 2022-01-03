import Foundation

struct ProductsList: Codable {
    var pageNumber: Int
    var itemsPerPage: Int
    var totalCount: Int
    var offset: Int
    var limit: Int
    var lastPage: Int
    var hasNext: Bool
    var hasPrev: Bool
    var pages: [Product]
    
    private enum CodingKeys: String, CodingKey {
        case pageNumber = "page_no"
        case itemsPerPage, totalCount, offset, limit, lastPage, hasNext, hasPrev, pages
    }
}
