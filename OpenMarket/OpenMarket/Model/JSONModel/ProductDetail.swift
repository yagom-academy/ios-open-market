import Foundation

struct ProductDetail: Codable {
    let id, vendorID: Int
    let name: String
    let thumbnail: String
    let currency: String
    let price, bargainPrice, discountedPrice, stock: Int
    let createdAt, issuedAt: String
    let images: [Image]?
    let vendors: Vendors?
    
    enum CodingKeys: String, CodingKey {
        case id
        case vendorID = "vendor_id"
        case name, thumbnail, currency, price
        case bargainPrice = "bargain_price"
        case discountedPrice = "discounted_price"
        case stock
        case createdAt = "created_at"
        case issuedAt = "issued_at"
        case images, vendors
    }
}
