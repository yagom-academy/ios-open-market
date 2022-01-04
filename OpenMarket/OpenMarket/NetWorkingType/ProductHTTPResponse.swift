import Foundation
// 2 상품등록, 2-1 상품수정 , 2-3 상품삭제 , 2-4 상품상세조회, 
struct ProductHTTPResponse: Codable {
    let id: Int
    let vendorId: Int
    let name: String
    let thumbnail: String
    let currency: Currency
    let price: Int
    let bargainPrice: Int
    let discountedPrice: Int
    let stock: Int
    let images: [Image]?
    let vendors: Vendor?
    let createdAt: String
    let issuedAt: String

    enum CodingKeys: String, CodingKey {
        case id, name, thumbnail, currency, price, stock, images, vendors
        case vendorId = "vendor_id"
        case bargainPrice = "bargain_price"
        case discountedPrice = "discounted_price"
        case createdAt = "created_at"
        case issuedAt = "issued_at"
    }
    
    struct Image: Codable {
        let id: Int
        let url: String
        let thumbnailUrl: String
        let succeed: Bool?
        let issuedAt: String
        
        enum CodingKeys: String, CodingKey {
            case id, url, succeed
            case thumbnailUrl = "thumbnail_url"
            case issuedAt = "issued_at"
        }
    }
    
    struct Vendor: Codable {
        let name: String
        let id: Int
        let createdAt: String
        let issuedAt: String
        
        enum CodingKeys: String, CodingKey {
            case name, id
            case createdAt = "created_at"
            case issuedAt = "issued_at"
        }
    }
}
