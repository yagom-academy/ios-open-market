import Foundation

struct ProductsList: Decodable {
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
        case pageNumber = "pageNo"
        case itemsPerPage, totalCount, offset, limit, lastPage, hasNext, hasPrev, pages
    }
}
