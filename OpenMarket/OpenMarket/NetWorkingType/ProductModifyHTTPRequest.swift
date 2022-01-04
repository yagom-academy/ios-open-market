import Foundation

struct ProductModifyHTTPRequest: Codable {
    let name: String?
    let description: String?
    let thumbnailId: Int?
    let price: Int?
    let currency: Currency?
    let discountedPrice: Int?
    let stock: Int?
    let secret: String
    
    enum CodingKeys: String, CodingKey {
        case name, description, price, currency, stock, secret
        case thumbnailId = "thumbnail_id"
        case discountedPrice = "discounted_price"
    }
}
