//  Created by Aejong, Tottale on 2022/11/15.

import UIKit

struct ProductList: Decodable {
    
    let pageNumber: Int
    let itemsPerPage: Int
    let totalCount: Int
    let offset: Int
    let limit: Int
    let lastPage: Int
    let hasNext: Bool
    let hasPrev: Bool
    let pages: [Product]
    
    enum CodingKeys: String, CodingKey {
        
        case offset, limit, pages, itemsPerPage, totalCount, hasNext, hasPrev, lastPage
        case pageNumber = "pageNo"
    }
}

struct Product: Decodable, Hashable {
    
    let id: Int
    let vendorID: Int
    let vendorName: String?
    let name: String
    let description: String
    let thumbnail: String
    let currency: String
    let price: Double
    let bargainPrice: Double
    let discountedPrice: Double
    let stock: Int
    let images: [Image]?
    let vendors: Vendors?
    let createdAt: String
    let issuedAt: String
    
    enum CodingKeys: String, CodingKey {
        
        case images, vendors, name, currency, thumbnail, price, stock, vendorName, description, id
        case vendorID = "vendor_id"
        case bargainPrice = "bargain_price"
        case discountedPrice = "discounted_price"
        case createdAt = "created_at"
        case issuedAt = "issued_at"
    }
}

struct Image: Decodable, Hashable {
    
    let id: Int?
    let url, thumbnailURL: String?
    let issuedAt: String?
    
    enum CodingKeys: String, CodingKey {
        
        case id, url
        case thumbnailURL = "thumbnail_url"
        case issuedAt = "issued_at"
    }
}

struct Vendors: Decodable, Hashable {
    
    let id: Int?
    let name: String?
}
