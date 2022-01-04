import Foundation

struct Product: Codable {
    var id: Int
    var vendorId: Int
    var name: String
    var thumbnail: String
    var currency: Currency
    var price: Int
    var bargainPrice: Int
    var discountedPrice: Int
    var stock: Int
    var images: [Image]?
    var vendor: Vendor?
    var createdAt: Date
    var issuedAt: Date
    
    private enum CodingKeys: String, CodingKey {
        case vendor = "vendors"
        case id, vendorId, name, thumbnail, currency, price, bargainPrice, discountedPrice, stock, images, createdAt, issuedAt
    }
}
