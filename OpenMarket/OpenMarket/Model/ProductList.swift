//  Created by Aejong, Tottale on 2022/11/15.

struct ProductList: Codable {
    
    let pageNumber: Int
    let itemsPerPage: Int
    let totalCount: Int
    let offset: Int
    let limit: Int
    let lastPage: Int
    let hasNext: Bool
    let hasPrev: Bool
    let pages: [ProductForPage]
    
    enum CodingKeys: String, CodingKey {
        
        case offset, limit, pages, itemsPerPage, totalCount, hasNext, hasPrev, lastPage
        case pageNumber = "pageNo"
    }
}

struct ProductForPage: Codable {
    
    let productID: Int
    let vendorID: Int
    let vendorName: String
    let name: String
    let description: String
    let thumbnail: String
    let currency: String
    let price: Double
    let bargainPrice: Double
    let discountedPrice: Double
    let stock: Int
    let createdAt: String
    let issuedAt: String
    
    enum CodingKeys: String, CodingKey {
        
        case name, currency, thumbnail, price, stock, vendorName, description
        case productID = "id"
        case vendorID = "vendor_id"
        case bargainPrice = "bargain_price"
        case discountedPrice = "discounted_price"
        case createdAt = "created_at"
        case issuedAt = "issued_at"
    }
}
