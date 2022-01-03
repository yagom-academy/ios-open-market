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
    var createdAt: Date
    var issuedAt: Date
}
